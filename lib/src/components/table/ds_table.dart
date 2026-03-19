import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsTable extends StatelessWidget {
  const DsTable({
    super.key,
    required this.columns,
    required this.rows,
    this.size,
    this.color,
  });

  final List<String> columns;
  final List<List<String>> rows;
  final DsSize? size;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final cellPadding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 13.0,
      DsSize.md => 14.0,
      DsSize.lg => 16.0,
    };

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScale.borderSubtle, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            color: colorScale.surfaceDefault,
            child: Row(
              children: columns
                  .map(
                    (col) => Expanded(
                      child: Padding(
                        padding: cellPadding,
                        child: Text(
                          col,
                          style: TextStyle(
                            fontFamily: theme.typography.fontFamily,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: colorScale.textDefault,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Rows
          for (final row in rows)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScale.borderSubtle, width: 1),
                ),
              ),
              child: Row(
                children: row
                    .map(
                      (cell) => Expanded(
                        child: Padding(
                          padding: cellPadding,
                          child: Text(
                            cell,
                            style: TextStyle(
                              fontFamily: theme.typography.fontFamily,
                              fontSize: fontSize,
                              color: colorScale.textDefault,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
