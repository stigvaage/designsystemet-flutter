import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsSuggestion extends StatelessWidget {
  const DsSuggestion({
    super.key,
    required this.items,
    this.onSelected,
    this.color,
  });

  final List<String> items;
  final ValueChanged<int>? onSelected;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Container(
      decoration: BoxDecoration(
        color: colorScale.backgroundDefault,
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
        border: Border.all(color: colorScale.borderSubtle, width: 1),
        boxShadow: theme.shadows.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++)
            GestureDetector(
              onTap: () => onSelected?.call(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  items[i],
                  style: theme.typography.bodySm.copyWith(
                    color: colorScale.textDefault,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
