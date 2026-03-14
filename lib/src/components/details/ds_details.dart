import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';

class DsDetails extends StatefulWidget {
  const DsDetails({
    super.key,
    required this.summary,
    required this.child,
    this.initiallyExpanded = false,
    this.color,
  });

  final Widget summary;
  final Widget child;
  final bool initiallyExpanded;
  final DsColor? color;

  @override
  State<DsDetails> createState() => _DsDetailsState();
}

class _DsDetailsState extends State<DsDetails>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final AnimationController _controller;

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
    _controller.duration =
        DsAnimation.resolveDuration(context, DsAnimation.normal);
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

    return Semantics(
      expanded: _isExpanded,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScale.borderSubtle, width: 1),
          borderRadius:
              BorderRadius.circular(theme.borderRadius.defaultRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _toggle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      _isExpanded ? '▾' : '▸',
                      style: TextStyle(color: colorScale.textDefault),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: widget.summary),
                  ],
                ),
              ),
            ),
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
