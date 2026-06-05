import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';

/// An animated circular loading spinner.
///
/// Paints a rotating arc using [CustomPaint] and respects the platform
/// reduce-motion setting.
class DsSpinner extends StatefulWidget {
  const DsSpinner({
    super.key,
    this.size,
    this.color,
    this.paintColor,
    this.ariaLabel = 'Laster inn',
  });

  /// The design-system [DsColor] used to resolve the color scale the spinner
  /// is drawn from (falls back to the ambient [DsColorScope]). The arc is
  /// painted with the scale's `baseDefault` unless [paintColor] is set.
  final DsColor? color;

  final DsSize? size;

  /// An explicit paint color override for the spinner arc.
  ///
  /// When provided, the arc is painted with this exact [Color] instead of the
  /// resolved scale's `baseDefault`. Pass a visible color when the scale
  /// default would be invisible against the spinner's background (for example
  /// a spinner shown on top of a filled `baseDefault` button).
  final Color? paintColor;

  /// Accessible label announced by screen readers. The React Spinner requires
  /// `aria-label`; here it defaults to `'Laster inn'` and can be overridden,
  /// e.g. `ariaLabel: 'Laster brukere …'`.
  final String ariaLabel;

  @override
  State<DsSpinner> createState() => _DsSpinnerState();
}

class _DsSpinnerState extends State<DsSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final dimension = switch (sizeMode) {
      DsSize.sm => 16.0,
      DsSize.md => 20.0,
      DsSize.lg => 24.0,
    };
    // Stroke skaleres proporsjonalt med diameteren, slik som i den offisielle
    // SVG-en (strokeWidth 5 i en viewBox på 50 → 10 % av diameteren). Dette
    // gir sm 1,6 / md 2,0 / lg 2,4 og holder strektykkelsen visuelt konstant
    // på tvers av størrelser.
    final strokeWidth = dimension * 0.1;

    return Semantics(
      label: widget.ariaLabel,
      liveRegion: true,
      child: SizedBox(
        width: dimension,
        height: dimension,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _SpinnerPainter(
                color: widget.paintColor ?? colorScale.baseDefault,
                progress: _controller.value,
                strokeWidth: strokeWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.color,
    required this.progress,
    required this.strokeWidth,
  });

  final Color color;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final startAngle = progress * 2 * math.pi - math.pi / 2;
    const sweepAngle = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
