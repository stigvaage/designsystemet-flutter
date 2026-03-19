import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// A data table with a styled header row and body rows.
///
/// Supports zebra-striped rows and row hover highlighting via the [zebra]
/// and [hover] flags.
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
  });

  final List<Widget> columns;
  final List<List<Widget>> rows;
  final DsSize? size;
  final DsColor? color;
  final bool zebra;
  final bool stickyHeader;
  final bool hover;

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

    final headerRow = Container(
      color: colorScale.surfaceDefault,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: theme.typography.fontFamily,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: colorScale.textDefault,
        ),
        child: Row(
          children: columns
              .map(
                (col) => Expanded(
                  child: Padding(padding: cellPadding, child: col),
                ),
              )
              .toList(),
        ),
      ),
    );

    final dataRows = <Widget>[
      for (var i = 0; i < rows.length; i++)
        _DsTableRow(
          cells: rows[i],
          cellPadding: cellPadding,
          borderColor: colorScale.borderSubtle,
          backgroundColor: zebra && i.isOdd
              ? colorScale.surfaceDefault
              : colorScale.backgroundDefault,
          hoverColor: hover ? colorScale.surfaceHover : null,
          textStyle: TextStyle(
            fontFamily: theme.typography.fontFamily,
            fontSize: fontSize,
            color: colorScale.textDefault,
          ),
        ),
    ];

    // Note: stickyHeader is accepted for API compatibility but not yet
    // implemented — Column-based layout does not support sticky positioning.
    final tableContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [headerRow, ...dataRows],
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScale.borderSubtle, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: tableContent,
    );
  }
}

class _DsTableRow extends StatefulWidget {
  const _DsTableRow({
    required this.cells,
    required this.cellPadding,
    required this.borderColor,
    required this.backgroundColor,
    required this.textStyle,
    this.hoverColor,
  });

  final List<Widget> cells;
  final EdgeInsets cellPadding;
  final Color borderColor;
  final Color backgroundColor;
  final Color? hoverColor;
  final TextStyle textStyle;

  @override
  State<_DsTableRow> createState() => _DsTableRowState();
}

class _DsTableRowState extends State<_DsTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isHovered && widget.hoverColor != null
        ? widget.hoverColor!
        : widget.backgroundColor;

    Widget row = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: widget.borderColor, width: 1)),
      ),
      child: DefaultTextStyle(
        style: widget.textStyle,
        child: Row(
          children: widget.cells
              .map(
                (cell) => Expanded(
                  child: Padding(padding: widget.cellPadding, child: cell),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (widget.hoverColor != null) {
      row = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: row,
      );
    }

    return row;
  }
}
