import 'dtcg_parser.dart';

class DartEmitter {
  String emit(ParsedTheme theme) {
    final className = _toPascalCase(theme.name);
    final buffer = StringBuffer();

    buffer.writeln("import 'dart:ui' show Brightness, Color;");
    buffer.writeln();
    buffer.writeln("import 'package:komponentbibliotek_flutter/theme.dart';");
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_border_radius_tokens.dart';",
    );
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_color_scale.dart';",
    );
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_color_scheme.dart';",
    );
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_shadow_tokens.dart';",
    );
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_size_tokens.dart';",
    );
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_theme_data.dart';",
    );
    buffer.writeln(
      "import 'package:komponentbibliotek_flutter/src/theme/ds_typography.dart';",
    );
    buffer.writeln();
    buffer.writeln('class DsTheme$className {');
    buffer.writeln('  DsTheme$className._();');
    buffer.writeln();

    // Light factory
    buffer.writeln('  static DsThemeData light() => DsThemeData(');
    buffer.writeln('        brightness: Brightness.light,');
    buffer.writeln('        colorScheme: _lightColorScheme,');
    buffer.writeln('        sizeTokens: DsSizeTokens.md,');
    buffer.writeln(
      '        typography: DsTypography.create(baseFontSize: 18),',
    );
    _emitBorderRadius(buffer, theme);
    buffer.writeln('        shadows: DsShadowTokens.light,');
    buffer.writeln('      );');
    buffer.writeln();

    // Dark factory
    buffer.writeln('  static DsThemeData dark() => DsThemeData(');
    buffer.writeln('        brightness: Brightness.dark,');
    buffer.writeln('        colorScheme: _darkColorScheme,');
    buffer.writeln('        sizeTokens: DsSizeTokens.md,');
    buffer.writeln(
      '        typography: DsTypography.create(baseFontSize: 18),',
    );
    _emitBorderRadius(buffer, theme);
    buffer.writeln('        shadows: DsShadowTokens.dark,');
    buffer.writeln('      );');
    buffer.writeln();

    // Color schemes
    _emitColorScheme(buffer, '_lightColorScheme', theme.lightColors);
    buffer.writeln();
    _emitColorScheme(buffer, '_darkColorScheme', theme.darkColors);

    buffer.writeln('}');
    return buffer.toString();
  }

  void _emitBorderRadius(StringBuffer buffer, ParsedTheme theme) {
    final base = theme.borderRadii['md'] ?? theme.borderRadii['default'] ?? 4.0;
    buffer.writeln(
      '        borderRadius: DsBorderRadiusTokens.fromBase($base),',
    );
  }

  void _emitColorScheme(
    StringBuffer buffer,
    String varName,
    Map<String, ParsedColorScale> colors,
  ) {
    buffer.writeln('  static const $varName = DsColorScheme(');
    final scaleNames = [
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
    for (final name in scaleNames) {
      final scale = colors[name] ?? colors.values.firstOrNull;
      if (scale != null) {
        buffer.writeln('    $name: ${_emitColorScale(scale)},');
      } else {
        buffer.writeln('    $name: _placeholder,');
      }
    }
    buffer.writeln('  );');
  }

  String _emitColorScale(ParsedColorScale scale) {
    final tokenMap = {
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

    final lines = <String>[];
    for (final entry in tokenMap.entries) {
      final hex = scale.tokens[entry.key] ?? '#000000';
      final colorValue = _hexToFlutterColor(hex);
      lines.add('      ${entry.value}: $colorValue');
    }

    return 'DsColorScale(\n${lines.join(',\n')},\n    )';
  }

  String _hexToFlutterColor(String hex) {
    var cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    return 'Color(0x${cleaned.toUpperCase()})';
  }

  String _toPascalCase(String input) {
    return input
        .split(RegExp(r'[-_\s]+'))
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
  }
}
