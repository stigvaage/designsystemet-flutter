import 'package:flutter/widgets.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsBadge extends StatelessWidget {
  const DsBadge({
    super.key,
    required this.child,
    this.count,
    this.size,
    this.color,
    this.overlap = false,
    this.placement = DsBadgePlacement.topRight,
  });

  final Widget child;
  final int? count;
  final DsSize? size;
  final DsColor? color;
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

    final badge = Container(
      constraints: BoxConstraints(minWidth: badgeSize, minHeight: badgeSize),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: colorScale.baseDefault,
        borderRadius: BorderRadius.circular(badgeSize / 2),
      ),
      child: Center(
        child: Text(
          count! > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: colorScale.baseContrastDefault,
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

    return Stack(
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
    );
  }
}
