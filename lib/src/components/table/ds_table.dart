import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';

/// A data table with a styled header, body rows, optional footer and caption.
///
/// Supports zebra striping ([zebra]), row [hover], a sticky header
/// ([stickyHeader], active only when the table is given a bounded height),
/// sortable header columns ([onSort] + [sortColumn]/[sortDirection]), and
/// clickable rows ([onRowTap]). Mirrors the React Table props.
class DsTable extends StatelessWidget {
  const DsTable({
    super.key,
    required this.columns,
    required this.rows,
    this.size,
    this.color,
    this.zebra = false,
    this.stickyHeader = false,
    this.hover = false,
    this.border = true,
    this.caption,
    this.footerRows,
    this.sortColumn,
    this.sortDirection,
    this.onSort,
    this.onRowTap,
  });

  final List<Widget> columns;
  final List<List<Widget>> rows;
  final DsSize? size;
  final DsColor? color;
  final bool zebra;

  /// Pins the header to the top while the body scrolls. Active only when the
  /// table is given a bounded height (e.g. inside a `SizedBox`/`Expanded`);
  /// otherwise it degrades gracefully to a non-scrolling table.
  final bool stickyHeader;

  final bool hover;

  /// Draws the rounded outer border (React `border`). Defaults to `true` to
  /// preserve the library's existing look.
  final bool border;

  /// Optional caption rendered above the table and exposed to screen readers.
  final Widget? caption;

  /// Optional footer rows, rendered after the body with header-like styling.
  final List<List<Widget>>? footerRows;

  /// Index of the currently sorted column (drives the sort indicator).
  final int? sortColumn;

  /// Sort direction of [sortColumn].
  final DsSortDirection? sortDirection;

  /// When set, header cells become sort buttons calling `onSort(columnIndex)`.
  final void Function(int columnIndex)? onSort;

  /// When set, body rows become tappable and keyboard-activatable.
  final void Function(int rowIndex)? onRowTap;

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

