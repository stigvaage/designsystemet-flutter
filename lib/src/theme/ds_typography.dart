import 'package:flutter/widgets.dart';

class DsTypography {
  final String fontFamily;

  // Heading styles (weight 500, line-height 1.3)
  final TextStyle heading2xl;
  final TextStyle headingXl;
  final TextStyle headingLg;
  final TextStyle headingMd;
  final TextStyle headingSm;
  final TextStyle headingXs;
  final TextStyle heading2xs;

  // Body styles - default (line-height 1.5)
  final TextStyle bodyXl;
  final TextStyle bodyLg;
  final TextStyle bodyMd;
  final TextStyle bodySm;
  final TextStyle bodyXs;

  // Body styles - short (line-height 1.3)
  final TextStyle bodyShortXl;
  final TextStyle bodyShortLg;
  final TextStyle bodyShortMd;
  final TextStyle bodyShortSm;
  final TextStyle bodyShortXs;

  // Body styles - long (line-height 1.7)
  final TextStyle bodyLongXl;
  final TextStyle bodyLongLg;
  final TextStyle bodyLongMd;
  final TextStyle bodyLongSm;
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

  factory DsTypography.create({
    String fontFamily = 'Inter',
    required double baseFontSize,
  }) {
    final features = <FontFeature>[const FontFeature('cv05')];

    TextStyle heading(double size, double letterSpacing) => TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: size,
      height: 1.3,
      letterSpacing: letterSpacing,
      fontFeatures: features,
    );

    TextStyle body(double size, double lineHeight, double letterSpacing) =>
        TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: size,
          height: lineHeight,
          letterSpacing: letterSpacing,
          fontFeatures: features,
        );

    // Font sizes are relative to the base font size
    final scale = baseFontSize / 18.0; // md is the reference (18px)

    return DsTypography._(
      fontFamily: fontFamily,
      // Headings (scaled)
      heading2xl: heading(48 * scale, -0.01 * 48 * scale),
      headingXl: heading(36 * scale, -0.005 * 36 * scale),
      headingLg: heading(30 * scale, -0.003 * 30 * scale),
      headingMd: heading(24 * scale, -0.001 * 24 * scale),
      headingSm: heading(20 * scale, 0),
      headingXs: heading(18 * scale, 0.0015 * 18 * scale),
      heading2xs: heading(16 * scale, 0.0015 * 16 * scale),
      // Body default (line-height 1.5)
      bodyXl: body(20 * scale, 1.5, 0.0005 * 20 * scale),
      bodyLg: body(18 * scale, 1.5, 0.001 * 18 * scale),
      bodyMd: body(16 * scale, 1.5, 0.002 * 16 * scale),
      bodySm: body(14 * scale, 1.5, 0.005 * 14 * scale),
      bodyXs: body(13 * scale, 1.5, 0.015 * 13 * scale),
      // Body short (line-height 1.3)
      bodyShortXl: body(20 * scale, 1.3, 0.0005 * 20 * scale),
      bodyShortLg: body(18 * scale, 1.3, 0.001 * 18 * scale),
      bodyShortMd: body(16 * scale, 1.3, 0.002 * 16 * scale),
      bodyShortSm: body(14 * scale, 1.3, 0.005 * 14 * scale),
      bodyShortXs: body(13 * scale, 1.3, 0.015 * 13 * scale),
      // Body long (line-height 1.7)
      bodyLongXl: body(20 * scale, 1.7, 0.0005 * 20 * scale),
      bodyLongLg: body(18 * scale, 1.7, 0.001 * 18 * scale),
      bodyLongMd: body(16 * scale, 1.7, 0.002 * 16 * scale),
      bodyLongSm: body(14 * scale, 1.7, 0.005 * 14 * scale),
      bodyLongXs: body(13 * scale, 1.7, 0.015 * 13 * scale),
    );
  }
}
