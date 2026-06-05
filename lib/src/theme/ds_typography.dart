import 'package:flutter/widgets.dart';

/// Typography token set generated from Designsystemet font-size and line-height scales.
///
/// Provides heading (2xl–2xs), body, body-short, and body-long text styles.
/// Create an instance with [DsTypography.create] specifying the base font size.
class DsTypography {
  /// Skriftfamilie brukt for alle tekststiler (standard `Inter`).
  final String fontFamily;

  /// Overskrift 2xl (vekt 500, linjehøyde 1.3) — 48px ved referansestørrelse.
  final TextStyle heading2xl;

  /// Overskrift xl (vekt 500, linjehøyde 1.3) — 36px ved referansestørrelse.
  final TextStyle headingXl;

  /// Overskrift lg (vekt 500, linjehøyde 1.3) — 30px ved referansestørrelse.
  final TextStyle headingLg;

  /// Overskrift md (vekt 500, linjehøyde 1.3) — 24px ved referansestørrelse.
  final TextStyle headingMd;

  /// Overskrift sm (vekt 500, linjehøyde 1.3) — 20px ved referansestørrelse.
  final TextStyle headingSm;

  /// Overskrift xs (vekt 500, linjehøyde 1.3) — 18px ved referansestørrelse.
  final TextStyle headingXs;

  /// Overskrift 2xs (vekt 500, linjehøyde 1.3) — 16px ved referansestørrelse.
  final TextStyle heading2xs;

  /// Brødtekst xl (vekt 400, linjehøyde 1.5) — 20px ved referansestørrelse.
  final TextStyle bodyXl;

  /// Brødtekst lg (vekt 400, linjehøyde 1.5) — 18px ved referansestørrelse.
  final TextStyle bodyLg;

  /// Brødtekst md (vekt 400, linjehøyde 1.5) — 16px ved referansestørrelse.
  final TextStyle bodyMd;

  /// Brødtekst sm (vekt 400, linjehøyde 1.5) — 14px ved referansestørrelse.
  final TextStyle bodySm;

  /// Brødtekst xs (vekt 400, linjehøyde 1.5) — 13px ved referansestørrelse.
  final TextStyle bodyXs;

  /// Kort brødtekst xl (vekt 400, linjehøyde 1.3) — 20px ved referansestørrelse.
  final TextStyle bodyShortXl;

  /// Kort brødtekst lg (vekt 400, linjehøyde 1.3) — 18px ved referansestørrelse.
  final TextStyle bodyShortLg;

  /// Kort brødtekst md (vekt 400, linjehøyde 1.3) — 16px ved referansestørrelse.
  final TextStyle bodyShortMd;

  /// Kort brødtekst sm (vekt 400, linjehøyde 1.3) — 14px ved referansestørrelse.
  final TextStyle bodyShortSm;

  /// Kort brødtekst xs (vekt 400, linjehøyde 1.3) — 13px ved referansestørrelse.
  final TextStyle bodyShortXs;

  /// Lang brødtekst xl (vekt 400, linjehøyde 1.7) — 20px ved referansestørrelse.
  final TextStyle bodyLongXl;

  /// Lang brødtekst lg (vekt 400, linjehøyde 1.7) — 18px ved referansestørrelse.
  final TextStyle bodyLongLg;

  /// Lang brødtekst md (vekt 400, linjehøyde 1.7) — 16px ved referansestørrelse.
  final TextStyle bodyLongMd;

  /// Lang brødtekst sm (vekt 400, linjehøyde 1.7) — 14px ved referansestørrelse.
  final TextStyle bodyLongSm;

  /// Lang brødtekst xs (vekt 400, linjehøyde 1.7) — 13px ved referansestørrelse.
  final TextStyle bodyLongXs;

  const DsTypography._({
    required this.fontFamily,
    required this.heading2xl,
    required this.headingXl,
    required this.headingLg,
    required this.headingMd,
    required this.headingSm,
    required this.headingXs,
    required this.heading2xs,
    required this.bodyXl,
    required this.bodyLg,
    required this.bodyMd,
    required this.bodySm,
    required this.bodyXs,
    required this.bodyShortXl,
    required this.bodyShortLg,
    required this.bodyShortMd,
    required this.bodyShortSm,
    required this.bodyShortXs,
    required this.bodyLongXl,
    required this.bodyLongLg,
    required this.bodyLongMd,
    required this.bodyLongSm,
    required this.bodyLongXs,
  });

