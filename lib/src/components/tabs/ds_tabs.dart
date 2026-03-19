import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';

class DsTabs extends StatefulWidget {
  const DsTabs({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onChanged,
    this.size,
    this.color,
  });

  final List<String> tabs;
  final List<Widget> children;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final DsSize? size;
  final DsColor? color;

  @override
  State<DsTabs> createState() => _DsTabsState();
}

class _DsTabsState extends State<DsTabs> {
  late int _selectedIndex;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _focusNodes = List.generate(widget.tabs.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
    widget.onChanged?.call(index);
  }

  void _handleKeyEvent(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return;
    final count = widget.tabs.length;
    int? nextIndex;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      nextIndex = (index + 1) % count;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      nextIndex = (index - 1 + count) % count;
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      nextIndex = 0;
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      nextIndex = count - 1;
    }

    if (nextIndex != null) {
      _selectTab(nextIndex);
      _focusNodes[nextIndex].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);

    final tabHeight = switch (sizeMode) {
      DsSize.sm => 36.0,
      DsSize.md => 44.0,
      DsSize.lg => 52.0,
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 14.0,
      DsSize.md => 16.0,
      DsSize.lg => 18.0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScale.borderSubtle, width: 1),
            ),
          ),
          child: Row(
            children: List.generate(widget.tabs.length, (i) {
              final isSelected = i == _selectedIndex;
              return Semantics(
                selected: isSelected,
                child: KeyboardListener(
                  focusNode: _focusNodes[i],
                  onKeyEvent: (event) => _handleKeyEvent(event, i),
                  child: GestureDetector(
                    onTap: () => _selectTab(i),
                    child: AnimatedContainer(
                      duration: duration,
                      height: tabHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? colorScale.baseDefault
                                : const Color(0x00000000),
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.tabs[i],
                        style: TextStyle(
                          fontFamily: theme.typography.fontFamily,
                          fontSize: fontSize,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isSelected
                              ? colorScale.textDefault
                              : colorScale.textSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Panel
        if (_selectedIndex < widget.children.length)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: widget.children[_selectedIndex],
          ),
      ],
    );
  }
}
