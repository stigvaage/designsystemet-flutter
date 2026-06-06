import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A segmented toggle control where one item is selected at a time.
///
/// Supports arrow-key navigation between segments (Left/Right) as well as
/// jumping to the first/last interactive segment with Home/End. Disabled
/// segments are skipped by keyboard navigation.
///
/// The [variant] controls the emphasis of the selected segment:
/// [DsToggleGroupVariant.primary] fills it with the base color, while
/// [DsToggleGroupVariant.secondary] uses a lower-emphasis surface fill.
///
/// The whole group can be disabled via [disabled], or individual segments via
/// [disabledIndices]. Disabled segments show the [DsThemeData.disabledOpacity]
/// visual, are non-interactive, and are skipped by keyboard navigation.
class DsToggleGroup extends StatefulWidget {
  const DsToggleGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.size,
    this.color,
    this.variant = DsToggleGroupVariant.primary,
    this.focusNode,
    this.disabled = false,
    this.disabledIndices,
  });

  /// The labels of the segments, in order.
  final List<String> items;

  /// The index of the currently selected segment.
  final int selectedIndex;

  /// Called with the new index when a segment is activated.
  ///
  /// Selection is idempotent: activating the already-selected segment (via tap,
  /// arrow keys, Home or End) does not re-fire [onChanged] — only an actual
  /// change of selection emits, matching [DsRadio] and `DsChip.radio`.
  final ValueChanged<int> onChanged;

  /// The size of the control. Falls back to the ambient [DsSizeScope].
  final DsSize? size;

  /// The color of the control. Falls back to the ambient [DsColorScope].
  final DsColor? color;

  /// The visual emphasis of the selected segment.
  final DsToggleGroupVariant variant;

  /// An optional focus node for the first segment.
  ///
  /// Attaching a node here lets a caller programmatically focus the group
  /// (focus lands on the first interactive segment).
  final FocusNode? focusNode;

  /// Whether the whole group is disabled.
  ///
  /// When `true` every segment is non-interactive and shown with the disabled
  /// visual, regardless of [disabledIndices].
  final bool disabled;

  /// The indices of individual segments that are disabled.
  ///
  /// Disabled segments are non-interactive, shown with the disabled visual, and
  /// skipped by keyboard navigation. Ignored when [disabled] is `true` (the
  /// whole group is disabled in that case).
  final Set<int>? disabledIndices;

  @override
  State<DsToggleGroup> createState() => _DsToggleGroupState();
}

