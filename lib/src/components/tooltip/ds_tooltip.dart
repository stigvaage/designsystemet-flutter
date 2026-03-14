import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsTooltip extends StatefulWidget {
  const DsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.color,
  });

  final String message;
  final Widget child;
  final DsColor? color;

  @override
  State<DsTooltip> createState() => _DsTooltipState();
}

class _DsTooltipState extends State<DsTooltip> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  bool _isVisible = false;

  void _show() {
    if (_isVisible) return;
    _isVisible = true;
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
  }

  void _hide() {
    if (!_isVisible) return;
    _isVisible = false;
    _entry?.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Positioned(
      child: CompositedTransformFollower(
        link: _layerLink,
        targetAnchor: Alignment.topCenter,
        followerAnchor: Alignment.bottomCenter,
        offset: const Offset(0, -8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScale.baseDefault,
            borderRadius: BorderRadius.circular(theme.borderRadius.sm),
            boxShadow: theme.shadows.sm,
          ),
          child: Text(
            widget.message,
            style: theme.typography.bodyXs.copyWith(
              color: colorScale.baseContrastDefault,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _show(),
        onExit: (_) => _hide(),
        child: widget.child,
      ),
    );
  }
}
