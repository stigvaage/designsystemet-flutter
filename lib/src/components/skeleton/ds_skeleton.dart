import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';

class DsSkeleton extends StatefulWidget {
  const DsSkeleton({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius,
    this.color,
  });

  final double? width;
  final double height;
  final double? borderRadius;
  final DsColor? color;

  @override
  State<DsSkeleton> createState() => _DsSkeletonState();
}

class _DsSkeletonState extends State<DsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!DsAnimation.shouldAnimate(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final radius = widget.borderRadius ?? theme.borderRadius.sm;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.3 + 0.3 * (0.5 + 0.5 * (_controller.value * 3.14159 * 2).sin());
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colorScale.surfaceDefault.withValues(alpha: opacity.clamp(0.0, 1.0)),
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      },
    );
  }
}

extension on double {
  double sin() {
    // Simple sine approximation for shimmer
    final x = this % (3.14159 * 2);
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }
}
