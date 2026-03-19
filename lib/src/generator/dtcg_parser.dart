import 'dart:convert';
import 'dart:io';

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

class ParsedColorScale {
  final Map<String, String> tokens; // token-name -> hex color
  const ParsedColorScale(this.tokens);
}

class DtcgParser {
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
          tokens[tokenEntry.key] = tokenData[r'$value'] as String;
        }
      }
      if (tokens.isNotEmpty) {
        scales[scaleName] = ParsedColorScale(tokens);
      }
    }

    return scales;
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
      if (tokenData is Map<String, dynamic> && tokenData[r'$value'] is String) {
        final value = _parseRemValue(tokenData[r'$value'] as String);
        if (value != null) {
          result[entry.key] = value;
        }
      }
    }
    return result;
  }

  double? _parseRemValue(String value) {
    final cleaned = value.replaceAll('rem', '').trim();
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return null;
    return parsed * 16; // Convert rem to px (assuming 16px base)
  }

  Map<String, dynamic> _readJson(File file) {
    final content = file.readAsStringSync();
    return jsonDecode(content) as Map<String, dynamic>;
  }
}

class DtcgParseException implements Exception {
  final String message;
  const DtcgParseException(this.message);
  @override
  String toString() => 'DtcgParseException: $message';
}
