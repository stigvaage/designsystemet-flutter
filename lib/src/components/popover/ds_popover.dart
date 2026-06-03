import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';

/// An overlay popover anchored to a [trigger] widget.
///
/// Supports the 12 [DsPlacement]s, optional [autoPlacement] flipping when the
/// preferred side lacks room, a tinted [variant], and controlled visibility via
/// [open]/[onOpen]/[onClose]. Closes on an outside tap or the Escape key.
///
/// Mirrors the React Popover (`placement` default `top`, `autoPlacement` default
/// `true`). The `Popover.Trigger`/`Popover.TriggerContext` compound parts are
/// covered functionally by the [trigger] slot.
class DsPopover extends StatefulWidget {
  const DsPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.color,
    this.placement = DsPlacement.top,
    this.variant = DsPopoverVariant.default_,
    this.autoPlacement = true,
    this.open,
    this.onOpen,
    this.onClose,
  });

  final Widget trigger;
  final Widget content;
  final DsColor? color;

  /// Side of the trigger the popover is anchored to. Defaults to
  /// [DsPlacement.top] (matches the React Popover default).
  final DsPlacement placement;

  /// Visual variant. [DsPopoverVariant.tinted] uses the tinted surface fill.
  final DsPopoverVariant variant;

  /// When true (default), the popover flips to the opposite side if the
  /// preferred [placement] lacks room in the viewport.
  final bool autoPlacement;

  /// Controlled visibility. When non-null the parent owns the open state and
  /// must update it in response to [onOpen]/[onClose]; when null the popover
  /// manages its own (uncontrolled) state.
  final bool? open;

  /// Called when the popover wants to open (trigger tapped while closed).
  final VoidCallback? onOpen;

  /// Called when the popover wants to close (outside tap, Escape, or trigger
  /// tapped while open).
  final VoidCallback? onClose;

  @override
  State<DsPopover> createState() => _DsPopoverState();
}

