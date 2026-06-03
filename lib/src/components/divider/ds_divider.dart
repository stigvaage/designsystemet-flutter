import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// A horizontal or vertical divider line using the theme's border color.
class DsDivider extends StatelessWidget {
  const DsDivider({
    super.key,
    this.color,
    this.vertical = false,
    this.thickness = 1,
  });

  final DsColor? color;
  final bool vertical;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    // Dividers are decorative; the React divider sets aria-hidden="true",
    // so we exclude it from the semantics tree.
    return ExcludeSemantics(
      child: vertical
          ? Container(width: thickness, color: colorScale.borderSubtle)
          : Container(height: thickness, color: colorScale.borderSubtle),
    );
  }
}
