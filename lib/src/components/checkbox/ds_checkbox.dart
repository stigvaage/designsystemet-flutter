import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

class DsCheckbox extends StatefulWidget {
  const DsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.size,
    this.color,
    this.error,
    this.indeterminate = false,
    this.readOnly = false,
    this.focusNode,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final DsSize? size;
  final DsColor? color;
  final String? error;
  final bool indeterminate;
  final bool readOnly;
  final FocusNode? focusNode;

  @override
  State<DsCheckbox> createState() => _DsCheckboxState();
}

class _DsCheckboxState extends State<DsCheckbox> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final boxSize = switch (sizeMode) {
      DsSize.sm => 18.0,
      DsSize.md => 22.0,
      DsSize.lg => 26.0,
    };

    final isChecked = widget.value || widget.indeterminate;
    final bgColor = isChecked
        ? colorScale.baseDefault
        : colorScale.backgroundDefault;
    final borderColor = isChecked
        ? colorScale.baseDefault
        : (_isHovered ? colorScale.borderStrong : colorScale.borderDefault);
    final checkColor = colorScale.baseContrastDefault;
    final radius = BorderRadius.circular(theme.borderRadius.sm);

    Widget box = Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: isChecked
          ? CustomPaint(
              painter: widget.indeterminate
                  ? _IndeterminatePainter(color: checkColor)
                  : _CheckPainter(color: checkColor),
            )
          : null,
    );

    // Always reserve focus ring space to prevent layout shift
    final focusDecoration = _isFocused && !widget.readOnly
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

    box = DecoratedBox(
      decoration: focusDecoration,
      child: Padding(
        padding: const EdgeInsets.all(DsFocus.ringWidth),
        child: box,
      ),
    );

    final Widget result = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
      child: Focus(
        focusNode: widget.focusNode,
        onKeyEvent: (node, event) {
          if (!widget.readOnly &&
              event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            widget.onChanged?.call(!widget.value);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.readOnly
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.readOnly
                ? null
                : () => widget.onChanged?.call(!widget.value),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                box,
                if (widget.label != null) ...[
                  const SizedBox(width: 8),
                  widget.label!,
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      checked: widget.value,
      enabled: !widget.readOnly,
      child: result,
    );
  }
}

class _CheckPainter extends CustomPainter {
  final Color color;
  _CheckPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _IndeterminatePainter extends CustomPainter {
  final Color color;
  _IndeterminatePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _IndeterminatePainter oldDelegate) =>
      oldDelegate.color != color;
}
