import 'dart:ui' show Brightness;
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

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

    test('lerp returns this when t < 0.5', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.dark();
      expect(a.lerp(b, 0.3), a);
    });

    test('lerp returns other when t >= 0.5', () {
      final a = DsThemeDigdir.light();
      final b = DsThemeDigdir.dark();
      expect(a.lerp(b, 0.7), b);
    });
  });
}
