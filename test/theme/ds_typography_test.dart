import 'package:designsystemet_flutter/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('no font-feature-settings (parity with official Designsystemet)', () {
      // Offisiell Designsystemet setter ingen font-feature-settings (ingen
      // cv05). fontFeatures skal derfor være null/tom på alle stiler.
      expect(typo.heading2xl.fontFeatures ?? const [], isEmpty);
      expect(typo.bodyMd.fontFeatures ?? const [], isEmpty);
    });

    test('font sizes match official Designsystemet v1.15.0 at base 18', () {
      // Offisiell stige (primitive font-size-tokens medium/factor-1):
      // overskrift 60/48/36/30/24/21/18, brødtekst 24/21/18/16/14.
      expect(typo.heading2xl.fontSize, 60);
      expect(typo.headingXl.fontSize, 48);
      expect(typo.headingLg.fontSize, 36);
      expect(typo.headingMd.fontSize, 30);
      expect(typo.headingSm.fontSize, 24);
      expect(typo.headingXs.fontSize, 21);
      expect(typo.heading2xs.fontSize, 18);
      expect(typo.bodyXl.fontSize, 24);
      expect(typo.bodyLg.fontSize, 21);
      expect(typo.bodyMd.fontSize, 18);
      expect(typo.bodySm.fontSize, 16);
      expect(typo.bodyXs.fontSize, 14);
      // Body, body-short og body-long deler samme størrelser per trinn.
      expect(typo.bodyShortMd.fontSize, 18);
      expect(typo.bodyLongMd.fontSize, 18);
      expect(typo.bodyShortXl.fontSize, 24);
      expect(typo.bodyLongXs.fontSize, 14);
    });

    test('font sizes scale with base font size', () {
      final scaled = DsTypography.create(baseFontSize: 36); // scale = 2.0
      expect(scaled.heading2xl.fontSize, 120);
      expect(scaled.bodyMd.fontSize, 36);
    });

    test('letter-spacing matches official values at base 18', () {
      // Overskrifter (andel av font-størrelsen): 2xl/xl=-1%, lg=-0.5%,
      // md=-0.25%, sm=0%, xs/2xs=+0.15%. letterSpacing = andel * fontSize.
      expect(typo.heading2xl.letterSpacing, closeTo(-0.01 * 60, 1e-6));
      expect(typo.headingXl.letterSpacing, closeTo(-0.01 * 48, 1e-6));
      expect(typo.headingLg.letterSpacing, closeTo(-0.005 * 36, 1e-6));
      expect(typo.headingMd.letterSpacing, closeTo(-0.0025 * 30, 1e-6));
      expect(typo.headingSm.letterSpacing, 0);
      expect(typo.headingXs.letterSpacing, closeTo(0.0015 * 21, 1e-6));
      expect(typo.heading2xs.letterSpacing, closeTo(0.0015 * 18, 1e-6));
      // Brødtekst (andel): xl/lg/md=+0.5%, sm=+0.25%, xs=+0.15%.
      expect(typo.bodyXl.letterSpacing, closeTo(0.005 * 24, 1e-6));
      expect(typo.bodyLg.letterSpacing, closeTo(0.005 * 21, 1e-6));
      expect(typo.bodyMd.letterSpacing, closeTo(0.005 * 18, 1e-6));
      expect(typo.bodySm.letterSpacing, closeTo(0.0025 * 16, 1e-6));
      expect(typo.bodyXs.letterSpacing, closeTo(0.0015 * 14, 1e-6));
      // Short/long deler samme andel per størrelse.
      expect(typo.bodyShortSm.letterSpacing, closeTo(0.0025 * 16, 1e-6));
      expect(typo.bodyLongXs.letterSpacing, closeTo(0.0015 * 14, 1e-6));
    });

    test('value equality: same parameters are equal and share hashCode', () {
      final a = DsTypography.create(baseFontSize: 18);
      final b = DsTypography.create(baseFontSize: 18);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('value equality: different base font size is unequal', () {
      expect(
        DsTypography.create(baseFontSize: 18),
        isNot(equals(DsTypography.create(baseFontSize: 16))),
      );
    });

    test('value equality: different font family is unequal', () {
      expect(
        DsTypography.create(baseFontSize: 18),
        isNot(
          equals(DsTypography.create(fontFamily: 'Roboto', baseFontSize: 18)),
        ),
      );
    });
  });
}
