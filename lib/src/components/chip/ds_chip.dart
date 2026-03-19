import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';

class DsChip extends StatelessWidget {
  const DsChip({
    super.key,
    required this.child,
    this.size,
    this.color,
    this.removable = false,
    this.selected = false,
    this.onRemove,
    this.onTap,
  });

  final Widget child;
  final DsSize? size;
  final DsColor? color;
  final bool removable;
  final bool selected;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final radius = BorderRadius.circular(theme.borderRadius.full);

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    };

    final bgColor = selected
        ? colorScale.baseDefault
        : colorScale.surfaceTinted;
    final fgColor = selected
        ? colorScale.baseContrastDefault
        : colorScale.textDefault;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: Border.all(
          color: selected ? colorScale.baseDefault : colorScale.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Padding(
              padding: padding,
              child: DefaultTextStyle(
                style: theme.typography.bodyMd.copyWith(color: fgColor),
                child: child,
              ),
            ),
          ),
          if (removable) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              child: Padding(
                padding: EdgeInsets.only(right: padding.right),
                child: Icon(DsIcons.x, size: 14, color: fgColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
