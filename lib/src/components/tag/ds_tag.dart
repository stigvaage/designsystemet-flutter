import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsTag extends StatelessWidget {
  const DsTag({
    super.key,
    required this.child,
    this.size,
    this.color,
  });

  final Widget child;
  final DsSize? size;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final radius = BorderRadius.circular(theme.borderRadius.sm);

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    };

    final fontSize = switch (sizeMode) {
      DsSize.sm => 12.0,
      DsSize.md => 14.0,
      DsSize.lg => 16.0,
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScale.surfaceTinted,
        borderRadius: radius,
        border: Border.all(color: colorScale.borderSubtle, width: 1),
      ),
      child: DefaultTextStyle(
        style: theme.typography.bodyXs.copyWith(
          fontSize: fontSize,
          color: colorScale.textDefault,
        ),
        child: child,
      ),
    );
  }
}
