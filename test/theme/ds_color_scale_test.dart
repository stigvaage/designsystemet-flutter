import 'dart:ui' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';

void main() {
  const scale = DsColorScale(
    backgroundDefault: Color(0xFFFEFEFF),
    backgroundTinted: Color(0xFFEEF4FA),
    surfaceDefault: Color(0xFFDDE9F3),
    surfaceTinted: Color(0xFFCCDFF0),
    surfaceHover: Color(0xFFB3CFE5),
    surfaceActive: Color(0xFF99C0DB),
    borderSubtle: Color(0xFF85B0CC),
    borderDefault: Color(0xFF5A9AC4),
    borderStrong: Color(0xFF2B7BB5),
    textSubtle: Color(0xFF1A5C97),
    textDefault: Color(0xFF003052),
    baseDefault: Color(0xFF0062BA),
    baseHover: Color(0xFF004D94),
    baseActive: Color(0xFF003B73),
    baseContrastSubtle: Color(0xFFD4E4F0),
    baseContrastDefault: Color(0xFFFFFFFF),
  );

  group('DsColorScale', () {
    test('constructs with 16 tokens', () {
      expect(scale.backgroundDefault, const Color(0xFFFEFEFF));
      expect(scale.baseContrastDefault, const Color(0xFFFFFFFF));
    });

    test('supports equality', () {
      const other = DsColorScale(
        backgroundDefault: Color(0xFFFEFEFF),
        backgroundTinted: Color(0xFFEEF4FA),
        surfaceDefault: Color(0xFFDDE9F3),
        surfaceTinted: Color(0xFFCCDFF0),
        surfaceHover: Color(0xFFB3CFE5),
        surfaceActive: Color(0xFF99C0DB),
        borderSubtle: Color(0xFF85B0CC),
        borderDefault: Color(0xFF5A9AC4),
        borderStrong: Color(0xFF2B7BB5),
        textSubtle: Color(0xFF1A5C97),
        textDefault: Color(0xFF003052),
        baseDefault: Color(0xFF0062BA),
        baseHover: Color(0xFF004D94),
        baseActive: Color(0xFF003B73),
        baseContrastSubtle: Color(0xFFD4E4F0),
        baseContrastDefault: Color(0xFFFFFFFF),
      );
      expect(scale, equals(other));
      expect(scale.hashCode, equals(other.hashCode));
    });

    test('copyWith returns modified copy', () {
      final modified = scale.copyWith(baseDefault: const Color(0xFFFF0000));
      expect(modified.baseDefault, const Color(0xFFFF0000));
      expect(modified.backgroundDefault, scale.backgroundDefault);
    });
  });
}
