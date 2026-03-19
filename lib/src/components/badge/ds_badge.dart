import 'package:flutter/widgets.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// A numeric badge overlay positioned on a corner of its [child] widget.
///
/// Displays a [count] value (capped at [maxCount]) in a colored pill.
/// Supports base and tinted variants and configurable corner placement.
class DsBadge extends StatelessWidget {
  const DsBadge({
    super.key,
    required this.child,
    this.count,
    this.maxCount = 99,
    this.size,
    this.color,
    this.variant = DsBadgeVariant.base,
    this.overlap = false,
    this.placement = DsBadgePlacement.topRight,
  });

  final Widget child;
  final int? count;
  final int maxCount;
  final DsSize? size;
  final DsColor? color;
  final DsBadgeVariant variant;
  final bool overlap;
  final DsBadgePlacement placement;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColor.danger;
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);

    final badgeSize = switch (sizeMode) {
      DsSize.sm => 16.0,
      DsSize.md => 20.0,
      DsSize.lg => 24.0,
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 10.0,
      DsSize.md => 12.0,
      DsSize.lg => 14.0,
    };

    if (count == null) return child;

    final offset = overlap ? -(badgeSize / 2) : 0.0;

    final (bgColor, textColor, border) = switch (variant) {
      DsBadgeVariant.base => (
        colorScale.baseDefault,
        colorScale.baseContrastDefault,
        null as Border?,
      ),
      DsBadgeVariant.tinted => (
        colorScale.surfaceTinted,
        colorScale.textDefault,
        Border.all(color: colorScale.borderSubtle, width: 1),
      ),
    };

    final badge = Container(
      constraints: BoxConstraints(minWidth: badgeSize, minHeight: badgeSize),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(badgeSize / 2),
        border: border,
      ),
      child: Center(
        child: Text(
          count! > maxCount ? '$maxCount+' : count.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    final (top, right, bottom, left) = switch (placement) {
      DsBadgePlacement.topRight => (
        offset,
        offset,
        null as double?,
        null as double?,
      ),
      DsBadgePlacement.topLeft => (
        offset,
        null as double?,
        null as double?,
        offset,
      ),
      DsBadgePlacement.bottomRight => (
        null as double?,
        offset,
        offset,
        null as double?,
      ),
      DsBadgePlacement.bottomLeft => (
        null as double?,
        null as double?,
        offset,
        offset,
      ),
    };

    final badgeLabel = count! > maxCount
        ? '$maxCount+ varsler'
        : '$count ${count == 1 ? 'varsel' : 'varsler'}';

    return Semantics(
      label: badgeLabel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            top: top,
            right: right,
            bottom: bottom,
            left: left,
            child: badge,
          ),
        ],
      ),
    );
  }
}
