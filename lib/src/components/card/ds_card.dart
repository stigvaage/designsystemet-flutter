import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A container card with a border or elevation shadow.
///
/// When [onTap] is provided the card becomes interactive with hover
/// highlighting, focus ring, and keyboard activation.
class DsCard extends StatefulWidget {
  const DsCard({
    super.key,
    required this.child,
    this.color,
    this.elevated = false,
    this.onTap,
    this.focusNode,
    this.variant = DsCardVariant.default_,
  });

  /// Innholdet som vises inne i kortet.
  final Widget child;

  /// Fargetemaet som brukes på kortet.
  ///
  /// Faller tilbake til omkringliggende [DsColorScope] når den er `null`.
  final DsColor? color;

  /// Om kortet bruker en skygge i stedet for en ramme.
  final bool elevated;

  /// Kalles når kortet trykkes eller aktiveres via tastatur.
  ///
  /// Når denne er satt blir kortet interaktivt med hover-, trykk- og
  /// fokustilstand.
  final VoidCallback? onTap;

  /// Valgfri fokusnode for det interaktive kortet.
  final FocusNode? focusNode;

  /// The visual fill variant of the card.
  ///
  /// [DsCardVariant.default_] uses the default surface fill, while
  /// [DsCardVariant.tinted] uses a tinted surface fill.
  final DsCardVariant variant;

  @override
  State<DsCard> createState() => _DsCardState();
}

class _DsCardState extends State<DsCard> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);
    final isClickable = widget.onTap != null;

    Color bgColor = switch (widget.variant) {
      DsCardVariant.default_ => colorScale.surfaceDefault,
      DsCardVariant.tinted => colorScale.surfaceTinted,
    };
    if (isClickable && _isPressed) {
      bgColor = colorScale.surfaceActive;
    } else if (isClickable && _isHovered) {
      bgColor = colorScale.surfaceHover;
    }

    final decoration = BoxDecoration(
      color: bgColor,
      borderRadius: radius,
      border: widget.elevated
          ? null
          : Border.all(color: colorScale.borderSubtle, width: 1),
      boxShadow: widget.elevated ? theme.shadows.sm : null,
    );

    // A non-interactive card can never change its hover/focus state, so there
    // is no reason to run an [AnimatedContainer] ticker. Render a plain
    // [DecoratedBox] instead to avoid the needless animation and focus chrome.
    if (!isClickable) {
      return DecoratedBox(decoration: decoration, child: widget.child);
    }

    Widget card = AnimatedContainer(
      duration: duration,
      curve: DsAnimation.defaultCurve,
      decoration: decoration,
      child: widget.child,
    );

    // Always reserve focus ring space so focusing never shifts layout.
    card = DsFocus.reserveRing(
      focused: _isFocused,
      radius: radius,
      scale: colorScale,
      child: card,
    );

    return Semantics(
      button: true,
      child: Focus(
        focusNode: widget.focusNode,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onTap?.call();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() {
            _isHovered = false;
            _isPressed = false;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) {
              setState(() => _isPressed = false);
              widget.onTap?.call();
            },
            onTapCancel: () => setState(() => _isPressed = false),
            child: card,
          ),
        ),
      ),
    );
  }
}
