import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsDropdown extends StatefulWidget {
  const DsDropdown({
    super.key,
    required this.trigger,
    required this.items,
    this.onSelected,
    this.color,
  });

  final Widget trigger;
  final List<DsDropdownItem> items;
  final ValueChanged<int>? onSelected;
  final DsColor? color;

  @override
  State<DsDropdown> createState() => _DsDropdownState();
}

class DsDropdownItem {
  final String label;
  final bool enabled;
  const DsDropdownItem({required this.label, this.enabled = true});
}

class _DsDropdownState extends State<DsDropdown> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  bool _isOpen = false;

  void _toggle() {
    _isOpen ? _close() : _open();
  }

  void _open() {
    if (_isOpen) return;
    _isOpen = true;
    _entry = OverlayEntry(builder: _buildMenu);
    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    if (!_isOpen) return;
    _isOpen = false;
    _entry?.remove();
    _entry = null;
  }

  void _select(int index) {
    widget.onSelected?.call(index);
    _close();
  }

  Widget _buildMenu(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _close,
      child: Stack(
        children: [
          CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 4),
            child: Container(
              constraints: const BoxConstraints(minWidth: 160),
              decoration: BoxDecoration(
                color: colorScale.backgroundDefault,
                borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
                border: Border.all(color: colorScale.borderSubtle, width: 1),
                boxShadow: theme.shadows.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    GestureDetector(
                      onTap: widget.items[i].enabled ? () => _select(i) : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          widget.items[i].label,
                          style: theme.typography.bodySm.copyWith(
                            color: widget.items[i].enabled
                                ? colorScale.textDefault
                                : colorScale.textSubtle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggle,
        child: widget.trigger,
      ),
    );
  }
}
