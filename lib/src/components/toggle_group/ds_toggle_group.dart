import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';

class DsToggleGroup extends StatefulWidget {
  const DsToggleGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.size,
    this.color,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final DsSize? size;
  final DsColor? color;

  @override
  State<DsToggleGroup> createState() => _DsToggleGroupState();
}

class _DsToggleGroupState extends State<DsToggleGroup> {
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.items.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
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

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScale.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.items.length, (i) {
          final isSelected = i == widget.selectedIndex;
          return Semantics(
            selected: isSelected,
            child: KeyboardListener(
              focusNode: _focusNodes[i],
              onKeyEvent: (e) => _handleKey(e, i),
              child: GestureDetector(
                onTap: () => widget.onChanged(i),
                child: AnimatedContainer(
                  duration: duration,
                  height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? colorScale.baseDefault : null,
                    borderRadius: i == 0
                        ? BorderRadius.horizontal(
                            left: Radius.circular(
                              theme.borderRadius.defaultRadius - 1,
                            ),
                          )
                        : i == widget.items.length - 1
                        ? BorderRadius.horizontal(
                            right: Radius.circular(
                              theme.borderRadius.defaultRadius - 1,
                            ),
                          )
                        : null,
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
                          ? colorScale.baseContrastDefault
                          : colorScale.textDefault,
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
