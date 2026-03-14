import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsPopover extends StatefulWidget {
  const DsPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.color,
  });

  final Widget trigger;
  final Widget content;
  final DsColor? color;

  @override
  State<DsPopover> createState() => _DsPopoverState();
}

class _DsPopoverState extends State<DsPopover> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  bool _isOpen = false;

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (_isOpen) return;
    _isOpen = true;
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    if (!_isOpen) return;
    _isOpen = false;
    _entry?.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext context) {
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
            child: GestureDetector(
              onTap: () {}, // Absorb taps on popover content
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: colorScale.backgroundDefault,
                  borderRadius:
                      BorderRadius.circular(theme.borderRadius.defaultRadius),
                  border:
                      Border.all(color: colorScale.borderSubtle, width: 1),
                  boxShadow: theme.shadows.md,
                ),
                padding: const EdgeInsets.all(16),
                child: widget.content,
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
