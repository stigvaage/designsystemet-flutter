import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../typography/ds_validation_message.dart';
import '../../utils/ds_control_label.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A Designsystemet checkbox with optional label, description, and error state.
///
/// Supports [indeterminate] mode, [readOnly] to prevent interaction while
/// keeping the control visible, and [disabled] to dim the whole control
/// (matching `DsButton`/`DsInput`).
///
/// When [error] is set the control is rendered with the danger color scale
/// (red border) and the error message is shown below the control via
/// [DsValidationMessage]. The error is also reflected in semantics and
/// announced as a live region so a valid → invalid transition is read out by
/// assistive technologies.
///
/// Inherits color/size from [DsColorScope]/[DsSizeScope] when not set
/// explicitly.
class DsCheckbox extends StatefulWidget {
  const DsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.size,
    this.color,
    this.error,
    this.indeterminate = false,
    this.readOnly = false,
    this.disabled = false,
    this.autofocus = false,
    this.focusNode,
    this.variant = DsSelectionVariant.default_,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the user toggles the checkbox. When `null` the checkbox is
  /// non-interactive (it can still be focused but will not change).
  final ValueChanged<bool>? onChanged;

  /// Optional primary label shown next to the box.
  final Widget? label;

  /// Optional secondary description shown below the [label].
  final Widget? description;

  /// The size mode. Inherits from [DsSizeScope] when not set.
  final DsSize? size;

  /// The color scale. Inherits from [DsColorScope] when not set. Overridden by
  /// the danger scale when [error] is set.
  final DsColor? color;

  /// When non-null, renders the control in its error state (danger scale) and
  /// shows this message below the control. User-facing Norwegian text.
  final String? error;

  /// Whether the checkbox is in the indeterminate ("mixed") state.
  final bool indeterminate;

  /// Whether the checkbox is read-only. A read-only checkbox stays at full
  /// opacity but does not respond to taps, keyboard or hover.
  final bool readOnly;

  /// Whether the checkbox is disabled. A disabled checkbox is dimmed using the
  /// theme's disabled opacity and ignores all pointer input, matching
  /// `DsButton`/`DsInput`.
  final bool disabled;

  /// Whether to autofocus the control when first built.
  final bool autofocus;

  /// An optional focus node for the control.
  final FocusNode? focusNode;

  /// The visual variant. [DsSelectionVariant.outline] wraps the control in a
  /// bordered container that highlights when checked. Defaults to
  /// [DsSelectionVariant.default_].
  final DsSelectionVariant variant;

  @override
  State<DsCheckbox> createState() => _DsCheckboxState();
}

class _DsCheckboxState extends State<DsCheckbox> {
  bool _isHovered = false;
  bool _isFocused = false;

  /// Whether the control reacts to user input. A `null` [DsCheckbox.onChanged],
  /// [DsCheckbox.readOnly] or [DsCheckbox.disabled] all make it inert.
  bool get _isInteractive =>
      widget.onChanged != null && !widget.readOnly && !widget.disabled;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final hasError = widget.error != null;
    // Error forces the danger scale (red border); otherwise use the explicit
    // or inherited color.
    final activeColor = hasError
        ? DsColor.danger
        : (widget.color ?? DsColorScope.of(context));
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final boxSize = sizeMode.pick(sm: 18.0, md: 22.0, lg: 26.0);

    final isChecked = widget.value || widget.indeterminate;
    final bgColor = isChecked
        ? colorScale.baseDefault
        : colorScale.backgroundDefault;
    // Only show the borderStrong hover treatment when the control is
    // interactive; a read-only/disabled checkbox must not light up on hover.
    final borderColor = isChecked
        ? colorScale.baseDefault
        : ((_isHovered && _isInteractive)
              ? colorScale.borderStrong
              : colorScale.borderDefault);
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

    // Always reserve the focus-ring gap so focusing never shifts layout. The
    // ring only appears while focused and interactive.
    box = DsFocus.reserveRing(
      focused: _isFocused && _isInteractive,
      radius: radius,
      scale: colorScale,
      child: box,
    );

    Widget control;
    if (widget.label != null || widget.description != null) {
      control = DsControlLabel(
        control: box,
        label: widget.label ?? const SizedBox.shrink(),
        description: widget.description,
        descriptionStyle: theme.typography.bodySm.copyWith(
          color: colorScale.textSubtle,
        ),
      );
    } else {
      control = box;
    }

    if (widget.variant == DsSelectionVariant.outline) {
      control = Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
          border: Border.all(
            // Use isChecked (value OR indeterminate) so the indeterminate
            // state also highlights the outline border.
            color: isChecked ? colorScale.baseDefault : colorScale.borderSubtle,
            width: 1,
          ),
        ),
        child: control,
      );
    }

    Widget controlRow = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        // Gate keyboard focus by interactivity so disabled/read-only/null-
        // handler checkboxes are removed from the Tab order, matching
        // DsRadio/DsSwitch and the official Designsystemet.
        canRequestFocus: _isInteractive,
        onKeyEvent: (node, event) {
          if (_isInteractive &&
              event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            widget.onChanged?.call(!widget.value);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          // Guard hover by interactivity so read-only/disabled checkboxes do
          // not show the hover cursor or borderStrong treatment.
          onEnter: (_) {
            if (_isInteractive) setState(() => _isHovered = true);
          },
          onExit: (_) {
            if (_isInteractive) setState(() => _isHovered = false);
          },
          cursor: _isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            // Opaque so a tap anywhere in the control area (including the
            // label and the gap between box and label) toggles the checkbox,
            // not only a tap directly on the box.
            behavior: HitTestBehavior.opaque,
            onTap: _isInteractive
                ? () => widget.onChanged?.call(!widget.value)
                : null,
            child: control,
          ),
        ),
      ),
    );

    if (widget.disabled) {
      controlRow = IgnorePointer(
        child: Opacity(opacity: theme.disabledOpacity, child: controlRow),
      );
    }

    Widget result = controlRow;
    if (hasError) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          controlRow,
          // Announce valid → invalid transitions. The message itself carries
          // the danger styling via DsValidationMessage.
          Semantics(
            liveRegion: true,
            child: DsValidationMessage(message: widget.error!),
          ),
        ],
      );
    }

    return Semantics(
      // Tri-state semantics: an indeterminate checkbox is announced as
      // "mixed", not "unchecked". When mixed, leave [checked] null so
      // assistive technologies do not also report a checked/unchecked state.
      mixed: widget.indeterminate,
      checked: widget.indeterminate ? null : widget.value,
      // Fold onChanged == null into the enabled flag (alongside disabled and
      // readOnly) so a null-handler checkbox is announced as disabled, matching
      // DsRadio/DsSwitch and the control's own _isInteractive interaction gate.
      enabled: _isInteractive,
      // Surface the error to assistive technologies as the control's hint.
      hint: widget.error,
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
