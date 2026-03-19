import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

class DsCard extends StatefulWidget {
  const DsCard({
    super.key,
    required this.child,
    this.color,
    this.elevated = false,
    this.onTap,
    this.focusNode,
  });

  final Widget child;
  final DsColor? color;
  final bool elevated;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  @override
  State<DsCard> createState() => _DsCardState();
}

class _DsCardState extends State<DsCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);
    final isClickable = widget.onTap != null;

    Color bgColor = colorScale.surfaceDefault;
    if (isClickable && _isHovered) {
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

    Widget card = AnimatedContainer(
      duration: duration,
      decoration: decoration,
      child: widget.child,
    );

    if (_isFocused && isClickable) {
      card = DecoratedBox(
        decoration: DsFocus.focusRingWithRadius(colorScale, radius),
        child: Padding(
          padding: const EdgeInsets.all(DsFocus.ringWidth),
          child: card,
        ),
      );
    }

    if (!isClickable) return card;

    return Semantics(
      button: true,
      child: Focus(
        focusNode: widget.focusNode,
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: card,
          ),
        ),
      ),
    );
  }
}
