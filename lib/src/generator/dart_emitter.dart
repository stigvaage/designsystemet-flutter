import 'dtcg_parser.dart';

/// Generates a Dart source file containing a [DsThemeData] factory class
/// from a [ParsedTheme] produced by [DtcgParser].
///
/// The emitted source is `dart format`-clean (4-space indentation) and uses
/// relative imports into `../src/theme/...`, matching the committed reference
/// in `lib/generated/ds_theme_digdir.dart`, so regeneration is idempotent and
/// passes the CI `dart format --set-exit-if-changed` check.
class DartEmitter {
  /// The semantic color scales every generated [DsColorScheme] must define.
  static const List<String> _scaleNames = [
    'accent',
    'neutral',
    'brand1',
    'brand2',
    'brand3',
    'success',
    'danger',
    'warning',
    'info',
  ];

  /// Maps DTCG color-scale token names to [DsColorScale] field names.
  static const Map<String, String> _tokenMap = {
    'background-default': 'backgroundDefault',
    'background-tinted': 'backgroundTinted',
    'surface-default': 'surfaceDefault',
    'surface-tinted': 'surfaceTinted',
    'surface-hover': 'surfaceHover',
    'surface-active': 'surfaceActive',
    'border-subtle': 'borderSubtle',
    'border-default': 'borderDefault',
    'border-strong': 'borderStrong',
    'text-subtle': 'textSubtle',
    'text-default': 'textDefault',
    'base-default': 'baseDefault',
    'base-hover': 'baseHover',
    'base-active': 'baseActive',
    'base-contrast-subtle': 'baseContrastSubtle',
    'base-contrast-default': 'baseContrastDefault',
  };

  /// Emits the full Dart source for [theme].
  ///
  /// Throws a [DtcgParseException] if any required color scale or token is
  /// missing, or if a color value is not a valid hex string. The light scheme
  /// is used as a fallback for the dark scheme only when the theme defines no
  /// dark colors at all, so the output always compiles into a usable theme.
  String emit(ParsedTheme theme) {
    final className = _toPascalCase(theme.name);
    final buffer = StringBuffer();

    // A theme with no dark colors falls back to its light colors so the
    // generated file always compiles into a usable (if not dark-tuned) theme.
    final effectiveDark = theme.darkColors.isEmpty
        ? theme.lightColors
        : theme.darkColors;

    buffer.writeln("import 'dart:ui' show Brightness, Color;");
    buffer.writeln();
    buffer.writeln("import '../src/theme/ds_border_radius_tokens.dart';");
    buffer.writeln("import '../src/theme/ds_color_scale.dart';");
    buffer.writeln("import '../src/theme/ds_color_scheme.dart';");
    buffer.writeln("import '../src/theme/ds_shadow_tokens.dart';");
    buffer.writeln("import '../src/theme/ds_size_tokens.dart';");
    buffer.writeln("import '../src/theme/ds_theme_data.dart';");
    buffer.writeln("import '../src/theme/ds_typography.dart';");
    buffer.writeln();

    buffer.writeln(
      '/// Generert $className-tema laget av designsystemet_flutter-kodegeneratoren.',
    );
    buffer.writeln('///');
    buffer.writeln('/// For egendefinerte temaer, kjør kodegeneratoren:');
    buffer.writeln('/// `dart run designsystemet_flutter:generate`');
    buffer.writeln('class DsTheme$className {');
    buffer.writeln('  DsTheme$className._();');
    buffer.writeln();

    // Cached instances. Building a DsThemeData rebuilds the typography and
    // border-radius tokens, so cache them and reuse across calls.
    buffer.writeln(
      '  /// Det bufrede lyse temaet. Bygges én gang og gjenbrukes på tvers av',
    );
    buffer.writeln('  /// alle [light]-kall.');
    buffer.writeln('  static final DsThemeData _light = _buildLight();');
    buffer.writeln();
    buffer.writeln(
      '  /// Det bufrede mørke temaet. Bygges én gang og gjenbrukes på tvers av',
    );
    buffer.writeln('  /// alle [dark]-kall.');
    buffer.writeln('  static final DsThemeData _dark = _buildDark();');
    buffer.writeln();

    // Public factory API (cached). Kept as light()/dark() so callers and
    // tests continue to work unchanged.
    buffer.writeln('  /// Returnerer det lyse $className-temaet.');
    buffer.writeln('  ///');
    buffer.writeln(
      '  /// Resultatet er bufret, så gjentatte kall returnerer samme',
    );
    buffer.writeln(
      '  /// uforanderlige instans i stedet for å bygge tokens på nytt.',
    );
    buffer.writeln('  static DsThemeData light() => _light;');
    buffer.writeln();
    buffer.writeln('  /// Returnerer det mørke $className-temaet.');
    buffer.writeln('  ///');
    buffer.writeln(
      '  /// Resultatet er bufret, så gjentatte kall returnerer samme',
    );
    buffer.writeln(
      '  /// uforanderlige instans i stedet for å bygge tokens på nytt.',
    );
    buffer.writeln('  static DsThemeData dark() => _dark;');
    buffer.writeln();

    final borderRadiusLiteral = _borderRadiusLiteral(theme);

    // Light builder
    buffer.writeln('  static DsThemeData _buildLight() => DsThemeData(');
    buffer.writeln('    brightness: Brightness.light,');
    buffer.writeln('    colorScheme: _lightColorScheme,');
    buffer.writeln('    sizeTokens: DsSizeTokens.md,');
    buffer.writeln('    typography: DsTypography.create(baseFontSize: 18),');
    buffer.writeln(
      '    borderRadius: DsBorderRadiusTokens.fromBase($borderRadiusLiteral),',
    );
    buffer.writeln('    shadows: DsShadowTokens.light,');
    buffer.writeln('  );');
    buffer.writeln();

    // Dark builder
    buffer.writeln('  static DsThemeData _buildDark() => DsThemeData(');
    buffer.writeln('    brightness: Brightness.dark,');
    buffer.writeln('    colorScheme: _darkColorScheme,');
    buffer.writeln('    sizeTokens: DsSizeTokens.md,');
    buffer.writeln('    typography: DsTypography.create(baseFontSize: 18),');
    buffer.writeln(
      '    borderRadius: DsBorderRadiusTokens.fromBase($borderRadiusLiteral),',
    );
    buffer.writeln('    shadows: DsShadowTokens.dark,');
    buffer.writeln('  );');
    buffer.writeln();

    // Color schemes
    _emitColorScheme(buffer, '_lightColorScheme', 'light', theme.lightColors);
    buffer.writeln();
    _emitColorScheme(buffer, '_darkColorScheme', 'dark', effectiveDark);

    buffer.writeln('}');
    return buffer.toString();
  }

