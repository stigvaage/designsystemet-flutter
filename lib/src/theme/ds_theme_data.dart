import 'dart:ui' show Brightness;
import 'package:flutter/material.dart' show ThemeExtension;

import 'ds_border_radius_tokens.dart';
import 'ds_color_scheme.dart';
import 'ds_shadow_tokens.dart';
import 'ds_size_tokens.dart';
import 'ds_typography.dart';

/// Immutable collection of all Designsystemet design tokens.
///
/// Contains color scheme, typography, size tokens, border radii, and shadows.
/// Use [DsTheme.of] to access the active instance from the widget tree.
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
