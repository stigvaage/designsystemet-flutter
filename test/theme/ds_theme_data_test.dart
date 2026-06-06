import 'dart:ui' show Brightness;

import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsThemeData', () {
    test('DsThemeDigdir.light() creates light theme', () {
      final theme = DsThemeDigdir.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.disabledOpacity, 0.3);
    });

    test('DsThemeDigdir.dark() creates dark theme', () {
      final theme = DsThemeDigdir.dark();
      expect(theme.brightness, Brightness.dark);
    });

    test('copyWith preserves unmodified fields', () {
      final original = DsThemeDigdir.light();
      final copy = original.copyWith(disabledOpacity: 0.5);
      expect(copy.disabledOpacity, 0.5);
      expect(copy.brightness, original.brightness);
      expect(copy.colorScheme, original.colorScheme);
    });

    test('lerp at t = 0 equals this', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.dark();
      expect(a.lerp(b, 0), a);
    });

    test('lerp at t = 1 equals other', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.dark();
      expect(a.lerp(b, 1), b);
    });

    test('lerp returns this when other is null', () {
      final a = DsThemeDigdir.light();
      expect(a.lerp(null, 0.5), a);
    });

    test('lerp snaps discrete tokens at the midpoint', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.dark();
      // Below the midpoint discrete tokens come from `this`.
      expect(a.lerp(b, 0.3).brightness, a.brightness);
      expect(a.lerp(b, 0.3).typography, a.typography);
      expect(a.lerp(b, 0.3).sizeTokens, a.sizeTokens);
      expect(a.lerp(b, 0.3).borderRadius, a.borderRadius);
      // At/above the midpoint discrete tokens come from `other`.
      expect(a.lerp(b, 0.5).brightness, b.brightness);
      expect(a.lerp(b, 0.7).typography, b.typography);
    });

    test('lerp tweens continuous color tokens between endpoints', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.dark();
      final mid = a.lerp(b, 0.3);
      // The accent base color is interpolated, so it differs from both ends
      // when the endpoints themselves differ.
      if (a.colorScheme.accent.baseDefault !=
          b.colorScheme.accent.baseDefault) {
        expect(
          mid.colorScheme.accent.baseDefault,
          isNot(a.colorScheme.accent.baseDefault),
        );
        expect(
          mid.colorScheme.accent.baseDefault,
          isNot(b.colorScheme.accent.baseDefault),
        );
      }
    });

    test('value equality: same tokens are equal and share a hashCode', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.light();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('value equality: differing tokens are not equal', () {
      final a = DsThemeDigdir.light();
      final b = a.copyWith(disabledOpacity: 0.9);
      expect(a, isNot(equals(b)));
    });

    test('value equality: light and dark themes differ', () {
      expect(DsThemeDigdir.light(), isNot(equals(DsThemeDigdir.dark())));
    });
  });
}
