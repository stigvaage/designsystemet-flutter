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

    test('font sizes are locked at base 18 (current repo scale)', () {
      // MERK: stigen er forskjøvet ett trinn ned vs. offisiell v1.15.0 (se
      // dartdoc i DsTypography.create). Disse verdiene låser dagens stige som
      // DsLabel/DsField er bygget på, til en samordnet korreksjon gjøres.
      expect(typo.heading2xl.fontSize, 48);
      expect(typo.headingXl.fontSize, 36);
      expect(typo.headingLg.fontSize, 30);
      expect(typo.headingMd.fontSize, 24);
      expect(typo.headingSm.fontSize, 20);
      expect(typo.headingXs.fontSize, 18);
      expect(typo.heading2xs.fontSize, 16);
      expect(typo.bodyXl.fontSize, 20);
      expect(typo.bodyLg.fontSize, 18);
      expect(typo.bodyMd.fontSize, 16);
      expect(typo.bodySm.fontSize, 14);
      expect(typo.bodyXs.fontSize, 13);
      expect(typo.bodyShortMd.fontSize, 16);
      expect(typo.bodyLongMd.fontSize, 16);
    });

    test('font sizes scale with base font size', () {
      final scaled = DsTypography.create(baseFontSize: 36); // scale = 2.0
      expect(scaled.heading2xl.fontSize, 96);
      expect(scaled.bodyMd.fontSize, 32);
    });

    test('letter-spacing matches official em values at base 18', () {
      // Overskrifter (em): 2xl/xl=-0.01, lg=-0.005, md=-0.0025, sm=0,
      // xs/2xs=0.0015. letterSpacing = em * fontSize (gjeldende px-størrelser).
      expect(typo.heading2xl.letterSpacing, closeTo(-0.01 * 48, 1e-6));
      expect(typo.headingXl.letterSpacing, closeTo(-0.01 * 36, 1e-6));
      expect(typo.headingLg.letterSpacing, closeTo(-0.005 * 30, 1e-6));
      expect(typo.headingMd.letterSpacing, closeTo(-0.0025 * 24, 1e-6));
      expect(typo.headingSm.letterSpacing, 0);
      expect(typo.headingXs.letterSpacing, closeTo(0.0015 * 18, 1e-6));
      expect(typo.heading2xs.letterSpacing, closeTo(0.0015 * 16, 1e-6));
      // Brødtekst (em): xl/lg/md=0.005, sm=0.0025, xs=0.0015.
      expect(typo.bodyXl.letterSpacing, closeTo(0.005 * 20, 1e-6));
      expect(typo.bodyLg.letterSpacing, closeTo(0.005 * 18, 1e-6));
      expect(typo.bodyMd.letterSpacing, closeTo(0.005 * 16, 1e-6));
      expect(typo.bodySm.letterSpacing, closeTo(0.0025 * 14, 1e-6));
      expect(typo.bodyXs.letterSpacing, closeTo(0.0015 * 13, 1e-6));
      // Short/long deler samme em-verdier per størrelse.
      expect(typo.bodyShortSm.letterSpacing, closeTo(0.0025 * 14, 1e-6));
      expect(typo.bodyLongXs.letterSpacing, closeTo(0.0015 * 13, 1e-6));
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