  /// Bygger et typografisett relativt til [baseFontSize].
  ///
  /// Letter-spacing følger offisiell Designsystemet (em-verdier): overskrifter
  /// 2xl/xl=-0.01, lg=-0.005, md=-0.0025, sm=0, xs/2xs=0.0015; brødtekst
  /// xl/lg/md=0.005, sm=0.0025, xs=0.0015.
  ///
  /// MERK: selve font-størrelse-stigen er per nå forskjøvet ett trinn ned i
  /// forhold til offisiell v1.15.0 (offisielt heading 60/48/36/30/24/21/18,
  /// body 24/21/18/16/14). En korreksjon av størrelsene krever samtidig
  /// re-mapping av forbrukere som er bygget på dagens stige (`DsLabel`,
  /// `DsField`) og deres tester, og er derfor ikke gjort her.
  factory DsTypography.create({
    String fontFamily = 'Inter',
    required double baseFontSize,
  }) {
    TextStyle heading(double size, double letterSpacing) => TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: size,
      height: 1.3,
      letterSpacing: letterSpacing,
    );

    TextStyle body(double size, double lineHeight, double letterSpacing) =>
        TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: size,
          height: lineHeight,
          letterSpacing: letterSpacing,
        );

    // Font sizes are relative to the base font size
    final scale = baseFontSize / 18.0; // md is the reference (18px)

    return DsTypography._(
      fontFamily: fontFamily,
      // Headings (scaled) — letter-spacing i em: 2xl/xl=-0.01, lg=-0.005,
      // md=-0.0025, sm=0, xs/2xs=0.0015.
      heading2xl: heading(48 * scale, -0.01 * 48 * scale),
      headingXl: heading(36 * scale, -0.01 * 36 * scale),
      headingLg: heading(30 * scale, -0.005 * 30 * scale),
      headingMd: heading(24 * scale, -0.0025 * 24 * scale),
      headingSm: heading(20 * scale, 0),
      headingXs: heading(18 * scale, 0.0015 * 18 * scale),
      heading2xs: heading(16 * scale, 0.0015 * 16 * scale),
      // Body default (line-height 1.5) — letter-spacing i em:
      // xl/lg/md=0.005, sm=0.0025, xs=0.0015.
      bodyXl: body(20 * scale, 1.5, 0.005 * 20 * scale),
      bodyLg: body(18 * scale, 1.5, 0.005 * 18 * scale),
      bodyMd: body(16 * scale, 1.5, 0.005 * 16 * scale),
      bodySm: body(14 * scale, 1.5, 0.0025 * 14 * scale),
      bodyXs: body(13 * scale, 1.5, 0.0015 * 13 * scale),
      // Body short (line-height 1.3)
      bodyShortXl: body(20 * scale, 1.3, 0.005 * 20 * scale),
      bodyShortLg: body(18 * scale, 1.3, 0.005 * 18 * scale),
      bodyShortMd: body(16 * scale, 1.3, 0.005 * 16 * scale),
      bodyShortSm: body(14 * scale, 1.3, 0.0025 * 14 * scale),
      bodyShortXs: body(13 * scale, 1.3, 0.0015 * 13 * scale),
      // Body long (line-height 1.7)
      bodyLongXl: body(20 * scale, 1.7, 0.005 * 20 * scale),
      bodyLongLg: body(18 * scale, 1.7, 0.005 * 18 * scale),
      bodyLongMd: body(16 * scale, 1.7, 0.005 * 16 * scale),
      bodyLongSm: body(14 * scale, 1.7, 0.0025 * 14 * scale),
      bodyLongXs: body(13 * scale, 1.7, 0.0015 * 13 * scale),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DsTypography &&
          other.fontFamily == fontFamily &&
          other.heading2xl == heading2xl &&
          other.headingXl == headingXl &&
          other.headingLg == headingLg &&
          other.headingMd == headingMd &&
          other.headingSm == headingSm &&
          other.headingXs == headingXs &&
          other.heading2xs == heading2xs &&
          other.bodyXl == bodyXl &&
          other.bodyLg == bodyLg &&
          other.bodyMd == bodyMd &&
          other.bodySm == bodySm &&
          other.bodyXs == bodyXs &&
          other.bodyShortXl == bodyShortXl &&
          other.bodyShortLg == bodyShortLg &&
          other.bodyShortMd == bodyShortMd &&
          other.bodyShortSm == bodyShortSm &&
          other.bodyShortXs == bodyShortXs &&
          other.bodyLongXl == bodyLongXl &&
          other.bodyLongLg == bodyLongLg &&
          other.bodyLongMd == bodyLongMd &&
          other.bodyLongSm == bodyLongSm &&
          other.bodyLongXs == bodyLongXs;

  @override
  int get hashCode => Object.hashAll([
    fontFamily,
    heading2xl,
    headingXl,
    headingLg,
    headingMd,
    headingSm,
    headingXs,
    heading2xs,
    bodyXl,
    bodyLg,
    bodyMd,
    bodySm,
    bodyXs,
    bodyShortXl,
    bodyShortLg,
    bodyShortMd,
    bodyShortSm,
    bodyShortXs,
    bodyLongXl,
    bodyLongLg,
    bodyLongMd,
    bodyLongSm,
    bodyLongXs,
  ]);
}
