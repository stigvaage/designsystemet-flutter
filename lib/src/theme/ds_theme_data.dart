import 'dart:ui' show Brightness;
import 'package:flutter/material.dart' show ThemeExtension;

import 'ds_border_radius_tokens.dart';
import 'ds_color_scheme.dart';
import 'ds_shadow_tokens.dart';
import 'ds_size_tokens.dart';
import 'ds_typography.dart';

class DsThemeData extends ThemeExtension<DsThemeData> {
  final Brightness brightness;
  final DsColorScheme colorScheme;
  final DsSizeTokens sizeTokens;
  final DsTypography typography;
  final DsBorderRadiusTokens borderRadius;
  final DsShadowTokens shadows;
  final double disabledOpacity;

  const DsThemeData({
    required this.brightness,
    required this.colorScheme,
    required this.sizeTokens,
    required this.typography,
    required this.borderRadius,
    required this.shadows,
    this.disabledOpacity = 0.3,
  });

  factory DsThemeData.digdir({Brightness brightness = Brightness.light}) {
    // Digdir default theme — values imported from generated file
    // This is a placeholder; actual values come from ds_theme_digdir.dart
    throw UnimplementedError(
      'DsThemeData.digdir() requires the generated Digdir theme. '
      'Import package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart '
      'and use DsThemeDigdir.light() or DsThemeDigdir.dark().',
    );
  }

  factory DsThemeData.fromTokens(Map<String, dynamic> json) {
    // TODO: Implement JSON token parsing in US4
    throw UnimplementedError('DsThemeData.fromTokens() not yet implemented');
  }

  @override
  DsThemeData copyWith({
    Brightness? brightness,
    DsColorScheme? colorScheme,
    DsSizeTokens? sizeTokens,
    DsTypography? typography,
    DsBorderRadiusTokens? borderRadius,
    DsShadowTokens? shadows,
    double? disabledOpacity,
  }) {
    return DsThemeData(
      brightness: brightness ?? this.brightness,
      colorScheme: colorScheme ?? this.colorScheme,
      sizeTokens: sizeTokens ?? this.sizeTokens,
      typography: typography ?? this.typography,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  @override
  DsThemeData lerp(DsThemeData? other, double t) {
    if (other == null) return this;
    // ThemeExtension requires lerp; for discrete tokens we snap at t > 0.5
    if (t < 0.5) return this;
    return other;
  }
}
