import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_size_tokens.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';
import '../../utils/ds_overlay_anchors.dart';

/// A single selectable option within a [DsSelect].
///
/// Mirrors the React `Select.Option` element: a [value] of type [T] and a
/// human-readable [label] shown in the trigger and the dropdown list.
class DsSelectOption<T> {
  const DsSelectOption({required this.value, required this.label});

  /// The value passed to [DsSelect.onChanged] when this option is chosen.
  final T value;

  /// The text rendered for this option.
  final String label;
}

/// A labelled group of [DsSelectOption]s within a [DsSelect].
///
/// Mirrors the React `Select.Optgroup` element. The [label] is rendered as a
/// non-interactive heading above its [options] in the dropdown list.
class DsSelectOptgroup<T> {
  const DsSelectOptgroup({required this.label, required this.options});

  /// The heading shown above this group's options.
  final String label;

  /// The options belonging to this group.
  final List<DsSelectOption<T>> options;
}

/// A select control that opens an overlay dropdown to choose a single value of
/// type [T] from a list of [options] and optionally grouped [groups].
///
/// Mirrors the React `Select` component (a native `<select>` composed of
/// `Select.Option` and `Select.Optgroup`). The trigger displays the [label] of
/// the currently selected option, or [placeholder] when nothing is selected.
/// Grouped options are rendered under a subtle group heading. Selecting an
/// option closes the dropdown and calls [onChanged] with its value.
///
/// The trigger gives hover and keyboard-focus feedback (an animated border plus
/// an always-reserved focus ring), matching `DsInput`, so a keyboard user
/// tabbing to the closed control sees a visible indicator (WCAG 2.4.7). The
/// dropdown clamps its height to the available viewport space and flips above
/// the trigger when there is more room there than below.
///
/// Supports [placeholder] text, an [error] state, and [disabled] / [readOnly]
/// modes. Visual styling is driven entirely by [DsTheme] and the resolved
/// [color] / [size] scopes.
class DsSelect<T> extends StatefulWidget {
  const DsSelect({
    super.key,
    required this.options,
    this.groups,
    this.value,
    this.onChanged,
    this.placeholder,
    this.size,
    this.color,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.focusNode,
    this.semanticsLabel = 'Velg',
  });

  /// The ungrouped options, rendered before any [groups].
  final List<DsSelectOption<T>> options;

  /// Optional grouped options, each rendered under its own heading.
  final List<DsSelectOptgroup<T>>? groups;

  /// The currently selected value. When null, [placeholder] is shown.
  final T? value;

  /// Called with the chosen value when an option is selected.
  final ValueChanged<T?>? onChanged;

  /// Text shown in the trigger when no value is selected.
  final String? placeholder;

  final DsSize? size;
  final DsColor? color;

  /// When non-null, the trigger is rendered with the danger border colour.
  final String? error;

  /// When true, the control is dimmed and cannot be opened.
  final bool disabled;

  /// When true, the control cannot be opened. Unlike [disabled] it is not
  /// dimmed; instead the trigger uses the subtle read-only surface fill and
  /// drops its border, matching the read-only treatment in `DsInput`.
  final bool readOnly;

  /// Optional external focus node for the trigger. When null an internal node
  /// is created and disposed with the widget.
  final FocusNode? focusNode;

  /// The accessibility label announced for the trigger. Defaults to the
  /// Norwegian «Velg»; override to describe the specific field.
  final String semanticsLabel;

  @override
  State<DsSelect<T>> createState() => _DsSelectState<T>();
}

class _DsSelectState<T> extends State<DsSelect<T>> {
  final _layerLink = LayerLink();

  /// Focus node for the trigger so it can be focused on tap and receive
  /// keyboard activation (Enter/Space toggles open/close). Falls back to an
  /// internally owned node when [DsSelect.focusNode] is null.
  FocusNode? _ownFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  OverlayEntry? _entry;
  DsThemeData? _capturedTheme;
  DsColor? _capturedColor;
  double _fieldWidth = 0;

  /// Whether the pointer is hovering the trigger, for the hover border colour.
  bool _isHovered = false;