class _DsToggleGroupState extends State<DsToggleGroup> {
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _buildFocusNodes(widget.items.length);
  }

  @override
  void didUpdateWidget(DsToggleGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Regenerate the focus nodes whenever the number of segments changes so
    // that indexing stays in range (avoids a RangeError when items grow) and
    // no nodes are leaked (when items shrink). Also rebuild when the externally
    // provided [focusNode] changes so the first segment adopts the new node.
    if (widget.items.length != oldWidget.items.length ||
        widget.focusNode != oldWidget.focusNode) {
      _disposeFocusNodes();
      _buildFocusNodes(widget.items.length);
    }
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    super.dispose();
  }

  void _buildFocusNodes(int count) {
    _focusNodes = List.generate(count, (i) {
      // The first segment adopts the externally provided [focusNode] (if any)
      // so callers can programmatically focus the group; the node's lifecycle
      // stays with the caller and is not disposed here.
      return i == 0 && widget.focusNode != null
          ? widget.focusNode!
          : FocusNode();
    });
  }

  void _disposeFocusNodes() {
    for (var i = 0; i < _focusNodes.length; i++) {
      // Never dispose the caller-owned focus node attached to the first segment.
      if (i == 0 && widget.focusNode != null) continue;
      _focusNodes[i].dispose();
    }
  }

  bool _isIndexDisabled(int index) =>
      widget.disabled || (widget.disabledIndices?.contains(index) ?? false);

  /// Returns the next interactive index in [direction] (+1/-1), wrapping and
  /// skipping disabled segments. Returns `null` if no interactive segment
  /// exists (e.g. the whole group is disabled).
  int? _nextInteractive(int from, int direction) {
    final count = widget.items.length;
    if (count == 0) return null;
    for (var step = 1; step <= count; step++) {
      final candidate = (from + direction * step) % count;
      final normalized = candidate < 0 ? candidate + count : candidate;
      if (!_isIndexDisabled(normalized)) return normalized;
    }
    return null;
  }

  /// Returns the first interactive index scanning forward (for Home) or
  /// backward (for End). Returns `null` when none are interactive.
  int? _edgeInteractive({required bool last}) {
    final count = widget.items.length;
    for (var i = 0; i < count; i++) {
      final index = last ? count - 1 - i : i;
      if (!_isIndexDisabled(index)) return index;
    }
    return null;
  }

  void _moveTo(int? next) {
    if (next == null) return;
    // Always move focus (so arrow/Home/End reposition the roving focus), but
    // only emit onChanged when the selection actually changes — selection is
    // idempotent, matching DsRadio and DsChip.radio.
    _focusNodes[next].requestFocus();
    if (next != widget.selectedIndex) widget.onChanged(next);
  }

  KeyEventResult _handleKey(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _moveTo(_nextInteractive(index, 1));
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _moveTo(_nextInteractive(index, -1));
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      _moveTo(_edgeInteractive(last: false));
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      _moveTo(_edgeInteractive(last: true));
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);
    final height = sizeMode.pick(sm: 32.0, md: 40.0, lg: 48.0);
    final fontSize = sizeMode.pick(sm: 13.0, md: 14.0, lg: 16.0);
    final selectedFill = switch (widget.variant) {
      DsToggleGroupVariant.primary => colorScale.baseDefault,
      DsToggleGroupVariant.secondary => colorScale.surfaceActive,
    };
    final selectedHoverFill = switch (widget.variant) {
      DsToggleGroupVariant.primary => colorScale.baseHover,
      DsToggleGroupVariant.secondary => colorScale.surfaceActive,
    };
    final selectedText = switch (widget.variant) {
      DsToggleGroupVariant.primary => colorScale.baseContrastDefault,
      DsToggleGroupVariant.secondary => colorScale.textDefault,
    };

    final count = widget.items.length;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScale.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final segmentRadius = i == 0
              ? BorderRadius.horizontal(
                  left: Radius.circular(theme.borderRadius.defaultRadius - 1),
                )
              : i == count - 1
              ? BorderRadius.horizontal(
                  right: Radius.circular(theme.borderRadius.defaultRadius - 1),
                )
              : BorderRadius.zero;
          return _DsToggleSegment(
            // Key the segment to its index so the per-segment state (and its
            // focus listener) stays stable across rebuilds.
            key: ValueKey(i),
            focusNode: _focusNodes[i],
            label: widget.items[i],
            selected: i == widget.selectedIndex,
            disabled: _isIndexDisabled(i),
            radius: segmentRadius,
            colorScale: colorScale,
            fontFamily: theme.typography.fontFamily,
            fontSize: fontSize,
            height: height,
            duration: duration,
            disabledOpacity: theme.disabledOpacity,
            selectedFill: selectedFill,
            selectedHoverFill: selectedHoverFill,
            selectedText: selectedText,
            onTap: () {
              // Request focus so subsequent arrow-key navigation works even
              // when the segment was activated by mouse/touch.
              _focusNodes[i].requestFocus();
              // Selection is idempotent: tapping the already-selected segment
              // does not re-fire onChanged (matching DsRadio/DsChip.radio).
              if (i != widget.selectedIndex) widget.onChanged(i);
            },
            onKey: (event) => _handleKey(event, i),
          );
        }),
      ),
    );
  }
}

