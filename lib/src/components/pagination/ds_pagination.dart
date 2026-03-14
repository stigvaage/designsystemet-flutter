import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsPagination extends StatelessWidget {
  const DsPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.size,
    this.color,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final DsSize? size;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final buttonSize = switch (sizeMode) {
      DsSize.sm => 28.0,
      DsSize.md => 36.0,
      DsSize.lg => 44.0,
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 12.0,
      DsSize.md => 14.0,
      DsSize.lg => 16.0,
    };

    Widget pageButton(int page) {
      final isActive = page == currentPage;
      return GestureDetector(
        onTap: isActive ? null : () => onPageChanged(page),
        child: Semantics(
          selected: isActive,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? colorScale.baseDefault : null,
              borderRadius: BorderRadius.circular(theme.borderRadius.sm),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? colorScale.baseContrastDefault
                    : colorScale.textDefault,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous
        GestureDetector(
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            alignment: Alignment.center,
            child: Text('‹',
                style: TextStyle(
                    fontSize: fontSize + 4, color: colorScale.textDefault)),
          ),
        ),
        // Pages
        for (var i = 1; i <= totalPages; i++) pageButton(i),
        // Next
        GestureDetector(
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            alignment: Alignment.center,
            child: Text('›',
                style: TextStyle(
                    fontSize: fontSize + 4, color: colorScale.textDefault)),
          ),
        ),
      ],
    );
  }
}
