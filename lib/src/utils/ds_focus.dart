import 'package:flutter/widgets.dart';
import '../theme/ds_color_scale.dart';

/// Utility for creating focus ring [BoxDecoration]s around interactive widgets.
class DsFocus {
  DsFocus._();

  static const double ringWidth = 3.0;
  static const double ringOffset = 2.0;

  static BoxDecoration focusRing(DsColorScale colorScale) {
    return BoxDecoration(
      border: Border.all(color: colorScale.borderStrong, width: ringWidth),
    );
  }

  static BoxDecoration focusRingWithRadius(
    DsColorScale colorScale,
    BorderRadius borderRadius,
  ) {
    return BoxDecoration(
      border: Border.all(color: colorScale.borderStrong, width: ringWidth),
      borderRadius: borderRadius,
    );
  }
}
