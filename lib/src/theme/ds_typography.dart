import 'package:flutter/widgets.dart';

/// Typography token set generated from Designsystemet font-size and line-height scales.
///
/// Provides heading (2xl–2xs), body, body-short, and body-long text styles.
/// Create an instance with [DsTypography.create] specifying the base font size.
class DsTypography {
  /// Skriftfamilie brukt for alle tekststiler (standard `Inter`).
  final String fontFamily;

  /// Overskrift 2xl (vekt 500, linjehøyde 1.3) — 60px ved referansestørrelse.
  final TextStyle heading2xl;

  /// Overskrift xl (vekt 500, linjehøyde 1.3) — 48px ved referansestørrelse.
  final TextStyle headingXl;

  /// Overskrift lg (vekt 500, linjehøyde 1.3) — 36px ved referansestørrelse.
  final TextStyle headingLg;

  /// Overskrift md (vekt 500, linjehøyde 1.3) — 30px ved referansestørrelse.
  final TextStyle headingMd;

  /// Overskrift sm (vekt 500, linjehøyde 1.3) — 24px ved referansestørrelse.
  final TextStyle headingSm;

  /// Overskrift xs (vekt 500, linjehøyde 1.3) — 21px ved referansestørrelse.
  final TextStyle headingXs;

  /// Overskrift 2xs (vekt 500, linjehøyde 1.3) — 18px ved referansestørrelse.
  final TextStyle heading2xs;

  /// Brødtekst xl (vekt 400, linjehøyde 1.5) — 24px ved referansestørrelse.
  final TextStyle bodyXl;

  /// Brødtekst lg (vekt 400, linjehøyde 1.5) — 21px ved referansestørrelse.
  final TextStyle bodyLg;

  /// Brødtekst md (vekt 400, linjehøyde 1.5) — 18px ved referansestørrelse.
  final TextStyle bodyMd;

  /// Brødtekst sm (vekt 400, linjehøyde 1.5) — 16px ved referansestørrelse.
  final TextStyle bodySm;

  /// Brødtekst xs (vekt 400, linjehøyde 1.5) — 14px ved referansestørrelse.
  final TextStyle bodyXs;

  /// Kort brødtekst xl (vekt 400, linjehøyde 1.3) — 24px ved referansestørrelse.
  final TextStyle bodyShortXl;

  /// Kort brødtekst lg (vekt 400, linjehøyde 1.3) — 21px ved referansestørrelse.
  final TextStyle bodyShortLg;

  /// Kort brødtekst md (vekt 400, linjehøyde 1.3) — 18px ved referansestørrelse.
  final TextStyle bodyShortMd;

  /// Kort brødtekst sm (vekt 400, linjehøyde 1.3) — 16px ved referansestørrelse.
  final TextStyle bodyShortSm;

  /// Kort brødtekst xs (vekt 400, linjehøyde 1.3) — 14px ved referansestørrelse.
  final TextStyle bodyShortXs;

  /// Lang brødtekst xl (vekt 400, linjehøyde 1.7) — 24px ved referansestørrelse.
  final TextStyle bodyLongXl;

  /// Lang brødtekst lg (vekt 400, linjehøyde 1.7) — 21px ved referansestørrelse.
  final TextStyle bodyLongLg;

  /// Lang brødtekst md (vekt 400, linjehøyde 1.7) — 18px ved referansestørrelse.
  final TextStyle bodyLongMd;

  /// Lang brødtekst sm (vekt 400, linjehøyde 1.7) — 16px ved referansestørrelse.
  final TextStyle bodyLongSm;

  /// Lang brødtekst xs (vekt 400, linjehøyde 1.7) — 14px ved referansestørrelse.
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
  /// Font-størrelse-stigen følger offisiell Designsystemet v1.15.0 (primitive
  /// font-size-tokens medium/factor-1 = 12/14/16/18/21/24/30/36/48/60):
  /// overskrifter 2xl/xl/lg/md/sm/xs/2xs = 60/48/36/30/24/21/18, brødtekst
  /// xl/lg/md/sm/xs = 24/21/18/16/14. De samme fem brødtekst-størrelsene
  /// brukes for body, body-short og body-long; kun linjehøyden skiller dem
  /// (body 1.5, body-short 1.3, body-long 1.7).
  ///
  /// Letter-spacing følger offisiell Designsystemet (andel av font-størrelsen):
  /// overskrifter 2xl/xl=-1%, lg=-0.5%, md=-0.25%, sm=0%, xs/2xs=+0.15%;
  /// brødtekst xl/lg/md=+0.5%, sm=+0.25%, xs=+0.15%. Implementert som
  /// `letterSpacing = andel * fontSize` (f.eks. `-0.01 * fontSize`).
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

    // Font sizes are relative to the base font size. body.md is the reference
    // token (18px ved scale = 1.0).
    final scale = baseFontSize / 18.0;

    return DsTypography._(
      fontFamily: fontFamily,
      // Headings (scaled) — letter-spacing som andel av font-størrelsen:
      // 2xl/xl=-1%, lg=-0.5%, md=-0.25%, sm=0%, xs/2xs=+0.15%.
      heading2xl: heading(60 * scale, -0.01 * 60 * scale),
      headingXl: heading(48 * scale, -0.01 * 48 * scale),
      headingLg: heading(36 * scale, -0.005 * 36 * scale),
      headingMd: heading(30 * scale, -0.0025 * 30 * scale),
      headingSm: heading(24 * scale, 0),
      headingXs: heading(21 * scale, 0.0015 * 21 * scale),
      heading2xs: heading(18 * scale, 0.0015 * 18 * scale),
      // Body default (line-height 1.5) — letter-spacing som andel av font-
      // størrelsen: xl/lg/md=+0.5%, sm=+0.25%, xs=+0.15%.
      bodyXl: body(24 * scale, 1.5, 0.005 * 24 * scale),
      bodyLg: body(21 * scale, 1.5, 0.005 * 21 * scale),
      bodyMd: body(18 * scale, 1.5, 0.005 * 18 * scale),
      bodySm: body(16 * scale, 1.5, 0.0025 * 16 * scale),
      bodyXs: body(14 * scale, 1.5, 0.0015 * 14 * scale),
      // Body short (line-height 1.3) — samme størrelser/letter-spacing som body.
      bodyShortXl: body(24 * scale, 1.3, 0.005 * 24 * scale),
      bodyShortLg: body(21 * scale, 1.3, 0.005 * 21 * scale),
      bodyShortMd: body(18 * scale, 1.3, 0.005 * 18 * scale),
      bodyShortSm: body(16 * scale, 1.3, 0.0025 * 16 * scale),
      bodyShortXs: body(14 * scale, 1.3, 0.0015 * 14 * scale),
      // Body long (line-height 1.7) — samme størrelser/letter-spacing som body.
      bodyLongXl: body(24 * scale, 1.7, 0.005 * 24 * scale),
      bodyLongLg: body(21 * scale, 1.7, 0.005 * 21 * scale),
      bodyLongMd: body(18 * scale, 1.7, 0.005 * 18 * scale),
      bodyLongSm: body(16 * scale, 1.7, 0.0025 * 16 * scale),
      bodyLongXs: body(14 * scale, 1.7, 0.0015 * 14 * scale),
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