  /// Whether the trigger currently has keyboard focus, for the focus ring and
  /// focus border colour.
  bool _isFocused = false;

  /// Placement of the dropdown relative to the trigger, resolved on each open
  /// so it flips above when there is more room there than below.
  DsPlacement _placement = DsPlacement.bottomStart;

  /// Maximum height the dropdown may occupy, clamped to the available viewport
  /// space on each open so it never overflows off-screen.
  double _maxHeight = 280;

  /// Index of the keyboard-highlighted option within [_flatOptions], or -1 when
  /// nothing is highlighted. Driven by ArrowUp/ArrowDown so a keyboard user can
  /// navigate and select an option without a pointer.
  int _highlight = -1;

  /// Per-row keys for the currently highlightable options, used to scroll the
  /// highlighted row into view via [Scrollable.ensureVisible]. Rebuilt with the
  /// flat option list each time the overlay is (re)built.
  final _rowKeys = <GlobalKey>[];

  bool get _isOpen => _entry != null;

  /// All options, flattened across [DsSelect.options] and group options.
  ///
  /// Cached while the dropdown is open so the per-row index lookups during an
  /// overlay rebuild stay O(n) instead of recomputing this list (and scanning
  /// it) for every row.
  List<DsSelectOption<T>> _flatOptions = const [];

  List<DsSelectOption<T>> _buildFlatOptions() => [
    ...widget.options,
    for (final g in widget.groups ?? <DsSelectOptgroup<T>>[]) ...g.options,
  ];

