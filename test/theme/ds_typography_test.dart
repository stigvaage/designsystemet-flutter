import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';

void main() {
  group('DsTypography', () {
    late DsTypography typo;

    setUp(() {
      typo = DsTypography.create(baseFontSize: 18);
    });

    test('fontFamily defaults to Inter', () {
      expect(typo.fontFamily, 'Inter');
    });

    test('heading styles have weight 500', () {
      expect(typo.heading2xl.fontWeight, FontWeight.w500);
      expect(typo.headingMd.fontWeight, FontWeight.w500);
      expect(typo.heading2xs.fontWeight, FontWeight.w500);
    });

    test('heading styles have line-height 1.3', () {
      expect(typo.heading2xl.height, 1.3);
      expect(typo.headingMd.height, 1.3);
    });

    test('body default styles have line-height 1.5', () {
      expect(typo.bodyXl.height, 1.5);
      expect(typo.bodyMd.height, 1.5);
      expect(typo.bodyXs.height, 1.5);
    });

    test('body short styles have line-height 1.3', () {
      expect(typo.bodyShortXl.height, 1.3);
      expect(typo.bodyShortMd.height, 1.3);
    });

    test('body long styles have line-height 1.7', () {
      expect(typo.bodyLongXl.height, 1.7);
      expect(typo.bodyLongMd.height, 1.7);
    });

    test('body styles have weight 400', () {
      expect(typo.bodyMd.fontWeight, FontWeight.w400);
      expect(typo.bodyShortMd.fontWeight, FontWeight.w400);
      expect(typo.bodyLongMd.fontWeight, FontWeight.w400);
    });

    test('configurable fontFamily', () {
      final custom = DsTypography.create(
        fontFamily: 'Roboto',
        baseFontSize: 18,
      );
      expect(custom.fontFamily, 'Roboto');
      expect(custom.heading2xl.fontFamily, 'Roboto');
    });

    test('has cv05 font feature', () {
      expect(typo.heading2xl.fontFeatures, contains(const FontFeature('cv05')));
    });
  });
}
