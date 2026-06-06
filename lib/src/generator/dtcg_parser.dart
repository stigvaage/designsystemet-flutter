import 'dart:convert';
import 'dart:io';

/// The result of parsing a single theme directory, containing light/dark
/// color scales, size values, and border radii.
class ParsedTheme {
  final String name;
  final Map<String, ParsedColorScale> lightColors;
  final Map<String, ParsedColorScale> darkColors;
  final Map<String, double> sizes;
  final Map<String, double> borderRadii;

  const ParsedTheme({
    required this.name,
    required this.lightColors,
    required this.darkColors,
    required this.sizes,
    required this.borderRadii,
  });
}

/// A map of token names to hex color strings for a single color scale.
class ParsedColorScale {
  final Map<String, String> tokens; // token-name -> hex color
  const ParsedColorScale(this.tokens);
}

/// Parses a DTCG (Design Token Community Group) JSON token directory
/// into a list of [ParsedTheme] objects.
class DtcgParser {
  /// Matches a DTCG alias reference such as `{color.accent.base-default}`.
  static final RegExp _aliasPattern = RegExp(r'^\{.+\}$');

  /// Maximum alias-resolution recursion depth (cycle / runaway guard).
  static const int _maxAliasDepth = 16;

  /// Parses a design-tokens/ directory and returns parsed themes.
  List<ParsedTheme> parse(String tokensDir) {
    final dir = Directory(tokensDir);
    if (!dir.existsSync()) {
      throw DtcgParseException('Token directory not found: $tokensDir');
    }

    final themesDir = Directory('$tokensDir/themes');
    if (!themesDir.existsSync()) {
      throw DtcgParseException('No themes/ subdirectory found in $tokensDir');
    }

    final themes = <ParsedTheme>[];

    for (final themeDir in themesDir.listSync().whereType<Directory>()) {
      final themeName = themeDir.uri.pathSegments
          .where((s) => s.isNotEmpty)
          .last;

      final lightFile = File('${themeDir.path}/light.json');
      final darkFile = File('${themeDir.path}/dark.json');
      final globalFile = File('${themeDir.path}/global.json');

      final lightColors = lightFile.existsSync()
          ? _parseColorFile(lightFile)
          : <String, ParsedColorScale>{};
      final darkColors = darkFile.existsSync()
          ? _parseColorFile(darkFile)
          : <String, ParsedColorScale>{};

      var sizes = <String, double>{};
      var borderRadii = <String, double>{};
      if (globalFile.existsSync()) {
        final globalData = _readJson(globalFile);
        sizes = _parseDimensionGroup(globalData, 'size');
        borderRadii = _parseDimensionGroup(globalData, 'border-radius');
      }

      themes.add(
        ParsedTheme(
          name: themeName,
          lightColors: lightColors,
          darkColors: darkColors,
          sizes: sizes,
          borderRadii: borderRadii,
        ),
      );
    }

    if (themes.isEmpty) {
      throw DtcgParseException('No themes found in $tokensDir/themes/');
    }

    return themes;
  }

  Map<String, ParsedColorScale> _parseColorFile(File file) {
    final data = _readJson(file);
    final scales = <String, ParsedColorScale>{};

    final colorGroup = data['color'];
    if (colorGroup is! Map<String, dynamic>) return scales;

    for (final entry in colorGroup.entries) {
      final scaleName = entry.key;
      final scaleData = entry.value;
      if (scaleData is! Map<String, dynamic>) continue;

      final tokens = <String, String>{};
      for (final tokenEntry in scaleData.entries) {
        final tokenData = tokenEntry.value;
        if (tokenData is Map<String, dynamic> &&
            tokenData[r'$value'] is String) {
          final value = tokenData[r'$value'] as String;
          tokens[tokenEntry.key] = _resolveColorValue(
            value,
            data,
            file,
            'color.$scaleName.${tokenEntry.key}',
          );
        }
      }
      if (tokens.isNotEmpty) {
        scales[scaleName] = ParsedColorScale(tokens);
      }
    }

    return scales;
  }

