import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

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

    final pageRadius = BorderRadius.circular(theme.borderRadius.sm);

    Widget pageButton(int page) {
      final isActive = page == currentPage;
      final content = Semantics(
        // The active page is rendered as a non-interactive current-page
        // indicator (no [onTap]), so it is announced as selected but not as a
        // button. The other pages remain reachable buttons.
        button: !isActive,
        selected: isActive,
        label: 'Side $page',
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? colorScale.baseDefault : null,
            borderRadius: pageRadius,
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
      );

      // The active page is not interactive; render it without a focus wrapper
      // so it is skipped during keyboard navigation.
      if (isActive) {
        return content;
      }

      return _PaginationItem(
        colorScale: colorScale,
        borderRadius: pageRadius,
        onActivate: () => onPageChanged(page),
        child: content,
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

    // Builds a prev/next arrow control. When [enabled] it is wrapped in a
    // keyboard-focusable, activatable [_PaginationItem]; when disabled it is a
    // plain, non-interactive (and non-focusable) glyph.
    Widget arrow({
      required String glyph,
      required String label,
      required bool enabled,
      required VoidCallback onActivate,
    }) {
      final content = Container(
        width: buttonSize,
        height: buttonSize,
        alignment: Alignment.center,
        child: Text(
          glyph,
          style: TextStyle(
            fontSize: fontSize + 4,
            color: colorScale.textDefault,
          ),
        ),
      );
      return Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: Opacity(
          opacity: enabled ? 1.0 : theme.disabledOpacity,
          // Disabled arrows are non-interactive and not focusable.
          child: enabled
              ? _PaginationItem(
                  colorScale: colorScale,
                  borderRadius: pageRadius,
                  onActivate: onActivate,
                  child: content,
                )
              : content,
        ),
      );
    }

    final hasPrev = currentPage > 1;
    final hasNext = currentPage < totalPages;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous
        arrow(
          glyph: '‹',
          label: 'Forrige side',
          enabled: hasPrev,
          onActivate: () => onPageChanged(currentPage - 1),
        ),
        // Pages (windowed with ellipsis for large ranges)
        for (final page in computeSteps(
          currentPage,
          totalPages,
          show: showPages,
        ))
          if (page == 0) ellipsis() else pageButton(page),
        // Next
        arrow(
          glyph: '›',
          label: 'Neste side',
          enabled: hasNext,
          onActivate: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }
}

/// A keyboard-focusable, activatable wrapper around a single interactive
/// pagination control (a page number or the prev/next arrow).
///
/// Provides keyboard activation (Enter/Space) via [Focus.onKeyEvent] and a
/// visible focus ring. Tap activation is preserved through a [GestureDetector].
/// Space for focus-ring padding is always reserved to prevent layout shift when
/// focus moves between items.
class _PaginationItem extends StatefulWidget {
  const _PaginationItem({
    required this.colorScale,
    required this.borderRadius,
    required this.onActivate,
    required this.child,
  });

  final DsColorScale colorScale;
  final BorderRadius borderRadius;
  final VoidCallback onActivate;
  final Widget child;

  @override
  State<_PaginationItem> createState() => _PaginationItemState();
}

class _PaginationItemState extends State<_PaginationItem> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onActivate();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (f) => setState(() => _isFocused = f),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onActivate,
          // Always reserves the focus-ring gap so layout never shifts when
          // focus moves between items.
          child: DsFocus.reserveRing(
            focused: _isFocused,
            radius: widget.borderRadius,
            scale: widget.colorScale,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
