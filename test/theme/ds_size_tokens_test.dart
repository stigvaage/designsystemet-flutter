import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';

void main() {
  group('DsSizeTokens', () {
    test('sm has base 16 and step 4', () {
      expect(DsSizeTokens.sm.base, 16);
      expect(DsSizeTokens.sm.step, 4);
    });

    test('md has base 18 and step 4', () {
      expect(DsSizeTokens.md.base, 18);
      expect(DsSizeTokens.md.step, 4);
    });

    test('lg has base 21 and step 4', () {
      expect(DsSizeTokens.lg.base, 21);
      expect(DsSizeTokens.lg.step, 4);
    });

    test('size0 is always 0', () {
      expect(DsSizeTokens.sm.size0, 0);
      expect(DsSizeTokens.md.size0, 0);
      expect(DsSizeTokens.lg.size0, 0);
    });

    test('size values computed correctly for md', () {
      final md = DsSizeTokens.md;
      expect(md.size1, 4);
      expect(md.size2, 8);
      expect(md.size4, 16);
      expect(md.size10, 40);
      expect(md.size30, 120);
    });

    test('indexed access returns correct value', () {
      final md = DsSizeTokens.md;
      expect(md[0], 0);
      expect(md[1], 4);
      expect(md[30], 120);
    });
  });
}
