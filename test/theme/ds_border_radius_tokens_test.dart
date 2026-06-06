import 'package:designsystemet_flutter/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsBorderRadiusTokens', () {
    test('fromBase(4) creates correct values', () {
      final tokens = DsBorderRadiusTokens.fromBase(4);
      expect(tokens.sm, 2);
      expect(tokens.md, 4);
      expect(tokens.lg, 8);
      expect(tokens.xl, 12);
      expect(tokens.defaultRadius, 4);
      expect(tokens.full, 9999);
    });

    test('value equality: same base is equal and shares hashCode', () {
      final a = DsBorderRadiusTokens.fromBase(4);
      final b = DsBorderRadiusTokens.fromBase(4);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('value equality: different base is unequal', () {
      expect(
        DsBorderRadiusTokens.fromBase(4),
        isNot(equals(DsBorderRadiusTokens.fromBase(8))),
      );
    });
  });

  group('DsShadowTokens', () {
    test('standard has all 5 levels', () {
      expect(DsShadowTokens.standard.xs, hasLength(2));
      expect(DsShadowTokens.standard.sm, hasLength(3));
      expect(DsShadowTokens.standard.md, hasLength(3));
      expect(DsShadowTokens.standard.lg, hasLength(3));
      expect(DsShadowTokens.standard.xl, hasLength(3));
    });

    test('value equality: standard equals itself by value', () {
      expect(DsShadowTokens.standard, equals(DsShadowTokens.light));
      expect(
        DsShadowTokens.standard.hashCode,
        equals(DsShadowTokens.light.hashCode),
      );
    });

    test('value equality: light and dark presets differ', () {
      expect(DsShadowTokens.standard, isNot(equals(DsShadowTokens.dark)));
    });
  });
}
