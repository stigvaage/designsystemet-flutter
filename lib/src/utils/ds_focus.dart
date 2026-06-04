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

  /// Wraps [child] so a focus ring is always reserved (never shifts layout).
  ///
  /// This reproduces the always-reserved focus-ring pattern used by
  /// `DsButton`/`DsChip`/`DsCheckbox`: the child is wrapped in a
  /// [DecoratedBox] + [Padding] of [ringWidth] on every side, so the ring
  /// occupies the same space whether or not the control is focused.
  ///
  /// When [focused] is `true` the ring is painted via [focusRingWithRadius]
  /// (a [ringWidth]-thick [DsColorScale.borderStrong] border at [radius]).
  /// When `false` a same-width transparent border is drawn instead, keeping
  /// the layout identical. Pass the control's own corner [radius]; the
  /// reserved decoration inflates it by [ringWidth] so the gap looks even.
  /// Use [BorderRadius.zero] for a rectangular control.
  static Widget reserveRing({
    required bool focused,
    required BorderRadius radius,
    required DsColorScale scale,
    required Widget child,
  }) {
    final decoration = focused
        ? focusRingWithRadius(scale, radius)
        : BoxDecoration(
            borderRadius: BorderRadius.circular(radius.topLeft.x + ringWidth),
            border: Border.all(
              color: const Color(0x00000000),
              width: ringWidth,
            ),
          );
    return DecoratedBox(
      decoration: decoration,
      child: Padding(padding: const EdgeInsets.all(ringWidth), child: child),
    );
  }

  /// Wraps [child] so a circular focus ring is always reserved.
  ///
  /// The circular counterpart of [reserveRing], for round controls such as a
  /// radio dot or a switch thumb track. The child is wrapped in a
  /// [DecoratedBox] + [Padding] of [ringWidth] on every side so the ring
  /// occupies the same space whether or not the control is focused.
  ///
  /// When [focused] is `true` a [ringWidth]-thick [DsColorScale.borderStrong]
  /// circular border is painted; when `false` a same-width transparent
  /// circular border is drawn instead, keeping the layout identical.
  static Widget reserveRingCircle({
    required bool focused,
    required DsColorScale scale,
    required Widget child,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: focused ? scale.borderStrong : const Color(0x00000000),
          width: ringWidth,
        ),
      ),
      child: Padding(padding: const EdgeInsets.all(ringWidth), child: child),
    );
  }
}
