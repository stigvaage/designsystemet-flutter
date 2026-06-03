import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// A page navigation control with numbered page buttons and prev/next arrows.
class DsPagination extends StatelessWidget {
  const DsPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.size,
    this.color,
    this.showPages = 7,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final DsSize? size;
  final DsColor? color;

  /// Maximum number of page buttons to show before collapsing the middle of
  /// the range into an ellipsis ("…"). Mirrors the React `showPages` (default
  /// 7). Ranges with `totalPages <= showPages` render every page.
  final int showPages;

  /// Computes the visible page steps for [currentPage]/[totalPages], inserting
  /// `0` markers where an ellipsis should appear. Ported verbatim from the
  /// official Designsystemet `getSteps` algorithm (packages/web pagination).
  @visibleForTesting
  static List<int> computeSteps(
    int currentPage,
    int totalPages, {
    int show = 7,
  }) {
    final offset = (show - 1) / 2;
    final start = math.max(
      math.min(currentPage - offset.floor(), totalPages - show + 1),
      1,
    );
    final end = math.min(
      math.max(currentPage + offset.ceil(), show),
      totalPages,
    );
    final pages = <int>[for (var i = start; i <= end; i++) i];
    if (show > 4 && start > 1) pages.replaceRange(0, 2, const [1, 0]);
    if (show > 3 && end < totalPages) {
      pages.replaceRange(pages.length - 2, pages.length, [0, totalPages]);
    }
    return pages;
  }

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
          button: true,
          selected: isActive,
          label: 'Side $page',
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

    Widget ellipsis() {
      return Semantics(
        label: 'flere sider',
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: Center(
            child: Text(
              '…',
              style: TextStyle(
                fontSize: fontSize,
                color: colorScale.textSubtle,
              ),
            ),
          ),
        ),
      );
    }

    final hasPrev = currentPage > 1;
    final hasNext = currentPage < totalPages;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous
        Semantics(
          button: true,
          enabled: hasPrev,
          label: 'Forrige side',
          child: Opacity(
            opacity: hasPrev ? 1.0 : theme.disabledOpacity,
            child: GestureDetector(
              onTap: hasPrev ? () => onPageChanged(currentPage - 1) : null,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                alignment: Alignment.center,
                child: Text(
                  '‹',
                  style: TextStyle(
                    fontSize: fontSize + 4,
                    color: colorScale.textDefault,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Pages (windowed with ellipsis for large ranges)
        for (final page in computeSteps(
          currentPage,
          totalPages,
          show: showPages,
        ))
          if (page == 0) ellipsis() else pageButton(page),
        // Next
        Semantics(
          button: true,
          enabled: hasNext,
          label: 'Neste side',
          child: Opacity(
            opacity: hasNext ? 1.0 : theme.disabledOpacity,
            child: GestureDetector(
              onTap: hasNext ? () => onPageChanged(currentPage + 1) : null,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                alignment: Alignment.center,
                child: Text(
                  '›',
                  style: TextStyle(
                    fontSize: fontSize + 4,
                    color: colorScale.textDefault,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