  /// Resolves a DTCG color `$value`, following alias references like
  /// `{color.accent.base-default}` against [tree].
  ///
  /// Literal hex strings are returned unchanged. References that cannot be
  /// resolved within the same file throw a [DtcgParseException] naming the
  /// offending path, instead of being silently emitted as non-compiling
  /// `Color(0x{...})` garbage downstream.
  String _resolveColorValue(
    String value,
    Map<String, dynamic> tree,
    File file,
    String path, {
    int depth = 0,
  }) {
    final trimmed = value.trim();
    if (!_aliasPattern.hasMatch(trimmed)) {
      return trimmed; // Literal value (e.g. a hex string).
    }
    if (depth > _maxAliasDepth) {
      throw DtcgParseException(
        'Alias-referansen "$path" i ${file.path} er for dypt nøstet eller '
        'sirkulær (over $_maxAliasDepth nivåer).',
      );
    }

    final reference = trimmed.substring(1, trimmed.length - 1);
    final resolved = _lookupTokenValue(reference, tree);
    if (resolved == null) {
      throw DtcgParseException(
        'Kunne ikke løse opp alias-referansen "{$reference}" '
        '(fra "$path") i ${file.path}. Referansen må finnes i samme fil.',
      );
    }
    return _resolveColorValue(
      resolved,
      tree,
      file,
      reference,
      depth: depth + 1,
    );
  }

  /// Looks up a dotted DTCG token path (e.g. `color.accent.base-default`) in
  /// [tree] and returns its raw `$value` string, or `null` if not found.
  String? _lookupTokenValue(String dottedPath, Map<String, dynamic> tree) {
    Object? node = tree;
    for (final segment in dottedPath.split('.')) {
      if (node is! Map<String, dynamic>) return null;
      node = node[segment];
    }
    if (node is Map<String, dynamic> && node[r'$value'] is String) {
      return node[r'$value'] as String;
    }
    return null;
  }

  Map<String, double> _parseDimensionGroup(
    Map<String, dynamic> data,
    String groupName,
  ) {
    final group = data[groupName];
    if (group is! Map<String, dynamic>) return {};

    final result = <String, double>{};
    for (final entry in group.entries) {
      final tokenData = entry.value;
      if (tokenData is Map<String, dynamic> &&
          tokenData.containsKey(r'$value')) {
        final value = _parseDimensionValue(tokenData[r'$value']);
        if (value != null) {
          result[entry.key] = value;
        }
      }
    }
    return result;
  }

  /// Parses a DTCG dimension `$value` into pixels.
  ///
  /// Accepts the string form (`"4px"`, `"0.25rem"`, unitless `"4"`) and the
  /// object form (`{ "value": 4, "unit": "px" }`). `rem` values are scaled by
  /// the 16px base; `px` and unitless values are taken as pixels. Returns `null`
  /// for unparseable values (e.g. unresolved aliases).
  double? _parseDimensionValue(Object? raw) {
    if (raw is Map<String, dynamic>) {
      final value = raw['value'];
      final unit = raw['unit'];
      if (value is num) {
        return _scaleDimension(value.toDouble(), unit is String ? unit : 'px');
      }
      return null;
    }
    if (raw is! String) return null;
    final s = raw.trim();
    if (s.endsWith('rem')) {
      return _scaleDimension(
        double.tryParse(s.substring(0, s.length - 3).trim()),
        'rem',
      );
    }
    if (s.endsWith('px')) {
      return _scaleDimension(
        double.tryParse(s.substring(0, s.length - 2).trim()),
        'px',
      );
    }
    return _scaleDimension(double.tryParse(s), 'px'); // unitless -> px
  }

  double? _scaleDimension(double? value, String unit) {
    if (value == null) return null;
    return unit == 'rem' ? value * 16 : value;
  }

  Map<String, dynamic> _readJson(File file) {
    final content = file.readAsStringSync();
    return jsonDecode(content) as Map<String, dynamic>;
  }
}

/// Exception thrown when [DtcgParser] encounters invalid or missing token data.
class DtcgParseException implements Exception {
  final String message;
  const DtcgParseException(this.message);
  @override
  String toString() => 'DtcgParseException: $message';
}
