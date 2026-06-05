import 'dart:io';

import 'package:designsystemet_flutter/src/generator/dart_emitter.dart';
import 'package:designsystemet_flutter/src/generator/dtcg_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DtcgParser', () {
    test('throws on nonexistent directory', () {
      final parser = DtcgParser();
      expect(
        () => parser.parse('/nonexistent'),
        throwsA(isA<DtcgParseException>()),
      );
    });

    test('parses committed fixture tokens directory', () {
      const fixtureDir = 'test/generator/fixtures/design-tokens';
      // The fixture is committed to the repo; fail loudly if it is missing.
      expect(
        Directory(fixtureDir).existsSync(),
        isTrue,
        reason: 'Committed fixture $fixtureDir must exist',
      );

      final parser = DtcgParser();
      final themes = parser.parse(fixtureDir);
      expect(themes, hasLength(1));
      expect(themes.first.name, 'test-theme');
      expect(themes.first.lightColors, isNotEmpty);
      expect(themes.first.lightColors['accent'], isNotNull);
      // 0.25rem -> 4px.
      expect(themes.first.borderRadii['md'], 4.0);
    });
  });

  group('DartEmitter', () {
    test('generates valid Dart code structure', () {
      final theme = _fullTheme();

      final emitter = DartEmitter();
      final code = emitter.emit(theme);

      expect(code, contains('class DsThemeMyTheme'));
      expect(code, contains('static DsThemeData light()'));
      expect(code, contains('static DsThemeData dark()'));
      expect(code, contains('Color(0xFF0000FF)')); // accent baseDefault
    });

    test('emits dartdoc on the public class and factory methods', () {
      final code = DartEmitter().emit(_fullTheme());
      expect(code, contains('/// Generert MyTheme-tema'));
      expect(code, contains('/// Returnerer det lyse MyTheme-temaet.'));
      expect(code, contains('/// Returnerer det mørke MyTheme-temaet.'));
    });

    test('emits relative theme imports, not the package barrel', () {
      final code = DartEmitter().emit(_fullTheme());
      expect(
        code,
        contains("import '../src/theme/ds_border_radius_tokens.dart';"),
      );
      expect(code, isNot(contains('package:designsystemet_flutter')));
    });

    test('emits integral border radius without a trailing .0', () {
      final code = DartEmitter().emit(_fullTheme());
      expect(code, contains('DsBorderRadiusTokens.fromBase(4)'));
      expect(code, isNot(contains('fromBase(4.0)')));
    });

    test('preserves fractional border radius', () {
      final code = DartEmitter().emit(_fullTheme(borderRadii: {'md': 2.5}));
      expect(code, contains('DsBorderRadiusTokens.fromBase(2.5)'));
    });

    test(
      'falls back to light colors for dark scheme when no dark colors exist',
      () {
        final code = DartEmitter().emit(_fullTheme(darkColors: const {}));
        // Never references an undefined placeholder identifier.
        expect(code, isNot(contains('_placeholder')));
        // Both schemes inline a real DsColorScale.
        expect(
          code,
          contains('static const _darkColorScheme = DsColorScheme('),
        );
        expect(
          'DsColorScale('.allMatches(code).length,
          greaterThanOrEqualTo(18),
        );
      },
    );

    test('throws when a required color scale is missing', () {
      final partial = ParsedTheme(
        name: 'partial',
        lightColors: {'accent': _scale('#0000FF')},
        darkColors: const {},
        sizes: const {},
        borderRadii: const {'md': 4.0},
      );
      expect(
        () => DartEmitter().emit(partial),
        throwsA(
          isA<DtcgParseException>().having(
            (e) => e.message,
            'message',
            allOf(contains('neutral'), contains('danger')),
          ),
        ),
      );
    });

    test('does not silently fan one scale out to others', () {
      // accent uses 0x0000FF; danger uses 0xFF0000. They must stay distinct.
      final code = DartEmitter().emit(_fullTheme());
      expect(code, contains('Color(0xFFFF0000)')); // danger baseDefault
    });

    test('expands #RGB shorthand hex', () {
      final code = DartEmitter().emit(_fullTheme(accentBase: '#F0A'));
      expect(code, contains('Color(0xFFFF00AA)'));
    });

    test('converts #RRGGBBAA to 0xAARRGGBB', () {
      final code = DartEmitter().emit(_fullTheme(accentBase: '#11223344'));
      expect(code, contains('Color(0x44112233)'));
    });

    test('throws on an unresolved alias color value', () {
      expect(
        () => DartEmitter().emit(
          _fullTheme(accentBase: '{color.accent.base-default}'),
        ),
        throwsA(isA<DtcgParseException>()),
      );
    });

    test('throws on an invalid hex color value', () {
      expect(
        () => DartEmitter().emit(_fullTheme(accentBase: '#GGGGGG')),
        throwsA(isA<DtcgParseException>()),
      );
    });
  });
}

/// Builds a [ParsedColorScale] with all 16 tokens, [base] as the base-default.
ParsedColorScale _scale(String base) {
  return ParsedColorScale({
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
    'base-default': base,
    'base-hover': '#0000CC',
    'base-active': '#000099',
    'base-contrast-subtle': '#E0E0FF',
    'base-contrast-default': '#FFFFFF',
  });
}

/// Builds a complete [ParsedTheme] with all 9 required scales for the light
/// scheme so the emitter has valid input. Individual scales get distinct
/// base-default colors so tests can assert they are not fanned out.
ParsedTheme _fullTheme({
  String accentBase = '#0000FF',
  Map<String, ParsedColorScale>? darkColors,
  Map<String, double> borderRadii = const {'md': 4.0},
}) {
  const bases = {
    'neutral': '#808080',
    'brand1': '#00AA00',
    'brand2': '#AA00AA',
    'brand3': '#00AAAA',
    'success': '#008000',
    'danger': '#FF0000',
    'warning': '#FFA500',
    'info': '#0080FF',
  };
  final light = <String, ParsedColorScale>{'accent': _scale(accentBase)};
  bases.forEach((name, base) => light[name] = _scale(base));

  return ParsedTheme(
    name: 'my-theme',
    lightColors: light,
    darkColors: darkColors ?? light,
    sizes: const {},
    borderRadii: borderRadii,
  );
}
