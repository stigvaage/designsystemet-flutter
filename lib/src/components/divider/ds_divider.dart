import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// A horizontal or vertical divider line using the theme's border color.
///
/// A horizontal divider (default) stretches to fill the available width and
/// has [thickness] as its height. Place it in a context that provides a bounded
/// width (e.g. a [Column] or any constrained box).
///
/// A vertical divider has [thickness] as its width and takes its height from
/// the parent's cross-axis constraint. When a vertical divider is placed in a
/// context where the cross axis is unbounded — for example a [Row] without
/// stretch alignment, or an unconstrained box — it would otherwise collapse to
/// zero height and become invisible. To keep it visible the vertical divider
/// falls back to a token-derived minimum height ([length] when provided, or
/// `sizeTokens.size6`). Provide an explicit [length], or give the parent a
/// bounded height (e.g. via a [SizedBox] or `IntrinsicHeight`), to control the
/// extent.
class DsDivider extends StatelessWidget {
  const DsDivider({
    super.key,
    this.color,
    this.vertical = false,
    this.thickness = 1,
    this.length,
  });

  final DsColor? color;
  final bool vertical;
  final double thickness;

  /// The extent along the divider's main axis: the width of a horizontal
  /// divider or the height of a vertical divider.
  ///
  /// When `null` the divider stretches to fill the available space along its
  /// main axis. A vertical divider additionally uses this value (or a
  /// token-derived fallback) as a minimum height so it stays visible in
  /// unbounded cross-axis contexts.
  final double? length;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    // Dividers are decorative; the React divider sets aria-hidden="true",
    // so we exclude it from the semantics tree.
    return ExcludeSemantics(
      child: vertical
          // A vertical divider takes its height from the parent's cross-axis
          // constraint. In an unbounded context (e.g. a Row without stretch)
          // that constraint is zero, which would make the divider invisible.
          // Guarantee a token-derived minimum height so it always renders.
          ? Container(
              width: thickness,
              height: length,
              constraints: BoxConstraints(
                minHeight: length ?? theme.sizeTokens.size6,
              ),
              color: colorScale.borderSubtle,
            )
          : Container(
              height: thickness,
              width: length,
              color: colorScale.borderSubtle,
            ),
    );
  }
}