/// A single segment of a [DsToggleGroup].
///
/// This is a private [StatefulWidget] so that only the focused/hovered segment
/// rebuilds when its own [FocusNode] or hover state changes, instead of
/// rebuilding (and reallocating) the entire group on every focus change.
class _DsToggleSegment extends StatefulWidget {
  const _DsToggleSegment({
    super.key,
    required this.focusNode,
    required this.label,
    required this.selected,
    required this.disabled,
    required this.radius,
    required this.colorScale,
    required this.fontFamily,
    required this.fontSize,
    required this.height,
    required this.duration,
    required this.disabledOpacity,
    required this.selectedFill,
    required this.selectedHoverFill,
    required this.selectedText,
    required this.onTap,
    required this.onKey,
  });

  final FocusNode focusNode;
  final String label;
  final bool selected;
  final bool disabled;
  final BorderRadius radius;
  final DsColorScale colorScale;
  final String fontFamily;
  final double fontSize;
  final double height;
  final Duration duration;
  final double disabledOpacity;
  final Color selectedFill;
  final Color selectedHoverFill;
  final Color selectedText;
  final VoidCallback onTap;
  final KeyEventResult Function(KeyEvent event) onKey;

  @override
  State<_DsToggleSegment> createState() => _DsToggleSegmentState();
}

class _DsToggleSegmentState extends State<_DsToggleSegment> {
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
    _isFocused = widget.focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(_DsToggleSegment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChange);
      widget.focusNode.addListener(_handleFocusChange);
      _isFocused = widget.focusNode.hasFocus;
    }
    // A segment that becomes disabled must not retain focus styling.
    if (widget.disabled && _isHovered) _isHovered = false;
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    final focused = widget.focusNode.hasFocus;
    if (mounted && focused != _isFocused) {
      setState(() => _isFocused = focused);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.colorScale;
    final isInteractive = !widget.disabled;

    final Color? fill;
    if (widget.selected) {
      fill = _isHovered && isInteractive
          ? widget.selectedHoverFill
          : widget.selectedFill;
    } else if (_isHovered && isInteractive) {
      // Subtle hover for unselected segments, matching the official system.
      fill = scale.surfaceHover;
    } else {
      fill = null;
    }

    Widget segment = AnimatedContainer(
      duration: widget.duration,
      curve: DsAnimation.defaultCurve,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: fill, borderRadius: widget.radius),
      alignment: Alignment.center,
      child: Text(
        widget.label,
        style: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          fontWeight: widget.selected ? FontWeight.w500 : FontWeight.w400,
          color: widget.selected ? widget.selectedText : scale.textDefault,
        ),
      ),
    );

    // Always reserve focus ring space (transparent when not focused) so the
    // ring never overlaps the segment fill, text, or the outer group border.
    segment = DsFocus.reserveRing(
      focused: _isFocused && isInteractive,
      radius: widget.radius,
      scale: scale,
      child: segment,
    );

    if (widget.disabled) {
      segment = Opacity(opacity: widget.disabledOpacity, child: segment);
    }

    return Semantics(
      button: true,
      // A selected button-role segment is a toggled (pressed) button —
      // mirroring the official ToggleGroup ARIA pattern (<button aria-pressed>,
      // which maps to Flutter's SemanticsFlag.isToggled) and the DsChip
      // convention. Exposing `selected` here would contradict the button role.
      toggled: widget.selected,
      enabled: isInteractive,
      child: Focus(
        focusNode: widget.focusNode,
        canRequestFocus: isInteractive,
        skipTraversal: !isInteractive,
        onKeyEvent: (node, event) => widget.onKey(event),
        child: MouseRegion(
          cursor: isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: isInteractive ? (_) => _setHovered(true) : null,
          onExit: isInteractive ? (_) => _setHovered(false) : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isInteractive ? widget.onTap : null,
            child: segment,
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    if (_isHovered != value) setState(() => _isHovered = value);
  }
}
