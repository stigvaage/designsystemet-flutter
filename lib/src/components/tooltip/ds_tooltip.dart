import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_overlay_anchors.dart';

/// A tooltip that appears next to its [child] on hover **or keyboard focus**.
///
/// Mirrors the React Tooltip: [placement] (default [DsPlacement.top]) and
/// [autoPlacement] (default `true`). The [message] is also exposed to assistive
/// technology via [Semantics.tooltip].
class DsTooltip extends StatefulWidget {
  const DsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.color,
    this.placement = DsPlacement.top,
    this.autoPlacement = true,
  });

  final String message;
  final Widget child;
  final DsColor? color;

  /// Side of the child the tooltip is anchored to. Defaults to
  /// [DsPlacement.top].
  final DsPlacement placement;

  /// When true (default), flips to the opposite side if the preferred
  /// [placement] lacks room in the viewport.
  final bool autoPlacement;

  @override
  State<DsTooltip> createState() => _DsTooltipState();
}

class _DsTooltipState extends State<DsTooltip> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  DsThemeData? _capturedTheme;
  DsColor? _capturedColor;
  DsPlacement _resolvedPlacement = DsPlacement.top;

  void _show() {
    if (_entry != null) return;
    _capturedTheme = DsTheme.of(context);
    _capturedColor = DsColorScope.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final rect = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    _resolvedPlacement = dsResolvePlacement(
      placement: widget.placement,
      autoPlacement: widget.autoPlacement,
      anchorRect: rect,
      screen: MediaQuery.maybeOf(context)?.size,
    );
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = _capturedTheme!;
    final activeColor = widget.color ?? _capturedColor!;
    final colorScale = theme.colorScheme.resolve(activeColor);
    final (targetAnchor, followerAnchor, offset) = dsPlacementAnchors(
      _resolvedPlacement,
      gap: 8,
    );

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: activeColor,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              offset: offset,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
          ],
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
      child: Semantics(
        tooltip: widget.message,
        child: Focus(
          // Show on keyboard focus too (the trigger child supplies the focus
          // node). canRequestFocus:false avoids adding an extra tab stop.
          canRequestFocus: false,
          onFocusChange: (hasFocus) => hasFocus ? _show() : _hide(),
          child: MouseRegion(
            onEnter: (_) => _show(),
            onExit: (_) => _hide(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
