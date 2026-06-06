import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_overlay_anchors.dart';

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

  /// Focus on the trigger so the Escape key is routed to the popover even when
  /// it was opened with a pointer, and so focus can be restored on close.
  final _triggerFocusNode = FocusNode(debugLabel: 'DsPopover trigger');
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
      // Defer show/hide to a post-frame callback so we never insert into the
      // overlay or read this element's render object mid-update, when it may
      // not be laid out yet. Mirrors the deferred initState path.
      if (widget.open! && _entry == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isOpen && _entry == null) _show();
        });
      } else if (!widget.open! && _entry != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isOpen && _entry != null) _hide();
        });
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
    // Return focus to the trigger so keyboard users land back where they
    // started (WCAG 2.4.3). Applies in both controlled and uncontrolled modes.
    _triggerFocusNode.requestFocus();
    if (_controlled) return;
    setState(() => _internalOpen = false);
    _hide();
  }

  void _show() {
    if (_entry != null) return;
    // Hold focus on the trigger while the popover is open so the Escape key is
    // routed to the trigger-level handler regardless of how it was opened.
    _triggerFocusNode.requestFocus();
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
    );
    final fill = widget.variant == DsPopoverVariant.tinted
        ? colorScale.surfaceTinted
        : colorScale.backgroundDefault;

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: activeColor,
        // Handle Escape from inside the overlay too, so the popover closes even
        // when keyboard focus has moved into interactive [content]. The popover
        // is non-modal, so focus is not trapped or auto-grabbed here.
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape &&
                _isOpen) {
              _requestClose();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
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
      ),
    );
  }

  @override
  void dispose() {
    _hide();
    _triggerFocusNode.dispose();
    super.dispose();
  }

  void _handleTriggerTap() {
    // Move focus to the trigger so a pointer-opened popover still routes the
    // Escape key to the trigger-level handler.
    _triggerFocusNode.requestFocus();
    _requestToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _triggerFocusNode,
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
          child: GestureDetector(
            onTap: _handleTriggerTap,
            child: widget.trigger,
          ),
        ),
      ),
    );
  }
}
