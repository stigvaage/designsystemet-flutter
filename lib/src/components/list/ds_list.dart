import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsList extends StatelessWidget {
  const DsList({
    super.key,
    required this.items,
    this.ordered = false,
    this.color,
  });

  final List<Widget> items;
  final bool ordered;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    ordered ? '${i + 1}.' : '•',
                    style: theme.typography.bodyMd.copyWith(
                      color: colorScale.textDefault,
                    ),
                  ),
                ),
                Expanded(
                  child: DefaultTextStyle(
                    style: theme.typography.bodyMd.copyWith(
                      color: colorScale.textDefault,
                    ),
                    child: items[i],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
