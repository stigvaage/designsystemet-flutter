import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_control_label.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A radio button with optional label, description, and error state.
///
/// Supports keyboard activation (Space), an always-reserved focus ring, three
/// size modes, and a danger [error] state. Radio selection is idempotent:
/// re-activating the already-selected radio is a no-op (a radio group must
/// always keep one option selected).
///
/// Set [disabled] to render the control non-interactive and dimmed; this is
/// distinct from [readOnly], which keeps full opacity but blocks changes.
/// Passing a `null` [onChanged] is also treated as non-interactive.
class DsRadio extends StatefulWidget {
  const DsRadio({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.size,
    this.color,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.variant = DsSelectionVariant.default_,
  });

  /// Whether this radio is the currently selected option in its group.
  final bool value;

  /// Called when the radio transitions to selected. Never called with `false`
  /// (radio selection is idempotent). A `null` callback makes the control
  /// non-interactive, just like [disabled].
  final ValueChanged<bool>? onChanged;

  /// The primary label shown next to the radio circle.
  final Widget? label;

  /// Optional secondary description shown below the [label].
  final Widget? description;

  /// Size mode. Falls back to [DsSizeScope] when `null`.
  final DsSize? size;

  /// Color scale for the selected state. Falls back to [DsColorScope] when
  /// `null`. Ignored while [error] is set (the danger scale is used instead).
  final DsColor? color;

  /// When non-null, renders the control in the danger scale and shows this
  /// message below the control as a validation error.
  final String? error;

  /// When `true`, the control is dimmed ([DsThemeData.disabledOpacity]) and
  /// does not respond to pointer, keyboard, or hover. Distinct from
  /// [readOnly], which keeps full opacity.
  final bool disabled;

  /// When `true`, the control keeps full opacity but ignores interaction
  /// (taps, Space, hover). Distinct from [disabled], which also dims it.
  final bool readOnly;

  /// Whether the control requests focus when first built.
  final bool autofocus;

  /// An optional focus node controlling this radio's focus.
  final FocusNode? focusNode;

  /// Visual variant. [DsSelectionVariant.outline] wraps the control in a
  /// bordered container that highlights when selected (matches the React
  /// radio `data-variant="outline"`).
  final DsSelectionVariant variant;

  @override
  State<DsRadio> createState() => _DsRadioState();
}

class _DsRadioState extends State<DsRadio> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final hasError = widget.error != null;
    // onChanged == null is treated as non-interactive, like disabled.
    final isInteractive =
        !widget.disabled && !widget.readOnly && widget.onChanged != null;

    // In the error state the danger scale drives the circle border/dot,
    // matching the official radio's error styling. Otherwise use the resolved
    // active color.
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = hasError
        ? theme.colorScheme.danger
        : theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final outerSize = sizeMode.pick(sm: 18.0, md: 22.0, lg: 26.0);
    final innerSize = outerSize * 0.5;

    // Hover only affects the border when the control is interactive (#4).
    final showHover = _isHovered && isInteractive;
    final borderColor = widget.value
        ? colorScale.baseDefault
        : (showHover ? colorScale.borderStrong : colorScale.borderDefault);

    Widget circle = Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScale.backgroundDefault,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: widget.value
          ? Center(
              child: Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScale.baseDefault,
                ),
              ),
            )
          : null,
    );

    // Always reserve circular focus-ring space to prevent layout shift; the
    // ring only paints when focused and the control is interactive.
    circle = DsFocus.reserveRingCircle(
      focused: _isFocused && isInteractive,
      scale: colorScale,
      child: circle,
    );

    // Only build the label layout when there is a label or description;
    // a bare radio renders just the circle (no gap, matching the previous
    // layout).
    Widget control = (widget.label != null || widget.description != null)
        ? DsControlLabel(
            control: circle,
            label: widget.label ?? const SizedBox.shrink(),
            description: widget.description,
            descriptionStyle: theme.typography.bodySm.copyWith(
              color: colorScale.textSubtle,
            ),
            // A bare circle (no description) is centered, never start-aligned.
            crossAxisAlignment: widget.description != null
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
          )
        : circle;

    control = _wrapVariant(theme, colorScale, control);

    Widget interactive = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: isInteractive,
        onKeyEvent: (node, event) {
          if (isInteractive &&
              event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            // Radio selection is idempotent: activating an already-selected
            // radio must not deselect it (a group must always keep one
            // selected). Only notify when transitioning to selected.
            if (!widget.value) {
              widget.onChanged?.call(true);
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            // Opaque so a tap anywhere in the control area (including the
            // label and the gap) selects the radio, not only the circle.
            behavior: HitTestBehavior.opaque,
            onTap: isInteractive
                // Radio selection is idempotent: tapping an already-selected
                // radio must not deselect it. Only notify when transitioning
                // to selected.
                ? () {
                    if (!widget.value) {
                      widget.onChanged?.call(true);
                    }
                  }
                : null,
            child: control,
          ),
        ),
      ),
    );

    if (widget.disabled) {
      interactive = IgnorePointer(
        child: Opacity(opacity: theme.disabledOpacity, child: interactive),
      );
    }

    Widget result = Semantics(
      selected: widget.value,
      enabled: isInteractive,
      child: interactive,
    );

    // Show the validation message below the control. It is wrapped in a
    // live-region Semantics node so assistive technologies announce it when it
    // appears (#57).
    if (hasError) {
      final dangerScale = theme.colorScheme.danger;
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          result,
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Semantics(
              liveRegion: true,
              child: Text(
                widget.error!,
                style: theme.typography.bodySm.copyWith(
                  color: dangerScale.textDefault,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return result;
  }

  /// Wraps [control] in the [DsSelectionVariant.outline] bordered container
  /// (border highlights when [value] is `true`); returns [control] unchanged
  /// for [DsSelectionVariant.default_].
  Widget _wrapVariant(
    DsThemeData theme,
    DsColorScale colorScale,
    Widget control,
  ) {
    if (widget.variant != DsSelectionVariant.outline) {
      return control;
    }
    final borderColor = widget.value
        ? colorScale.baseDefault
        : colorScale.borderSubtle;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
      ),
      child: control,
    );
  }
}
