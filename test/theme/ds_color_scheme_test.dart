import 'dart:ui' show Color;

import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsColorScheme', () {
    test('Digdir light scheme has 9 named scales', () {
      final theme = DsThemeDigdir.light();
      final scheme = theme.colorScheme;
      expect(scheme.accent.baseDefault, isNotNull);
      expect(scheme.neutral.baseDefault, isNotNull);
      expect(scheme.brand1.baseDefault, isNotNull);
      expect(scheme.success.baseDefault, isNotNull);
      expect(scheme.danger.baseDefault, isNotNull);
      expect(scheme.warning.baseDefault, isNotNull);
      expect(scheme.info.baseDefault, isNotNull);
    });

    test('resolve returns correct scale for DsColor enum', () {
      final theme = DsThemeDigdir.light();
      final scheme = theme.colorScheme;
      expect(scheme.resolve(DsColor.accent), scheme.accent);
      expect(scheme.resolve(DsColor.danger), scheme.danger);
      expect(scheme.resolve(DsColor.neutral), scheme.neutral);
    });

    test('resolve falls back to accent for unknown custom key', () {
      final theme = DsThemeDigdir.light();
      final scheme = theme.colorScheme;
      expect(scheme.resolve(DsColor.custom('nonexistent')), scheme.accent);
    });

    test('custom scales can be added', () {
      final theme = DsThemeDigdir.light();
      final customScale = theme.colorScheme.accent;
      final scheme = DsColorScheme(
        accent: theme.colorScheme.accent,
        neutral: theme.colorScheme.neutral,
        brand1: theme.colorScheme.brand1,
        brand2: theme.colorScheme.brand2,
        brand3: theme.colorScheme.brand3,
        success: theme.colorScheme.success,
        danger: theme.colorScheme.danger,
        warning: theme.colorScheme.warning,
        info: theme.colorScheme.info,
        custom: {'myBrand': customScale},
      );
      expect(scheme.resolve(DsColor.custom('myBrand')), customScale);
    });

    test('value equality: identical schemes are equal', () {
      final a = DsThemeDigdir.light().colorScheme;
      final b = DsThemeDigdir.light().colorScheme;
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('value equality: differing scale makes schemes unequal', () {
      final base = DsThemeDigdir.light().colorScheme;
      final modified = base.copyWith(
        accent: base.accent.copyWith(baseDefault: const Color(0xFFFF0000)),
      );
      expect(base, isNot(equals(modified)));
    });

    test('value equality: custom map is compared by content', () {
      final base = DsThemeDigdir.light().colorScheme;
      final withCustom1 = base.copyWith(custom: {'x': base.accent});
      final withCustom2 = base.copyWith(custom: {'x': base.accent});
      expect(withCustom1, equals(withCustom2));
      expect(withCustom1.hashCode, equals(withCustom2.hashCode));
      expect(withCustom1, isNot(equals(base)));
    });
  });
}
