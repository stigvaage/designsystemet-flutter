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
    this.focusNode,
  });

  final Widget summary;
  final Widget child;
  final bool initiallyExpanded;
  final DsColor? color;

  /// An optional focus node for the summary, the single primary focus target.
  ///
  /// Provide this to control or observe keyboard focus of the disclosure
  /// summary (for example to move focus programmatically or to participate in a
  /// custom focus order). When omitted, an internally managed node is used.
  final FocusNode? focusNode;

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
  bool _isHovered = false;

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
    final hoverDuration = DsAnimation.resolveDuration(
      context,
      DsAnimation.fast,
    );

    // The hover highlight is confined to the summary row only, never the
    // expanded content area, and uses the surfaceHover token.
    final summaryRow = AnimatedContainer(
      duration: hoverDuration,
      curve: DsAnimation.defaultCurve,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isHovered ? colorScale.surfaceHover : null,
        borderRadius: radius,
      ),
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

    // The button role and its expanded/collapsed state live on the SAME
    // node as the focusable trigger, and [MergeSemantics] coalesces the
    // summary's own label onto that node, so a screen reader announces
    // "<summary>, button, expanded/collapsed" when focus lands here.
    final summary = MergeSemantics(
      child: Semantics(
        button: true,
        expanded: _isExpanded,
        onTap: _toggle,
        child: Focus(
          focusNode: widget.focusNode,
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
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              // Opaque so a tap anywhere across the full-width summary row
              // (including the 12px padding) toggles the disclosure.
              behavior: HitTestBehavior.opaque,
              onTap: _toggle,
              // Always reserves focus ring space to prevent layout shift, and
              // only paints the visible ring while the summary holds focus.
              child: DsFocus.reserveRing(
                focused: _isFocused,
                radius: radius,
                scale: colorScale,
                child: summaryRow,
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
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
            // While collapsed, gate the child out of the accessibility tree
            // and focus traversal so screen readers and Tab do not reach
            // hidden content that the node reports as expanded:false. The
            // SizeTransition still drives the visual collapse animation.
            child: ExcludeSemantics(
              excluding: !_isExpanded,
              child: ExcludeFocus(
                excluding: !_isExpanded,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
