import 'dart:ui' show Brightness, Color, lerpDouble;
import 'package:flutter/painting.dart' show BoxShadow;

import 'ds_border_radius_tokens.dart';
import 'ds_color_scale.dart';
import 'ds_color_scheme.dart';
import 'ds_shadow_tokens.dart';
import 'ds_size_tokens.dart';
import 'ds_typography.dart';

/// Immutable collection of all Designsystemet design tokens.
///
/// Contains color scheme, typography, size tokens, border radii, and shadows.
/// Use [DsTheme.of] to access the active instance from the widget tree.
class DsThemeData {
  /// Om temaet er for lyst (`Brightness.light`) eller mørkt (`Brightness.dark`).
  final Brightness brightness;

  /// Fargesett (alle semantiske og merke-fargeskalaer).
  final DsColorScheme colorScheme;

  /// Størrelses-/avstandstokens (spacing og dimensjoner).
  final DsSizeTokens sizeTokens;

  /// Typografisett (overskrifts- og brødtekststiler).
  final DsTypography typography;

  /// Hjørneradius-tokens for komponenter.
  final DsBorderRadiusTokens borderRadius;

  /// Skygge-tokens for elevasjon (tomt sett i mørk modus).
  final DsShadowTokens shadows;

  /// Opasitet brukt på deaktiverte komponenter (standard 0.3).
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

  /// Returnerer en kopi der angitte felter er erstattet.
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

  /// Interpolerer mellom dette temaet og [other] med faktor [t] (0..1).
  ///
  /// Kontinuerlige tokens (farger, skygger) tweenes jevnt, slik at en animert
  /// temaovergang gir en reell fargeovergang. Diskrete tokens (brightness,
  /// størrelser, typografi, hjørneradius) kan ikke interpoleres meningsfullt
  /// og byttes ved midtpunktet (t >= 0.5).
  DsThemeData lerp(DsThemeData? other, double t) {
    if (other == null) return this;
    if (identical(this, other)) return this;
    // Standard lerp contract: the endpoints must compare exactly equal to the
    // inputs. Returning `this`/`other` directly avoids floating-point drift
    // from re-interpolating every color at t == 0 or t == 1.
    if (t <= 0) return this;
    if (t >= 1) return other;
    final discrete = t < 0.5 ? this : other;
    return DsThemeData(
      brightness: discrete.brightness,
      colorScheme: _lerpColorScheme(colorScheme, other.colorScheme, t),
      sizeTokens: discrete.sizeTokens,
      typography: discrete.typography,
      borderRadius: discrete.borderRadius,
      shadows: _lerpShadows(shadows, other.shadows, t),
      disabledOpacity:
          lerpDouble(disabledOpacity, other.disabledOpacity, t) ??
          discrete.disabledOpacity,
    );
  }

  static DsColorScheme _lerpColorScheme(
    DsColorScheme a,
    DsColorScheme b,
    double t,
  ) {
    if (identical(a, b)) return a;
    // The set of custom keys is treated as discrete: snap the whole custom map
    // at the midpoint rather than attempting to reconcile differing key sets.
    final custom = t < 0.5 ? a.custom : b.custom;
    return DsColorScheme(
      accent: _lerpScale(a.accent, b.accent, t),
      neutral: _lerpScale(a.neutral, b.neutral, t),
      brand1: _lerpScale(a.brand1, b.brand1, t),
      brand2: _lerpScale(a.brand2, b.brand2, t),
      brand3: _lerpScale(a.brand3, b.brand3, t),
      success: _lerpScale(a.success, b.success, t),
      danger: _lerpScale(a.danger, b.danger, t),
      warning: _lerpScale(a.warning, b.warning, t),
      info: _lerpScale(a.info, b.info, t),
      custom: custom,
    );
  }

  static DsColorScale _lerpScale(DsColorScale a, DsColorScale b, double t) {
    if (identical(a, b)) return a;
    Color c(Color x, Color y) => Color.lerp(x, y, t)!;
    return DsColorScale(
      backgroundDefault: c(a.backgroundDefault, b.backgroundDefault),
      backgroundTinted: c(a.backgroundTinted, b.backgroundTinted),
      surfaceDefault: c(a.surfaceDefault, b.surfaceDefault),
      surfaceTinted: c(a.surfaceTinted, b.surfaceTinted),
      surfaceHover: c(a.surfaceHover, b.surfaceHover),
      surfaceActive: c(a.surfaceActive, b.surfaceActive),
      borderSubtle: c(a.borderSubtle, b.borderSubtle),
      borderDefault: c(a.borderDefault, b.borderDefault),
      borderStrong: c(a.borderStrong, b.borderStrong),
      textSubtle: c(a.textSubtle, b.textSubtle),
      textDefault: c(a.textDefault, b.textDefault),
      baseDefault: c(a.baseDefault, b.baseDefault),
      baseHover: c(a.baseHover, b.baseHover),
      baseActive: c(a.baseActive, b.baseActive),
      baseContrastSubtle: c(a.baseContrastSubtle, b.baseContrastSubtle),
      baseContrastDefault: c(a.baseContrastDefault, b.baseContrastDefault),
    );
  }

  static DsShadowTokens _lerpShadows(
    DsShadowTokens a,
    DsShadowTokens b,
    double t,
  ) {
    if (identical(a, b)) return a;
    List<BoxShadow> l(List<BoxShadow> x, List<BoxShadow> y) =>
        BoxShadow.lerpList(x, y, t)!;
    return DsShadowTokens(
      xs: l(a.xs, b.xs),
      sm: l(a.sm, b.sm),
      md: l(a.md, b.md),
      lg: l(a.lg, b.lg),
      xl: l(a.xl, b.xl),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DsThemeData &&
          other.brightness == brightness &&
          other.colorScheme == colorScheme &&
          other.sizeTokens == sizeTokens &&
          other.typography == typography &&
          other.borderRadius == borderRadius &&
          other.shadows == shadows &&
          other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    brightness,
    colorScheme,
    sizeTokens,
    typography,
    borderRadius,
    shadows,
    disabledOpacity,
  );
}
