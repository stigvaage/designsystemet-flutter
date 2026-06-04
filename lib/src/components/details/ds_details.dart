import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';

/// An expandable disclosure widget that toggles between a summary and
/// its child content with a size transition animation.
class DsDetails extends StatefulWidget {
  const DsDetails({
    super.key,
    required this.summary,
    required this.child,
    this.initiallyExpanded = false,
    this.color,
    this.variant = DsDetailsVariant.default_,
  });

  final Widget summary;
  final Widget child;
  final bool initiallyExpanded;
  final DsColor? color;

  /// The visual variant of the details widget.
  ///
  /// [DsDetailsVariant.default_] renders only a border with a transparent
  /// fill, while [DsDetailsVariant.tinted] fills the container with the
  /// tinted surface color.
  final DsDetailsVariant variant;

  @override
  State<DsDetails> createState() => _DsDetailsState();
}

class _DsDetailsState extends State<DsDetails>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final AnimationController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: DsAnimation.normal,
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = DsAnimation.resolveDuration(
      context,
      DsAnimation.normal,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);

    final summaryRow = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            _isExpanded ? DsIcons.chevronDown : DsIcons.chevronRight,
            size: 16,
            color: colorScale.textDefault,
          ),
          const SizedBox(width: 8),
          Expanded(child: widget.summary),
        ],
      ),
    );

    // Always reserve focus ring space to prevent layout shift, and only paint
    // the visible ring while the summary holds keyboard focus.
    final focusDecoration = _isFocused
        ? DsFocus.focusRingWithRadius(colorScale, radius)
        : BoxDecoration(
            borderRadius: BorderRadius.circular(
              radius.topLeft.x + DsFocus.ringWidth,
            ),
            border: Border.all(
              color: const Color(0x00000000),
              width: DsFocus.ringWidth,
            ),
          );

    final summary = Semantics(
      button: true,
      onTap: _toggle,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            _toggle();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: GestureDetector(
          // Opaque so a tap anywhere across the full-width summary row
          // (including the 12px padding) toggles the disclosure.
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: DecoratedBox(
            decoration: focusDecoration,
            child: Padding(
              padding: const EdgeInsets.all(DsFocus.ringWidth),
              child: summaryRow,
            ),
          ),
        ),
      ),
    );

    return Semantics(
      expanded: _isExpanded,
      child: Container(
        decoration: BoxDecoration(
          color: switch (widget.variant) {
            DsDetailsVariant.default_ => null,
            DsDetailsVariant.tinted => colorScale.surfaceTinted,
          },
          border: Border.all(color: colorScale.borderSubtle, width: 1),
          borderRadius: radius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            summary,
            SizeTransition(
              sizeFactor: _controller,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
