import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/src/generator/dtcg_parser.dart';
import 'package:komponentbibliotek_flutter/src/generator/dart_emitter.dart';

void main() {
  group('DtcgParser', () {
    test('throws on nonexistent directory', () {
      final parser = DtcgParser();
      expect(
        () => parser.parse('/nonexistent'),
        throwsA(isA<DtcgParseException>()),
      );
    });

    test('parses fixture tokens directory', () {
      final fixtureDir = 'test/generator/fixtures/design-tokens';
      if (!Directory(fixtureDir).existsSync()) {
        // Create fixture for testing
        _createFixture(fixtureDir);
      }

      final parser = DtcgParser();
      final themes = parser.parse(fixtureDir);
      expect(themes, hasLength(1));
      expect(themes.first.name, 'test-theme');
      expect(themes.first.lightColors, isNotEmpty);
      expect(themes.first.lightColors['accent'], isNotNull);
    });
  });

  group('DartEmitter', () {
    test('generates valid Dart code structure', () {
      final theme = ParsedTheme(
        name: 'my-theme',
        lightColors: {
          'accent': ParsedColorScale({
            'background-default': '#FFFFFF',
            'background-tinted': '#F0F0FF',
            'surface-default': '#E0E0F0',
            'surface-tinted': '#D0D0E0',
            'surface-hover': '#C0C0D0',
            'surface-active': '#B0B0C0',
            'border-subtle': '#A0A0B0',
            'border-default': '#8080A0',
            'border-strong': '#606090',
            'text-subtle': '#404070',
            'text-default': '#202050',
            'base-default': '#0000FF',
            'base-hover': '#0000CC',
            'base-active': '#000099',
            'base-contrast-subtle': '#E0E0FF',
            'base-contrast-default': '#FFFFFF',
          }),
        },
        darkColors: {},
        sizes: {},
        borderRadii: {'md': 4.0},
      );

      final emitter = DartEmitter();
      final code = emitter.emit(theme);

      expect(code, contains('class DsThemeMyTheme'));
      expect(code, contains('static DsThemeData light()'));
      expect(code, contains('static DsThemeData dark()'));
      expect(code, contains('Color(0xFF0000FF)')); // accent baseDefault
    });
  });
}

void _createFixture(String path) {
  final themesDir = Directory('$path/themes/test-theme');
  themesDir.createSync(recursive: true);

  File('${themesDir.path}/light.json').writeAsStringSync('''
{
  "color": {
    "accent": {
      "background-default": { "\$value": "#FEFEFF", "\$type": "color" },
      "background-tinted": { "\$value": "#EEF4FA", "\$type": "color" },
      "surface-default": { "\$value": "#DDE9F3", "\$type": "color" },
      "surface-tinted": { "\$value": "#CCDFF0", "\$type": "color" },
      "surface-hover": { "\$value": "#B3CFE5", "\$type": "color" },
      "surface-active": { "\$value": "#99C0DB", "\$type": "color" },
      "border-subtle": { "\$value": "#85B0CC", "\$type": "color" },
      "border-default": { "\$value": "#5A9AC4", "\$type": "color" },
      "border-strong": { "\$value": "#2B7BB5", "\$type": "color" },
      "text-subtle": { "\$value": "#1A5C97", "\$type": "color" },
      "text-default": { "\$value": "#003052", "\$type": "color" },
      "base-default": { "\$value": "#0062BA", "\$type": "color" },
      "base-hover": { "\$value": "#004D94", "\$type": "color" },
      "base-active": { "\$value": "#003B73", "\$type": "color" },
      "base-contrast-subtle": { "\$value": "#D4E4F0", "\$type": "color" },
      "base-contrast-default": { "\$value": "#FFFFFF", "\$type": "color" }
    }
  }
}
''');

  File('${themesDir.path}/global.json').writeAsStringSync('''
{
  "border-radius": {
    "sm": { "\$value": "0.125rem", "\$type": "dimension" },
    "md": { "\$value": "0.25rem", "\$type": "dimension" },
    "lg": { "\$value": "0.5rem", "\$type": "dimension" },
    "full": { "\$value": "624.9375rem", "\$type": "dimension" }
  }
}
''');
}
