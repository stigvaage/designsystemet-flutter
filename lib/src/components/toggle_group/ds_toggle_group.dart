import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A segmented toggle control where one item is selected at a time.
///
/// Supports arrow-key navigation between segments.
///
/// The [variant] controls the emphasis of the selected segment:
/// [DsToggleGroupVariant.primary] fills it with the base color, while
/// [DsToggleGroupVariant.secondary] uses a lower-emphasis surface fill.
class DsToggleGroup extends StatefulWidget {
  const DsToggleGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.size,
    this.color,
    this.variant = DsToggleGroupVariant.primary,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final DsSize? size;
  final DsColor? color;

  /// The visual emphasis of the selected segment.
  final DsToggleGroupVariant variant;

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
    // no nodes are leaked (when items shrink).
    if (widget.items.length != oldWidget.items.length) {
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
    _focusNodes = List.generate(count, (_) {
      final node = FocusNode();
      // Repaint so the focus ring follows the currently focused segment.
      node.addListener(_handleFocusChange);
      return node;
    });
  }

  void _disposeFocusNodes() {
    for (final node in _focusNodes) {
      node.removeListener(_handleFocusChange);
      node.dispose();
    }
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  void _handleKey(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return;
    final count = widget.items.length;
    int? next;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      next = (index + 1) % count;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      next = (index - 1 + count) % count;
    }
    if (next != null) {
      widget.onChanged(next);
      _focusNodes[next].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);
    final height = switch (sizeMode) {
      DsSize.sm => 32.0,
      DsSize.md => 40.0,
      DsSize.lg => 48.0,
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 13.0,
      DsSize.md => 14.0,
      DsSize.lg => 16.0,
    };
    final selectedFill = switch (widget.variant) {
      DsToggleGroupVariant.primary => colorScale.baseDefault,
      DsToggleGroupVariant.secondary => colorScale.surfaceActive,
    };
    final selectedText = switch (widget.variant) {
      DsToggleGroupVariant.primary => colorScale.baseContrastDefault,
      DsToggleGroupVariant.secondary => colorScale.textDefault,
    };

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScale.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.items.length, (i) {
          final isSelected = i == widget.selectedIndex;
          final isFocused = _focusNodes[i].hasFocus;
          final segmentRadius = i == 0
              ? BorderRadius.horizontal(
                  left: Radius.circular(theme.borderRadius.defaultRadius - 1),
                )
              : i == widget.items.length - 1
              ? BorderRadius.horizontal(
                  right: Radius.circular(theme.borderRadius.defaultRadius - 1),
                )
              : BorderRadius.zero;
          return Semantics(
            button: true,
            selected: isSelected,
            child: KeyboardListener(
              focusNode: _focusNodes[i],
              onKeyEvent: (e) => _handleKey(e, i),
              child: GestureDetector(
                onTap: () {
                  // Request focus so subsequent arrow-key navigation works
                  // even when the segment was activated by mouse/touch.
                  _focusNodes[i].requestFocus();
                  widget.onChanged(i);
                },
                child: DecoratedBox(
                  // Always reserve focus ring space (transparent when not
                  // focused) so the 3px ring never overlaps the segment fill,
                  // text, or the outer group border. Matches the pattern used
                  // by DsChip/DsCheckbox/DsButton.
                  decoration: isFocused
                      ? DsFocus.focusRingWithRadius(colorScale, segmentRadius)
                      : BoxDecoration(
                          borderRadius: segmentRadius,
                          border: Border.all(
                            color: const Color(0x00000000),
                            width: DsFocus.ringWidth,
                          ),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.all(DsFocus.ringWidth),
                    child: AnimatedContainer(
                      duration: duration,
                      height: height,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedFill : null,
                        borderRadius: segmentRadius,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.items[i],
                        style: TextStyle(
                          fontFamily: theme.typography.fontFamily,
                          fontSize: fontSize,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isSelected
                              ? selectedText
                              : colorScale.textDefault,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