  /// Returns the border-radius base value as a Dart numeric literal.
  ///
  /// Integral values render without a trailing `.0` (e.g. `4`, not `4.0`) so the
  /// output matches the committed reference and round-trips cleanly.
  String _borderRadiusLiteral(ParsedTheme theme) {
    final base = theme.borderRadii['md'] ?? 4.0;
    return base == base.truncateToDouble()
        ? base.toInt().toString()
        : base.toString();
  }

  void _emitColorScheme(
    StringBuffer buffer,
    String varName,
    String brightness,
    Map<String, ParsedColorScale> colors,
  ) {
    // Fail loudly rather than silently fanning one scale out to all, or
    // emitting an undefined placeholder identifier.
    final missing = _scaleNames.where((n) => colors[n] == null).toList();
    if (missing.isNotEmpty) {
      throw DtcgParseException(
        'Temaet mangler påkrevde fargeskalaer ($brightness): '
        '${missing.join(', ')}.',
      );
    }

    buffer.writeln('  static const $varName = DsColorScheme(');
    for (final name in _scaleNames) {
      final scale = colors[name]!;
      buffer.writeln('    $name: ${_emitColorScale(scale)},');
    }
    buffer.writeln('  );');
  }

  String _emitColorScale(ParsedColorScale scale) {
    final lines = <String>[];
    for (final entry in _tokenMap.entries) {
      final hex = scale.tokens[entry.key];
      if (hex == null) {
        throw DtcgParseException('Fargeskala mangler tokenet "${entry.key}".');
      }
      final colorValue = _hexToFlutterColor(hex, entry.key);
      lines.add('      ${entry.value}: $colorValue');
    }

    return 'DsColorScale(\n${lines.join(',\n')},\n    )';
  }

  /// Converts a hex color string to a `Color(0x...)` literal.
  ///
  /// Accepts `#RGB`, `#RRGGBB` and `#RRGGBBAA`. Throws a [DtcgParseException]
  /// naming [tokenName] when the value is not a supported hex string (e.g. an
  /// unresolved DTCG alias like `{color.accent.base}`), so invalid color data
  /// never silently produces a non-compiling literal.
  String _hexToFlutterColor(String hex, String tokenName) {
    var cleaned = hex.trim();
    if (!cleaned.startsWith('#')) {
      throw DtcgParseException(
        'Tokenet "$tokenName" har en fargeverdi "$hex" som ikke støttes '
        '(forventet en #RGB / #RRGGBB / #RRGGBBAA-hex). Aliaser som '
        '{color.x} må løses opp før generering.',
      );
    }
    cleaned = cleaned.substring(1);
    // Expand #RGB shorthand to #RRGGBB.
    if (cleaned.length == 3) {
      cleaned = cleaned.split('').map((c) => '$c$c').join();
    }
    if (!RegExp(r'^[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(cleaned)) {
      throw DtcgParseException(
        'Tokenet "$tokenName" har en ugyldig hex-farge "$hex".',
      );
    }
    // Convert #RRGGBBAA -> 0xAARRGGBB; pad #RRGGBB with opaque alpha.
    if (cleaned.length == 8) {
      final rgb = cleaned.substring(0, 6);
      final a = cleaned.substring(6, 8);
      cleaned = '$a$rgb';
    } else {
      cleaned = 'FF$cleaned';
    }
    return 'Color(0x${cleaned.toUpperCase()})';
  }

  String _toPascalCase(String input) {
    return input
        .split(RegExp(r'[-_\s]+'))
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
  }
}