    final headerStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: colorScale.textDefault,
    );
    final bodyStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      color: colorScale.textDefault,
    );

    final headerRow = Container(
      color: colorScale.surfaceDefault,
      child: DefaultTextStyle(
        style: headerStyle,
        child: Row(
          children: [
            for (var i = 0; i < columns.length; i++)
              Expanded(child: _headerCell(i, cellPadding, colorScale)),
          ],
        ),
      ),
    );

    Widget dataRow(int i) => _DsTableRow(
      cells: rows[i],
      cellPadding: cellPadding,
      borderColor: colorScale.borderSubtle,
      backgroundColor: zebra && i.isOdd
          ? colorScale.surfaceDefault
          : colorScale.backgroundDefault,
      hoverColor: (hover || onRowTap != null) ? colorScale.surfaceHover : null,
      textStyle: bodyStyle,
      onTap: onRowTap == null ? null : () => onRowTap!(i),
    );

    Widget footerRow(int i) => Container(
      color: colorScale.surfaceTinted,
      child: DefaultTextStyle(
        style: headerStyle,
        child: Row(
          children: [
            for (final cell in footerRows![i])
              Expanded(
                child: Padding(padding: cellPadding, child: cell),
              ),
          ],
        ),
      ),
    );

    final headerHeight = cellPadding.vertical + fontSize * 1.6;

    Widget table = LayoutBuilder(
      builder: (context, constraints) {
        final canStick = stickyHeader && constraints.maxHeight.isFinite;
        if (canStick) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  height: headerHeight,
                  child: headerRow,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => dataRow(i),
                  childCount: rows.length,
                ),
              ),
              if (footerRows != null)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => footerRow(i),
                    childCount: footerRows!.length,
                  ),
                ),
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            headerRow,
            for (var i = 0; i < rows.length; i++) dataRow(i),
            if (footerRows != null)
              for (var i = 0; i < footerRows!.length; i++) footerRow(i),
          ],
        );
      },
    );

    table = Container(
      decoration: BoxDecoration(
        border: border
            ? Border.all(color: colorScale.borderSubtle, width: 1)
            : null,
        borderRadius: border
            ? BorderRadius.circular(theme.borderRadius.defaultRadius)
            : null,
      ),
      clipBehavior: border ? Clip.antiAlias : Clip.none,
      child: table,
    );

    if (caption == null) return table;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: cellPadding.vertical / 2),
            child: DefaultTextStyle(
              style: bodyStyle.copyWith(color: colorScale.textSubtle),
              child: caption!,
            ),
          ),
        ),
        table,
      ],
    );
  }

  Widget _headerCell(int i, EdgeInsets cellPadding, DsColorScale colorScale) {
    final label = columns[i];
    if (onSort == null) {
      // Non-sortable headers are still column headers for screen readers.
      return Semantics(
        header: true,
        child: Padding(padding: cellPadding, child: label),
      );
    }
    final isActive = sortColumn == i;
    final direction = isActive
        ? (sortDirection ?? DsSortDirection.none)
        : DsSortDirection.none;
    final icon = switch (direction) {
      DsSortDirection.ascending => DsIcons.chevronUp,
      DsSortDirection.descending => DsIcons.chevronDown,
      _ => DsIcons.chevronsUpDown,
    };
    return Semantics(
      header: true,
      button: true,
      // aria-sort equivalent conveyed via value + hint.
      value: switch (direction) {
        DsSortDirection.ascending => 'stigende',
        DsSortDirection.descending => 'synkende',
        _ => null,
      },
      hint: 'Sorter',
      child: _DsTableHeaderCell(
        cellPadding: cellPadding,
        colorScale: colorScale,
        onSort: () => onSort!(i),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: label),
            const SizedBox(width: 4),
            Icon(
              icon,
              size: 14,
              color: isActive ? colorScale.baseDefault : colorScale.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}

/// A sortable column header: keyboard-focusable and -activatable (Enter/Space),
/// with a visible focus ring. Tap or keyboard activation calls [onSort].
class _DsTableHeaderCell extends StatefulWidget {
  const _DsTableHeaderCell({
    required this.cellPadding,
    required this.colorScale,
    required this.onSort,
    required this.child,
  });

  final EdgeInsets cellPadding;
  final DsColorScale colorScale;
  final VoidCallback onSort;
  final Widget child;

  @override
  State<_DsTableHeaderCell> createState() => _DsTableHeaderCellState();
}

class _DsTableHeaderCellState extends State<_DsTableHeaderCell> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    // Always reserve focus ring space to prevent layout shift.
    final focusDecoration = _isFocused
        ? DsFocus.focusRing(widget.colorScale)
        : const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Color(0x00000000), width: DsFocus.ringWidth),
            ),
          );

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onSort();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (f) => setState(() => _isFocused = f),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onSort,
          child: DecoratedBox(
            decoration: focusDecoration,
            child: Padding(padding: widget.cellPadding, child: widget.child),
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) =>
      oldDelegate.height != height || oldDelegate.child != child;
}

class _DsTableRow extends StatefulWidget {
  const _DsTableRow({
    required this.cells,
    required this.cellPadding,
    required this.borderColor,
    required this.backgroundColor,
    required this.textStyle,
    this.hoverColor,
    this.onTap,
  });

  final List<Widget> cells;
  final EdgeInsets cellPadding;
  final Color borderColor;
  final Color backgroundColor;
  final Color? hoverColor;
  final TextStyle textStyle;
  final VoidCallback? onTap;

  @override
  State<_DsTableRow> createState() => _DsTableRowState();
}

class _DsTableRowState extends State<_DsTableRow> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final highlight = (_isHovered || _isFocused) && widget.hoverColor != null;
    final bgColor = highlight ? widget.hoverColor! : widget.backgroundColor;

    Widget row = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: widget.borderColor, width: 1)),
      ),
      child: DefaultTextStyle(
        style: widget.textStyle,
        child: Row(
          children: [
            for (final cell in widget.cells)
              Expanded(
                child: Padding(padding: widget.cellPadding, child: cell),
              ),
          ],
        ),
      ),
    );

    if (widget.hoverColor != null) {
      row = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: row,
      );
    }

    if (widget.onTap == null) return row;

    return Semantics(
      button: true,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onTap!();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: row,
        ),
      ),
    );
  }
}
