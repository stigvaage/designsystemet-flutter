import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';

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
  });

  group('DsShadowTokens', () {
    test('standard has all 5 levels', () {
      expect(DsShadowTokens.standard.xs, hasLength(2));
      expect(DsShadowTokens.standard.sm, hasLength(3));
      expect(DsShadowTokens.standard.md, hasLength(3));
      expect(DsShadowTokens.standard.lg, hasLength(3));
      expect(DsShadowTokens.standard.xl, hasLength(3));
    });
  });
}
