import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsFieldset extends StatelessWidget {
  const DsFieldset({
    super.key,
    required this.legend,
    required this.children,
    this.size,
    this.color,
  });

  final String legend;
  final List<Widget> children;
  final DsSize? size;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Semantics(
      label: legend,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScale.borderSubtle, width: 1),
          borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              legend,
              style: theme.typography.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScale.textDefault,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
