import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_overlay_anchors.dart';
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
    this.createLabel,
    this.placeholder,
    this.emptyText = 'Ingen treff',
    this.size,
    this.color,
    this.focusNode,
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

  /// Builds the label for the «create» row from the typed query. Defaults to
  /// the Norwegian `Opprett "$query"`. Only used when [creatable] is true.
  final String Function(String query)? createLabel;

  final String? placeholder;

  /// Shown when no options match and nothing can be created.
  final String emptyText;

  final DsSize? size;
  final DsColor? color;

  /// Optional external focus node for the underlying text field. When null the
  /// widget creates and owns its own.
  final FocusNode? focusNode;

  @override
  State<DsSuggestion<T>> createState() => _DsSuggestionState<T>();
}

class _DsSuggestionState<T> extends State<DsSuggestion<T>> {
  final _layerLink = LayerLink();
  // Identifies the field cluster's render box so the outside-tap barrier can
  // exclude taps that land inside it (moving the caret must not close the list,
  // and in multiple mode tapping a chip's remove button must not either). This
  // tags the whole cluster — the chips Wrap and the input together — not just
  // the input rect, so interactions anywhere within the field keep the list
  // open.
  final _fieldKey = GlobalKey();
  late final TextEditingController _controller;
  // Only owned (and disposed) when the host did not supply a [focusNode].
  FocusNode? _ownFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());
  // Per-row keys so the highlighted option can be scrolled into view during
  // arrow-key navigation. Rebuilt each overlay build and keyed by row index
  // (option rows first, then the optional create row).
  final List<GlobalKey> _rowKeys = [];
  OverlayEntry? _entry;
  int _highlight = -1;
  List<T> _internalSelection = [];
  // The most recent list handed to _commit. In controlled mode the parent may
  // not have flushed widget.selected back yet between rapid keystrokes, so
  // reading _selection.last per backspace can re-target a stale value. This
  // mirrors the last committed list so successive backspaces remove distinct
  // chips even before the controlled prop updates.
  List<T>? _lastCommitted;
  final List<DsSuggestionOption<T>> _created = [];
  DsThemeData? _capturedTheme;
  DsColor? _capturedColor;
  double _fieldWidth = 0;
  // Resolved on open: whether the list flips above the field (#23) and the
  // maxHeight it may occupy without colliding with the soft keyboard.
  bool _placeAbove = false;
  double _maxHeight = 240;

  List<T> get _selection => widget.selected ?? _internalSelection;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.addListener(_handleFocusChange);
    if (widget.selected != null) {
      _internalSelection = List<T>.of(widget.selected!);
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) _open();
  }

  @override
  void didUpdateWidget(DsSuggestion<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the parent pushes a new controlled selection, it supersedes any
    // optimistic _lastCommitted we were tracking for backspace removal.
    if (widget.selected != null &&
        !_listEquals(widget.selected!, oldWidget.selected)) {
      _lastCommitted = null;
    }
    // Move the focus listener if the host swapped the focus node (or toggled
    // between an external one and our own). _focusNode resolves to the current
    // node, so re-add the listener there.
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(
        _handleFocusChange,
      );
      _focusNode.addListener(_handleFocusChange);
    }
  }

  bool _listEquals(List<T> a, List<T>? b) {
    if (b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// The list a backspace should remove from. Prefers the optimistic
  /// [_lastCommitted] when it is still in sync with the current [_selection]
  /// length so rapid backspaces (before a controlled prop flushes) target
  /// distinct chips instead of re-reading a stale last value.
  List<T> get _backspaceBase {
    final committed = _lastCommitted;
    if (committed != null && committed.length <= _selection.length) {
      return committed;
    }
    return _selection;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If the overlay is open when an inherited dependency (e.g. a theme or
    // color-scope swap) changes, re-capture it so the list does not render
    // with a stale, frozen theme. _open() only captures once on open.
    if (_entry != null) {
      _capturedTheme = DsTheme.of(context);
      _capturedColor = DsColorScope.of(context);
      // didChangeDependencies can run during the build phase; defer the
      // overlay rebuild to avoid markNeedsBuild-during-build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _entry?.markNeedsBuild();
      });
    }
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
    _lastCommitted = List<T>.of(next);
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
    // Use the optimistic base so successive removals (e.g. rapid backspaces in
    // controlled mode) build on the previous result rather than a stale prop.
    final next = List<T>.of(_backspaceBase)..remove(value);
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
    _resolveOverlayBounds(box);
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
    // Rebuild the host so Semantics(expanded: _entry != null) flips to true.
    // Several open paths (ArrowDown/ArrowUp, focus, onTap) reach here without
    // their own setState, so without this the combobox would announce as
    // collapsed while the list is visible (WCAG 4.1.2).
    if (mounted) setState(() {});
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    _highlight = -1;
    // Rebuild the host so Semantics(expanded:) flips back to false on close.
    if (mounted) setState(() {});
  }

  /// Decides whether the list opens below (default) or flips above the field,
  /// and clamps its max height to the space actually available (#23).
  ///
  /// On phones the field focus raises the soft keyboard, so the room below the
  /// anchor shrinks to `viewport.height - viewInsets.bottom - anchor.bottom`.
  /// When there is more room above, the list flips up (reusing the shared
  /// [dsResolvePlacement] flip logic) so it is not hidden behind the keyboard.
  void _resolveOverlayBounds(RenderBox? box) {
    const gap = 4.0; // Matches the follower offset below.
    const preferred = 240.0; // The design default cap.
    final media = MediaQuery.maybeOf(context);
    final rect = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    // Without a real, positive viewport we cannot reason about available space
    // (e.g. a zero-sized MediaQuery in tests); keep the canonical downward,
    // preferred-height behavior.
    if (rect == null ||
        media == null ||
        media.size.height <= 0 ||
        media.size.width <= 0) {
      _placeAbove = false;
      _maxHeight = preferred;
      return;
    }
    // The bottom inset (typically the soft keyboard) eats into the usable
    // viewport; treat it as the effective bottom edge for the space below.
    final usableBottom = media.size.height - media.viewInsets.bottom;
    // dsResolvePlacement compares anchor.top against (screen.height -
    // anchor.bottom). Shrinking screen.height by the bottom inset makes that
    // "below" measurement account for the keyboard, so it flips up correctly.
    final resolved = dsResolvePlacement(
      placement: DsPlacement.bottomStart,
      autoPlacement: true,
      anchorRect: rect,
      screen: Size(media.size.width, usableBottom),
    );
    _placeAbove = resolved == DsPlacement.topStart;
    final spaceBelow = usableBottom - rect.bottom - gap;
    final spaceAbove = rect.top - gap;
    final available = _placeAbove ? spaceAbove : spaceBelow;
    // Never go below a small floor so the list is at least usable; clamp to the
    // preferred cap otherwise.
    _maxHeight = available.clamp(64.0, preferred);
  }

  /// Scrolls the currently highlighted row into view during keyboard
  /// navigation (#21). The row exposes a [GlobalKey]; once a frame is laid out
  /// we use [Scrollable.ensureVisible] on its element.
  void _scrollHighlightedIntoView() {
    if (_highlight < 0 || _highlight >= _rowKeys.length) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _rowKeys[_highlight].currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: const Duration(milliseconds: 100),
      );
    });
  }

  /// Whether [globalPosition] falls inside the field cluster's painted rect.
  ///
  /// The rect spans the whole cluster — the chips Wrap (in multiple mode) and
  /// the input — because [_fieldKey] tags the outer [Column].
  ///
  /// The outside-tap barrier (which closes the list) covers the whole overlay,
  /// including the area over the field. Without this guard a tap on the field —
  /// e.g. to reposition the caret, or a chip's remove button in multiple mode —
  /// would be swallowed by the barrier, closing the list and dropping focus.
  /// Taps inside this rect are therefore let through so the field (or chip)
  /// handles them itself.
  bool _isInsideField(Offset globalPosition) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return false;
    final topLeft = box.localToGlobal(Offset.zero);
    return (topLeft & box.size).contains(globalPosition);
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
        _scrollHighlightedIntoView();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _open();
      if (count > 0) {
        _highlight = (_highlight - 1 + count) % count;
        _entry?.markNeedsBuild();
        _scrollHighlightedIntoView();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace &&
        widget.multiple &&
        _controller.text.isEmpty) {
      final base = _backspaceBase;
      if (base.isNotEmpty) {
        _removeValue(base.last);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    // Only dispose the focus node we created; an external one is the host's.
    _ownFocusNode?.dispose();
    _controller.dispose();
    // Remove the overlay directly — _close() calls setState, which is illegal
    // during dispose (mounted is still true here).
    _entry?.remove();
    _entry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        // The GlobalKey tags this cluster's render box (chips + input) so the
        // outside-tap barrier can tell taps inside the field — including a
        // chip's remove button — apart from taps outside it.
        key: _fieldKey,
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
          // textField + expanded mirror the combobox role for assistive tech:
          // the field announces as an editable combobox whose popup is open
          // (expanded) whenever the overlay list is showing.
          Semantics(
            textField: true,
            expanded: _entry != null,
            child: Focus(
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

    // One key per navigable row (options, then the optional create row) so the
    // highlighted row can be scrolled into view. Reuse keys where possible so
    // element identity is stable across rebuilds during navigation.
    final rowCount = filtered.length + (canCreate ? 1 : 0);
    while (_rowKeys.length < rowCount) {
      _rowKeys.add(GlobalKey());
    }
    if (_rowKeys.length > rowCount) {
      _rowKeys.removeRange(rowCount, _rowKeys.length);
    }

    // #23: when the soft keyboard leaves more room above the field, the list
    // flips up. Anchor and follow off the matching edges so it grows upward.
    final placement = _placeAbove
        ? DsPlacement.topStart
        : DsPlacement.bottomStart;
    final (targetAnchor, followerAnchor, offset) = dsPlacementAnchors(
      placement,
    );

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: activeColor,
        child: Stack(
          children: [
            Positioned.fill(
              // A Listener (not a GestureDetector) so it never enters the
              // gesture arena and never steals the tap from the field or the
              // option rows. onPointerDown decides whether the press landed
              // outside the field; taps inside the field's rect are ignored so
              // the field keeps focus and can move the caret.
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  if (_isInsideField(event.position)) return;
                  _close();
                  _focusNode.unfocus();
                  setState(() {});
                },
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              offset: offset,
              child: Align(
                // Align toward the anchored edge so an upward list grows from
                // the bottom edge and a downward one from the top.
                alignment: _placeAbove
                    ? Alignment.bottomLeft
                    : Alignment.topLeft,
                child: SizedBox(
                  width: _fieldWidth > 0 ? _fieldWidth : null,
                  // container: true groups the overlay as a single listbox /
                  // option-container node for assistive tech, so the options
                  // (and the empty-state message) are announced as a list
                  // rather than loose siblings of the page.
                  child: Semantics(
                    container: true,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: _maxHeight),
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
                              // liveRegion announces the "no matches" message
                              // when it appears as the query narrows results.
                              child: Semantics(
                                liveRegion: true,
                                child: Text(
                                  widget.emptyText,
                                  style: theme.typography.bodySm.copyWith(
                                    color: colorScale.textSubtle,
                                  ),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (var i = 0; i < filtered.length; i++)
                                    _optionRow(
                                      filtered[i],
                                      i,
                                      theme,
                                      colorScale,
                                    ),
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
      // Keyed so _scrollHighlightedIntoView can locate this row's element.
      key: index < _rowKeys.length ? _rowKeys[index] : null,
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
    // Overridable label (#24); the Norwegian default keeps the quoted query.
    final label = widget.createLabel?.call(query) ?? 'Opprett "$query"';
    return Semantics(
      // Keyed so _scrollHighlightedIntoView can locate this row's element.
      key: index < _rowKeys.length ? _rowKeys[index] : null,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _createFromQuery,
        child: Container(
          color: highlighted ? colorScale.surfaceHover : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
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