  DsSelectOption<T>? get _selectedOption {
    if (widget.value == null) return null;
    for (final o in _buildFlatOptions()) {
      if (o.value == widget.value) return o;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(DsSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    if (_isOpen || widget.disabled || widget.readOnly) return;
    // Ensure the trigger holds focus while the dropdown is open so keyboard
    // activation (Enter/Space/Escape/arrows) is routed to it.
    _focusNode.requestFocus();
    _capturedTheme = DsTheme.of(context);
    _capturedColor = widget.color ?? DsColorScope.of(context);
    // Build the flat option list ONCE for the lifetime of this open overlay and
    // seed a row key per option for scroll-into-view.
    _flatOptions = _buildFlatOptions();
    _rowKeys
      ..clear()
      ..addAll(List.generate(_flatOptions.length, (_) => GlobalKey()));
    // Seed the keyboard highlight on the currently selected option so arrow
    // navigation starts from the user's existing choice.
    _highlight = _flatOptions.indexWhere((o) => o.value == widget.value);

    final box = context.findRenderObject() as RenderBox?;
    _fieldWidth = box?.size.width ?? 0;
    final media = MediaQuery.maybeOf(context);
    final screen = media?.size;
    final rect = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    // Only treat the viewport as measured when it has a real, positive size;
    // otherwise (e.g. a zero-size MediaQuery in tests) skip both flipping and
    // height-clamping and use the default cap.
    final hasViewport = screen != null && screen.height > 0 && screen.width > 0;

    // Flip above the trigger when there is more room there than below.
    _placement = dsResolvePlacement(
      placement: DsPlacement.bottomStart,
      autoPlacement: true,
      anchorRect: rect,
      screen: hasViewport ? screen : null,
    );

    // Clamp the dropdown height to the space between the trigger and the
    // relevant viewport edge (minus the soft keyboard inset below), so it never
    // runs off-screen. Falls back to the default cap when measurements are
    // unavailable or the computed room is non-positive.
    const defaultMaxHeight = 280.0;
    if (rect != null && hasViewport) {
      const gap = 4.0;
      final bottomInset = media?.viewInsets.bottom ?? 0;
      final roomBelow = screen.height - rect.bottom - bottomInset - gap;
      final roomAbove = rect.top - gap;
      final room = _placement == DsPlacement.topStart ? roomAbove : roomBelow;
      _maxHeight = room > 0
          ? room.clamp(0.0, defaultMaxHeight)
          : defaultMaxHeight;
    } else {
      _maxHeight = defaultMaxHeight;
    }

    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
    setState(() {});
    _scrollHighlightIntoView();
  }

  void _close() {
    if (!_isOpen) return;
    _entry?.remove();
    _entry = null;
    _highlight = -1;
    _flatOptions = const [];
    _rowKeys.clear();
    setState(() {});
  }

  void _select(DsSelectOption<T> option) {
    widget.onChanged?.call(option.value);
    _close();
  }

  /// Scrolls the row at [_highlight] into view after the overlay has laid out,
  /// so arrow-key navigation never leaves the highlighted option clipped.
  void _scrollHighlightIntoView() {
    if (_highlight < 0 || _highlight >= _rowKeys.length) return;
    final key = _rowKeys[_highlight];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null || !ctx.mounted) return;
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: DsAnimation.resolveDuration(ctx, DsAnimation.fast),
        curve: DsAnimation.defaultCurve,
      );
    });
  }

  void _moveHighlight(int delta) {
    final count = _flatOptions.length;
    if (count == 0) return;
    _highlight = (_highlight + delta + count) % count;
    _entry?.markNeedsBuild();
    _scrollHighlightIntoView();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (widget.disabled || widget.readOnly) {
      return KeyEventResult.ignored;
    }
    // Allow key repeat for arrow navigation so holding the key keeps moving.
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape && _isOpen) {
      _close();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      if (!_isOpen) {
        // Opening seeds the highlight on the selected option (or -1 when none);
        // land on the first option so the user immediately has a target.
        _open();
        if (_highlight < 0 && _flatOptions.isNotEmpty) {
          _highlight = 0;
          _entry?.markNeedsBuild();
          _scrollHighlightIntoView();
        }
      } else {
        _moveHighlight(1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (!_isOpen) {
        // Opening with ArrowUp lands on the last option when nothing is yet
        // highlighted, mirroring the wrap-around navigation.
        _open();
        if (_highlight < 0 && _flatOptions.isNotEmpty) {
          _highlight = _flatOptions.length - 1;
          _entry?.markNeedsBuild();
          _scrollHighlightIntoView();
        }
      } else {
        _moveHighlight(-1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      // When open with a highlighted option, Enter/Space selects it; otherwise
      // it toggles the dropdown open/closed.
      if (_isOpen && _highlight >= 0 && _highlight < _flatOptions.length) {
        _select(_flatOptions[_highlight]);
      } else {
        _toggle();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    // Remove the overlay directly — do NOT call _close()/setState() here,
    // since setState during dispose throws.
    _entry?.remove();
    _entry = null;
    (widget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final dangerScale = theme.colorScheme.danger;
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final hasError = widget.error != null;
    final selected = _selectedOption;
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);

    final padding = sizeMode.pick(
      sm: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      md: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      lg: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
    final fontSize = DsSizeValues.fontSize(sizeMode);

    final displayText = selected?.label ?? widget.placeholder ?? '';

    // Resolve the trigger border colour with the same precedence as DsInput:
    // disabled keeps the default border; error wins next; then focus and hover
    // both promote the border to the strong colour.
    Color borderColor;
    if (widget.disabled) {
      borderColor = colorScale.borderDefault;
    } else if (hasError) {
      borderColor = dangerScale.borderDefault;
    } else if (_isFocused || _isHovered) {
      borderColor = colorScale.borderStrong;
    } else {
      borderColor = colorScale.borderDefault;
    }
    // Read-only drops the border (like DsInput) for a clear, undimmed visual
    // distinction from an editable, openable control.
    final borderSide = widget.readOnly
        ? BorderSide.none
        : BorderSide(color: borderColor, width: 1);

    final triggerTextStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      color: selected != null ? colorScale.textDefault : colorScale.textSubtle,
    );

    final trigger = AnimatedContainer(
      duration: duration,
      curve: DsAnimation.defaultCurve,
      padding: padding,
      decoration: BoxDecoration(
        color: widget.readOnly
            ? colorScale.surfaceDefault
            : colorScale.backgroundDefault,
        borderRadius: radius,
        border: Border.fromBorderSide(borderSide),
      ),
      child: Row(
        children: [
          Expanded(child: Text(displayText, style: triggerTextStyle)),
          Icon(DsIcons.chevronDown, size: 16, color: colorScale.textSubtle),
        ],
      ),
    );

    final semanticValue = displayText.isNotEmpty ? displayText : null;

    if (widget.disabled || widget.readOnly) {
      return Semantics(
        button: true,
        label: widget.semanticsLabel,
        value: semanticValue,
        enabled: !widget.disabled,
        readOnly: widget.readOnly,
        child: Opacity(
          opacity: widget.disabled ? theme.disabledOpacity : 1.0,
          child: trigger,
        ),
      );
    }

    // The focus-ring wrapper is ALWAYS in the tree (its space is reserved) and
    // only its decoration toggles, so focusing the trigger never shifts layout.
    final ringed = DsFocus.reserveRing(
      focused: _isFocused,
      radius: radius,
      scale: colorScale,
      child: trigger,
    );

    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      value: semanticValue,
      expanded: _isOpen,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              // Focus the trigger on tap so subsequent keyboard activation
              // (Enter/Space/Escape) is routed here, then toggle the dropdown.
              onTap: () {
                _focusNode.requestFocus();
                _toggle();
              },
              child: ringed,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = _capturedTheme!;
    final activeColor = widget.color ?? _capturedColor!;
    final colorScale = theme.colorScheme.resolve(activeColor);
    final (targetAnchor, followerAnchor, offset) = dsPlacementAnchors(
      _placement,
    );

    // Resolve the per-row text styles ONCE here rather than per option row.
    final optionStyle = theme.typography.bodySm.copyWith(
      color: colorScale.textDefault,
    );
    final groupHeadingStyle = theme.typography.bodySm.copyWith(
      color: colorScale.textSubtle,
      fontWeight: FontWeight.w600,
    );

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: activeColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _close,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              offset: offset,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: _fieldWidth > 0 ? _fieldWidth : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScale.backgroundDefault,
                      borderRadius: BorderRadius.circular(
                        theme.borderRadius.defaultRadius,
                      ),
                      border: Border.all(
                        color: colorScale.borderSubtle,
                        width: 1,
                      ),
                      boxShadow: theme.shadows.md,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 160,
                        maxHeight: _maxHeight,
                      ),
                      child: SingleChildScrollView(
                        // Group the option rows under a single semantics
                        // container so assistive technology announces them as a
                        // cohesive listbox of options rather than loose buttons.
                        child: Semantics(
                          container: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _buildRows(
                              colorScale,
                              optionStyle,
                              groupHeadingStyle,
                            ),
                          ),
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

  /// Builds the flat list of rows (ungrouped options, then each group heading
  /// followed by its options) in the same order as [_flatOptions], so the row
  /// index used for highlighting and scroll-into-view matches by position
  /// without any per-row `indexOf` scan.
  List<Widget> _buildRows(
    DsColorScale colorScale,
    TextStyle optionStyle,
    TextStyle groupHeadingStyle,
  ) {
    final rows = <Widget>[];
    var index = 0;
    for (final option in widget.options) {
      rows.add(_optionRow(option, index, colorScale, optionStyle));
      index++;
    }
    for (final group in widget.groups ?? <DsSelectOptgroup<T>>[]) {
      rows.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Text(group.label, style: groupHeadingStyle),
        ),
      );
      for (final option in group.options) {
        rows.add(_optionRow(option, index, colorScale, optionStyle));
        index++;
      }
    }
    return rows;
  }

  Widget _optionRow(
    DsSelectOption<T> option,
    int index,
    DsColorScale colorScale,
    TextStyle optionStyle,
  ) {
    final selected = widget.value != null && option.value == widget.value;
    final highlighted = _highlight == index;
    // Keyboard highlight takes precedence visually so arrow navigation is
    // clearly visible; a selected-but-not-highlighted row keeps the subtle
    // surface background.
    final background = highlighted
        ? colorScale.surfaceHover
        : (selected ? colorScale.surfaceDefault : null);
    final content = Padding(
      key: index < _rowKeys.length ? _rowKeys[index] : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        option.label,
        style: optionStyle.copyWith(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _select(option),
        child: background != null
            ? ColoredBox(color: background, child: content)
            : content,
      ),
    );
  }
}
