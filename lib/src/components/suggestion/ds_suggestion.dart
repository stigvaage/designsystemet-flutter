import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../chip/ds_chip.dart';
import '../input/ds_input.dart';

/// A single selectable option in a [DsSuggestion].
class DsSuggestionOption<T> {
  const DsSuggestionOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A combobox: a text field with a filterable overlay list of [options].
///
/// Supports [multiple] selection (rendered as removable chips), type-ahead
/// [filter]ing, [creatable] options, an empty state, and keyboard navigation
/// (Arrow keys, Enter, Escape, and Backspace to remove the last chip). Mirrors
/// the React Suggestion component (`Suggestion.Input/List/Option/Empty/Clear`
/// are covered by this single composable widget).
class DsSuggestion<T> extends StatefulWidget {
  const DsSuggestion({
    super.key,
    required this.options,
    this.onSelectedChanged,
    this.selected,
    this.multiple = false,
    this.filter = true,
    this.creatable = false,
    this.onCreate,
    this.placeholder,
    this.emptyText = 'Ingen treff',
    this.size,
    this.color,
  }) : assert(
         !creatable || onCreate != null,
         'onCreate is required when creatable is true',
       );

  final List<DsSuggestionOption<T>> options;

  /// Called with the full selection list whenever it changes.
  final ValueChanged<List<T>>? onSelectedChanged;

  /// Controlled selection. When null the widget manages its own state.
  final List<T>? selected;

  /// Allows selecting more than one option (rendered as removable chips).
  final bool multiple;

  /// When true (default), options are filtered by the query
  /// (case-insensitive contains).
  final bool filter;

  /// When true, a "create" row appears for a query with no exact match.
  final bool creatable;

  /// Builds a new value from the typed query. Required when [creatable].
  final T Function(String query)? onCreate;

  final String? placeholder;

  /// Shown when no options match and nothing can be created.
  final String emptyText;

  final DsSize? size;
  final DsColor? color;

  @override
  State<DsSuggestion<T>> createState() => _DsSuggestionState<T>();
}

class _DsSuggestionState<T> extends State<DsSuggestion<T>> {
  final _layerLink = LayerLink();
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  OverlayEntry? _entry;
  int _highlight = -1;
  List<T> _internalSelection = [];
  final List<DsSuggestionOption<T>> _created = [];
  DsThemeData? _capturedTheme;
  DsColor? _capturedColor;
  double _fieldWidth = 0;

  List<T> get _selection => widget.selected ?? _internalSelection;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    if (widget.selected != null) {
      _internalSelection = List<T>.of(widget.selected!);
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) _open();
  }

  List<DsSuggestionOption<T>> get _allOptions => [
    ...widget.options,
    ..._created,
  ];

  List<DsSuggestionOption<T>> _filteredOptions() {
    final q = _controller.text.trim().toLowerCase();
    if (!widget.filter || q.isEmpty) return _allOptions;
    return _allOptions.where((o) => o.label.toLowerCase().contains(q)).toList();
  }

  bool get _canCreate {
    final q = _controller.text.trim();
    if (!widget.creatable || q.isEmpty) return false;
    return !_allOptions.any((o) => o.label.toLowerCase() == q.toLowerCase());
  }

  String _labelFor(T value) {
    for (final o in _allOptions) {
      if (o.value == value) return o.label;
    }
    return '$value';
  }

  void _commit(List<T> next) {
    if (widget.selected == null) {
      _internalSelection = next;
    }
    widget.onSelectedChanged?.call(next);
  }

  void _toggleValue(T value) {
    final next = List<T>.of(_selection);
    if (widget.multiple) {
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
      _controller.clear();
      _highlight = -1;
      _commit(next);
      _entry?.markNeedsBuild();
      setState(() {});
    } else {
      _commit([value]);
      _controller.text = _labelFor(value);
      _close();
      setState(() {});
    }
  }

  void _removeValue(T value) {
    final next = List<T>.of(_selection)..remove(value);
    _commit(next);
    _entry?.markNeedsBuild();
    setState(() {});
  }

