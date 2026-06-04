import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';

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

  /// When true, the control cannot be opened but is not dimmed.
  final bool readOnly;

  @override
  State<DsSelect<T>> createState() => _DsSelectState<T>();
}

class _DsSelectState<T> extends State<DsSelect<T>> {
  final _layerLink = LayerLink();

  /// Focus node for the trigger so it can be focused on tap and receive
  /// keyboard activation (Enter/Space toggles open/close).
  final _focusNode = FocusNode();
  OverlayEntry? _entry;
  DsThemeData? _capturedTheme;
  DsColor? _capturedColor;
  double _fieldWidth = 0;

  /// Index of the keyboard-highlighted option within [_allOptions], or -1 when
  /// nothing is highlighted. Driven by ArrowUp/ArrowDown so a keyboard user can
  /// navigate and select an option without a pointer.
  int _highlight = -1;

  bool get _isOpen => _entry != null;

  /// All options, flattened across [DsSelect.options] and group options.
  List<DsSelectOption<T>> get _allOptions => [
    ...widget.options,
    for (final g in widget.groups ?? <DsSelectOptgroup<T>>[]) ...g.options,
  ];

  DsSelectOption<T>? get _selectedOption {
    if (widget.value == null) return null;
    for (final o in _allOptions) {
      if (o.value == widget.value) return o;
    }
    return null;
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    if (_isOpen || widget.disabled || widget.readOnly) return;
    // Ensure the trigger holds focus while the dropdown is open so keyboard
    // activation (Enter/Space/Escape/arrows) is routed to it.
    _focusNode.requestFocus();
    _capturedTheme = DsTheme.of(context);
    _capturedColor = widget.color ?? DsColorScope.of(context);
    // Seed the keyboard highlight on the currently selected option so arrow
    // navigation starts from the user's existing choice.
    _highlight = _allOptions.indexWhere((o) => o.value == widget.value);
    final box = context.findRenderObject() as RenderBox?;
    _fieldWidth = box?.size.width ?? 0;
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
    setState(() {});
  }

  void _close() {
    if (!_isOpen) return;
    _entry?.remove();
    _entry = null;
    _highlight = -1;
    setState(() {});
  }

  void _select(DsSelectOption<T> option) {
    widget.onChanged?.call(option.value);
    _close();
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
    final count = _allOptions.length;

    if (key == LogicalKeyboardKey.escape && _isOpen) {
      _close();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      // Open first if closed, then advance the highlight.
      if (!_isOpen) _open();
      if (count > 0) {
        _highlight = (_highlight + 1) % count;
        _entry?.markNeedsBuild();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (!_isOpen) _open();
      if (count > 0) {
        _highlight = (_highlight - 1 + count) % count;
        _entry?.markNeedsBuild();
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      // When open with a highlighted option, Enter/Space selects it; otherwise
      // it toggles the dropdown open/closed.
      if (_isOpen && _highlight >= 0 && _highlight < count) {
        _select(_allOptions[_highlight]);
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
    _focusNode.dispose();
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

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 14.0,
      DsSize.md => 16.0,
      DsSize.lg => 18.0,
    };

    final displayText = selected?.label ?? widget.placeholder ?? '';

    final trigger = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScale.backgroundDefault,
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
        border: Border.all(
          color: hasError
              ? dangerScale.borderDefault
              : colorScale.borderDefault,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontFamily: theme.typography.fontFamily,
                fontSize: fontSize,
                color: selected != null
                    ? colorScale.textDefault
                    : colorScale.textSubtle,
              ),
            ),
          ),
          Icon(DsIcons.chevronDown, size: 16, color: colorScale.textSubtle),
        ],
      ),
    );

    final semanticValue = displayText.isNotEmpty ? displayText : null;

    if (widget.disabled || widget.readOnly) {
      return Semantics(
        button: true,
        label: 'Velg',
        value: semanticValue,
        enabled: !widget.disabled,
        readOnly: widget.readOnly,
        child: Opacity(
          opacity: widget.disabled ? theme.disabledOpacity : 1.0,
          child: trigger,
        ),
      );
    }

    return Semantics(
      button: true,
      label: 'Velg',
      value: semanticValue,
      expanded: _isOpen,
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
            child: trigger,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = _capturedTheme!;
    final activeColor = widget.color ?? _capturedColor!;
    final colorScale = theme.colorScheme.resolve(activeColor);

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
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 4),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: _fieldWidth > 0 ? _fieldWidth : null,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 160,
                      maxHeight: 280,
                    ),
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
                    child: SingleChildScrollView(
                      // Group the option rows under a single semantics
                      // container so assistive technology announces them as a
                      // cohesive listbox of options rather than loose buttons.
                      child: Semantics(
                        container: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final option in widget.options)
                              _optionRow(
                                option,
                                _allOptions.indexOf(option),
                                theme,
                                colorScale,
                              ),
                            for (final group
                                in widget.groups ?? <DsSelectOptgroup<T>>[])
                              ..._groupRows(group, theme, colorScale),
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

  List<Widget> _groupRows(
    DsSelectOptgroup<T> group,
    DsThemeData theme,
    DsColorScale colorScale,
  ) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Text(
          group.label,
          style: theme.typography.bodySm.copyWith(
            color: colorScale.textSubtle,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      for (final option in group.options)
        _optionRow(option, _allOptions.indexOf(option), theme, colorScale),
    ];
  }

  Widget _optionRow(
    DsSelectOption<T> option,
    int index,
    DsThemeData theme,
    DsColorScale colorScale,
  ) {
    final selected = widget.value != null && option.value == widget.value;
    final highlighted = _highlight == index;
    // Keyboard highlight takes precedence visually so arrow navigation is
    // clearly visible; a selected-but-not-highlighted row keeps the subtle
    // surface background.
    final background = highlighted
        ? colorScale.surfaceHover
        : (selected ? colorScale.surfaceDefault : null);
    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _select(option),
        child: Container(
          color: background,
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
}