class _DsPopoverState extends State<DsPopover> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  bool _internalOpen = false;
  DsThemeData? _capturedTheme;
  DsColor? _capturedColor;
  DsPlacement _resolvedPlacement = DsPlacement.top;

  bool get _controlled => widget.open != null;
  bool get _isOpen => _controlled ? widget.open! : _internalOpen;

  @override
  void initState() {
    super.initState();
    _resolvedPlacement = widget.placement;
    if (_controlled && widget.open!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _show();
      });
    }
  }

  @override
  void didUpdateWidget(DsPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controlled) {
      if (widget.open! && _entry == null) {
        _show();
      } else if (!widget.open! && _entry != null) {
        _hide();
      }
    }
  }

  void _requestToggle() => _isOpen ? _requestClose() : _requestOpen();

  void _requestOpen() {
    widget.onOpen?.call();
    if (_controlled) return; // parent flips `open` → didUpdateWidget shows
    setState(() => _internalOpen = true);
    _show();
  }

  void _requestClose() {
    widget.onClose?.call();
    if (_controlled) return;
    setState(() => _internalOpen = false);
    _hide();
  }

  void _show() {
    if (_entry != null) return;
    _capturedTheme = DsTheme.of(context);
    _capturedColor = DsColorScope.of(context);
    _resolvedPlacement = _resolvePlacement();
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  bool _isVertical(DsPlacement p) =>
      p.name.startsWith('top') || p.name.startsWith('bottom');
  bool _isTopSide(DsPlacement p) => p.name.startsWith('top');
  bool _isLeftSide(DsPlacement p) => p.name.startsWith('left');

  DsPlacement _flipVertical(DsPlacement p) => switch (p) {
    DsPlacement.top => DsPlacement.bottom,
    DsPlacement.topStart => DsPlacement.bottomStart,
    DsPlacement.topEnd => DsPlacement.bottomEnd,
    DsPlacement.bottom => DsPlacement.top,
    DsPlacement.bottomStart => DsPlacement.topStart,
    DsPlacement.bottomEnd => DsPlacement.topEnd,
    _ => p,
  };

  DsPlacement _flipHorizontal(DsPlacement p) => switch (p) {
    DsPlacement.left => DsPlacement.right,
    DsPlacement.leftStart => DsPlacement.rightStart,
    DsPlacement.leftEnd => DsPlacement.rightEnd,
    DsPlacement.right => DsPlacement.left,
    DsPlacement.rightStart => DsPlacement.leftStart,
    DsPlacement.rightEnd => DsPlacement.leftEnd,
    _ => p,
  };

  /// Flips [DsPopover.placement] to the opposite side when that side has more
  /// room in the viewport (main axis only). No-op when [autoPlacement] is off
  /// or measurements are unavailable.
  DsPlacement _resolvePlacement() {
    if (!widget.autoPlacement) return widget.placement;
    final box = context.findRenderObject() as RenderBox?;
    final media = MediaQuery.maybeOf(context);
    if (box == null || !box.hasSize || media == null) return widget.placement;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screen = media.size;
    final p = widget.placement;
    if (_isVertical(p)) {
      final above = pos.dy;
      final below = screen.height - (pos.dy + size.height);
      if (_isTopSide(p) ? below > above : above > below) {
        return _flipVertical(p);
      }
      return p;
    }
    final left = pos.dx;
    final right = screen.width - (pos.dx + size.width);
    if (_isLeftSide(p) ? right > left : left > right) return _flipHorizontal(p);
    return p;
  }

  /// (targetAnchor, followerAnchor, offset) for the resolved [placement].
  (Alignment, Alignment, Offset) _anchorsFor(DsPlacement p) {
    const g = 4.0;
    return switch (p) {
      DsPlacement.top => (
        Alignment.topCenter,
        Alignment.bottomCenter,
        const Offset(0, -g),
      ),
      DsPlacement.topStart => (
        Alignment.topLeft,
        Alignment.bottomLeft,
        const Offset(0, -g),
      ),
      DsPlacement.topEnd => (
        Alignment.topRight,
        Alignment.bottomRight,
        const Offset(0, -g),
      ),
      DsPlacement.bottom => (
        Alignment.bottomCenter,
        Alignment.topCenter,
        const Offset(0, g),
      ),
      DsPlacement.bottomStart => (
        Alignment.bottomLeft,
        Alignment.topLeft,
        const Offset(0, g),
      ),
      DsPlacement.bottomEnd => (
        Alignment.bottomRight,
        Alignment.topRight,
        const Offset(0, g),
      ),
      DsPlacement.left => (
        Alignment.centerLeft,
        Alignment.centerRight,
        const Offset(-g, 0),
      ),
      DsPlacement.leftStart => (
        Alignment.topLeft,
        Alignment.topRight,
        const Offset(-g, 0),
      ),
      DsPlacement.leftEnd => (
        Alignment.bottomLeft,
        Alignment.bottomRight,
        const Offset(-g, 0),
      ),
      DsPlacement.right => (
        Alignment.centerRight,
        Alignment.centerLeft,
        const Offset(g, 0),
      ),
      DsPlacement.rightStart => (
        Alignment.topRight,
        Alignment.topLeft,
        const Offset(g, 0),
      ),
      DsPlacement.rightEnd => (
        Alignment.bottomRight,
        Alignment.bottomLeft,
        const Offset(g, 0),
      ),
    };
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = _capturedTheme!;
    final activeColor = widget.color ?? _capturedColor!;
    final colorScale = theme.colorScheme.resolve(activeColor);
    final (targetAnchor, followerAnchor, offset) = _anchorsFor(
      _resolvedPlacement,
    );
    final fill = widget.variant == DsPopoverVariant.tinted
        ? colorScale.surfaceTinted
        : colorScale.backgroundDefault;

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: activeColor,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _requestClose,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: targetAnchor,
                followerAnchor: followerAnchor,
                offset: offset,
                child: GestureDetector(
                  onTap: () {}, // Absorb taps on the popover content.
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(
                        theme.borderRadius.defaultRadius,
                      ),
                      border: Border.all(
                        color: colorScale.borderSubtle,
                        width: 1,
                      ),
                      boxShadow: theme.shadows.md,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: widget.content,
                  ),
                ),
              ),
            ],
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
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape &&
            _isOpen) {
          _requestClose();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Semantics(
          button: true,
          expanded: _isOpen,
          child: GestureDetector(onTap: _requestToggle, child: widget.trigger),
        ),
      ),
    );
  }
}