  void _createFromQuery() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    final value = widget.onCreate!(q);
    _created.add(DsSuggestionOption<T>(value: value, label: q));
    _toggleValue(value);
  }

  void _selectHighlightedOrFirst() {
    final filtered = _filteredOptions();
    final i = _highlight;
    if (i >= 0 && i < filtered.length) {
      _toggleValue(filtered[i].value);
    } else if (_canCreate && i == filtered.length) {
      _createFromQuery();
    } else if (filtered.length == 1) {
      _toggleValue(filtered.first.value);
    }
  }

  void _open() {
    if (_entry != null) return;
    _capturedTheme = DsTheme.of(context);
    _capturedColor = DsColorScope.of(context);
    final box = context.findRenderObject() as RenderBox?;
    _fieldWidth = box?.size.width ?? 0;
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    _highlight = -1;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final filtered = _filteredOptions();
    final count = filtered.length + (_canCreate ? 1 : 0);
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape) {
      if (_entry == null) return KeyEventResult.ignored;
      _close();
      setState(() {});
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _open();
      if (count > 0) {
        _highlight = (_highlight + 1) % count;
        _entry?.markNeedsBuild();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (count > 0) {
        _highlight = (_highlight - 1 + count) % count;
        _entry?.markNeedsBuild();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace &&
        widget.multiple &&
        _controller.text.isEmpty &&
        _selection.isNotEmpty) {
      _removeValue(_selection.last);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.multiple && _selection.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final v in _selection)
                    DsChip(
                      removable: true,
                      size: widget.size,
                      color: widget.color,
                      onRemove: () => _removeValue(v),
                      child: Text(_labelFor(v)),
                    ),
                ],
              ),
            ),
          Focus(
            onKeyEvent: _onKey,
            child: DsInput(
              controller: _controller,
              focusNode: _focusNode,
              size: widget.size,
              placeholder: widget.placeholder,
              onTap: _open,
              onChanged: (_) {
                _open();
                _highlight = -1;
                _entry?.markNeedsBuild();
                setState(() {});
              },
              onSubmitted: (_) => _selectHighlightedOrFirst(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = _capturedTheme!;
    final activeColor = widget.color ?? _capturedColor!;
    final colorScale = theme.colorScheme.resolve(activeColor);
    final filtered = _filteredOptions();
    final canCreate = _canCreate;
    final isEmpty = filtered.isEmpty && !canCreate;

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: activeColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _close();
                  _focusNode.unfocus();
                  setState(() {});
                },
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 4),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: _fieldWidth > 0 ? _fieldWidth : null,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 240),
                    decoration: BoxDecoration(
                      color: colorScale.backgroundDefault,
                      borderRadius: BorderRadius.circular(
                        theme.borderRadius.defaultRadius,
                      ),
                      border: Border.all(
                        color: colorScale.borderSubtle,
                        width: 1,
                      ),
                      boxShadow: theme.shadows.sm,
                    ),
                    child: isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              widget.emptyText,
                              style: theme.typography.bodySm.copyWith(
                                color: colorScale.textSubtle,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var i = 0; i < filtered.length; i++)
                                  _optionRow(filtered[i], i, theme, colorScale),
                                if (canCreate)
                                  _createRow(
                                    filtered.length,
                                    theme,
                                    colorScale,
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionRow(
    DsSuggestionOption<T> option,
    int index,
    DsThemeData theme,
    DsColorScale colorScale,
  ) {
    final selected = _selection.contains(option.value);
    final highlighted = _highlight == index;
    final bg = highlighted
        ? colorScale.surfaceHover
        : (selected ? colorScale.surfaceDefault : null);
    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggleValue(option.value),
        child: Container(
          color: bg,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            option.label,
            style: theme.typography.bodySm.copyWith(
              color: colorScale.textDefault,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createRow(int index, DsThemeData theme, DsColorScale colorScale) {
    final highlighted = _highlight == index;
    final query = _controller.text.trim();
    return Semantics(
      button: true,
      label: 'Opprett $query',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _createFromQuery,
        child: Container(
          color: highlighted ? colorScale.surfaceHover : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Opprett "$query"',
            style: theme.typography.bodySm.copyWith(
              color: colorScale.textDefault,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
