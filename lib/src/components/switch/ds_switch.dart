import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_control_label.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A toggle switch with an animated sliding thumb.
///
/// Supports optional label and description, keyboard activation (Space),
/// a [disabled] state, and a [readOnly] mode.
///
/// The [variant] controls the visual style: [DsSelectionVariant.default_]
/// renders the bare control, while [DsSelectionVariant.outline] wraps the
/// whole control in a selectable bordered box.
class DsSwitch extends StatefulWidget {
  const DsSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.size,
    this.color,
    this.disabled = false,
    this.readOnly = false,
    this.focusNode,
    this.autofocus = false,
    this.variant = DsSelectionVariant.default_,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called when the user toggles the switch.
  ///
  /// When `null` the switch is non-interactive (rendered like [disabled]
  /// without the dimming), mirroring the official disabled-by-absent-handler
  /// behavior.
  final ValueChanged<bool>? onChanged;

  /// Optional label shown next to the control.
  final Widget? label;

  /// Optional description shown below the [label].
  final Widget? description;

  /// The control size. Inherits from [DsSizeScope] when not set.
  final DsSize? size;

  /// The accent color. Inherits from [DsColorScope] when not set.
  final DsColor? color;

  /// Whether the switch is disabled.
  ///
  /// A disabled switch is dimmed with [DsThemeData.disabledOpacity] and does
  /// not respond to pointer, keyboard, or focus. Distinct from [readOnly],
  /// which keeps full opacity but blocks changes.
  final bool disabled;

  /// Whether the switch is read-only.
  ///
  /// A read-only switch keeps full opacity but does not respond to toggling.
  final bool readOnly;

  /// An optional focus node to control the switch's focus.
  final FocusNode? focusNode;

  /// Whether the switch should request focus when first built.
  final bool autofocus;

  /// The visual style of the switch.
  ///
  /// [DsSelectionVariant.outline] wraps the control in a bordered box that
  /// highlights its border with [DsColorScale.baseDefault] when [value] is
  /// `true`. Mirrors the React `data-variant="outline"` selection style.
  final DsSelectionVariant variant;

  @override
  State<DsSwitch> createState() => _DsSwitchState();
}

class _DsSwitchState extends State<DsSwitch> {
  bool _isFocused = false;
  bool _isHovered = false;

  /// Non-interactive when explicitly disabled, read-only, or when there is no
  /// change handler to call.
  bool get _isInteractive =>
      !widget.disabled && !widget.readOnly && widget.onChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.normal);
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final trackWidth = sizeMode.pick(sm: 36.0, md: 44.0, lg: 52.0);
    final trackHeight = sizeMode.pick(sm: 20.0, md: 24.0, lg: 28.0);
    final thumbSize = trackHeight - 4;

    final trackColor = widget.value
        ? colorScale.baseDefault
        : colorScale.surfaceDefault;
    // Subtle hover treatment consistent with DsButton/DsCheckbox: when off,
    // strengthen the track border on hover; when on, keep the base border.
    final trackBorder = widget.value
        ? colorScale.baseDefault
        : (_isHovered && _isInteractive
              ? colorScale.borderStrong
              : colorScale.borderDefault);
    final thumbColor = widget.value
        ? colorScale.baseContrastDefault
        : colorScale.backgroundDefault;

    Widget track = AnimatedContainer(
      duration: duration,
      curve: DsAnimation.defaultCurve,
      width: trackWidth,
      height: trackHeight,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(trackHeight / 2),
        border: Border.all(color: trackBorder, width: 1),
      ),
      child: AnimatedAlign(
        duration: duration,
        curve: DsAnimation.defaultCurve,
        alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: thumbColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );

    // Always reserve the focus-ring space (no layout shift on focus). The
    // track is a pill, so pass a stadium radius matching its half-height.
    track = DsFocus.reserveRing(
      focused: _isFocused && _isInteractive,
      radius: BorderRadius.circular(trackHeight / 2),
      scale: colorScale,
      child: track,
    );

    final hasLabelContent = widget.label != null || widget.description != null;

    final Widget inner = hasLabelContent
        ? DsControlLabel(
            control: track,
            label: widget.label ?? const SizedBox.shrink(),
            description: widget.description,
            descriptionStyle: theme.typography.bodySm.copyWith(
              color: colorScale.textSubtle,
            ),
          )
        : track;

    Widget result = Semantics(
      toggled: widget.value,
      enabled: _isInteractive,
      // Guarantee a 44x44 minimum tap target so the bare default-variant
      // control stays operable, matching DsCheckbox/DsRadio/DsButton.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
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
            cursor: _isInteractive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onEnter: (_) {
              if (_isInteractive) setState(() => _isHovered = true);
            },
            onExit: (_) {
              if (_isInteractive) setState(() => _isHovered = false);
            },
            child: GestureDetector(
              // Opaque so a tap anywhere in the control area (including the
              // label and the outline padding/border zone) toggles the switch.
              behavior: HitTestBehavior.opaque,
              onTap: _isInteractive
                  ? () => widget.onChanged?.call(!widget.value)
                  : null,
              // The outline wrapper is the GestureDetector's CHILD so its
              // padding/border zone is inside the hit-test area (no dead
              // tap-zone).
              child: widget.variant == DsSelectionVariant.outline
                  ? _wrapInOutline(inner, theme, colorScale)
                  : inner,
            ),
          ),
        ),
      ),
    );

    // A disabled switch is dimmed and fully non-interactive. readOnly and the
    // null-handler case stay at full opacity but are still non-interactive.
    if (widget.disabled) {
      result = Opacity(
        opacity: theme.disabledOpacity,
        child: IgnorePointer(child: result),
      );
    }

    return result;
  }

  Widget _wrapInOutline(
    Widget child,
    DsThemeData theme,
    DsColorScale colorScale,
  ) {
    final borderColor = widget.value
        ? colorScale.baseDefault
        : colorScale.borderSubtle;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );
  }
}
