import 'package:flutter/widgets.dart';
import '../theme/ds_color_scale.dart';

/// Utility for creating focus ring [BoxDecoration]s around interactive widgets.
class DsFocus {
  DsFocus._();

  /// Bredden i logiske piksler på fokusringens kant. Tilsvarer
  /// Designsystemets `--ds-border-width-focus` (3 px).
  static const double ringWidth = 3.0;

  /// Hjørneradius (logiske piksler) som brukes på fokusringen for
  /// rektangulære kontroller uten egen radius. Konsumeres som
  /// `BorderRadius.circular(ringOffset)` av brødsmuler og feiloppsummering.
  ///
  /// Navnet er av historiske grunner «offset», men verdien brukes i praksis
  /// utelukkende som en hjørneradius, ikke som en avstand mellom kontroll og
  /// ring.
  static const double ringOffset = 2.0;

  /// Returnerer en rektangulær fokusring som [BoxDecoration]: en
  /// [ringWidth]-tykk [DsColorScale.borderStrong]-kant uten hjørneradius.
  static BoxDecoration focusRing(DsColorScale colorScale) {
    return BoxDecoration(
      border: Border.all(color: colorScale.borderStrong, width: ringWidth),
    );
  }

  /// Som [focusRing], men med avrundede hjørner gitt av [borderRadius].
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
  /// (a [ringWidth]-thick [DsColorScale.borderStrong] border). When `false` a
  /// same-width transparent border is drawn instead, keeping the layout
  /// identical. Pass the control's own corner [radius]; both the focused and
  /// the reserved decoration inflate it by [ringWidth] on every corner so the
  /// painted ring stays concentric with the control and the corner shape does
  /// not jump when focus toggles. Use [BorderRadius.zero] for a rectangular
  /// control.
  static Widget reserveRing({
    required bool focused,
    required BorderRadius radius,
    required DsColorScale scale,
    required Widget child,
  }) {
    // The border sits [ringWidth] outside the child on every side, so the
    // ring's outer corner radius must be the control's radius + [ringWidth]
    // to stay concentric. Inflate per-corner (not just topLeft.x) so
    // non-uniform radii are preserved, and use the same inflated radius in
    // both branches to avoid a corner-shape jump on focus toggle.
    final inflatedRadius = radius + BorderRadius.circular(ringWidth);
    final decoration = focused
        ? focusRingWithRadius(scale, inflatedRadius)
        : BoxDecoration(
            borderRadius: inflatedRadius,
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
  /// The circular counterpart of [reserveRing], for genuinely circular
  /// controls such as a radio dot. (A switch track is a pill, not a circle,
  /// so it uses [reserveRing] with a stadium radius instead.) The child is
  /// wrapped in a
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
