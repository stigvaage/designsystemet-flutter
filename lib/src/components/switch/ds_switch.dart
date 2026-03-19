import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A toggle switch with an animated sliding thumb.
///
/// Supports optional label and description, keyboard activation (Space),
/// and a read-only mode.
class DsSwitch extends StatefulWidget {
  const DsSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.size,
    this.color,
    this.readOnly = false,
    this.focusNode,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final Widget? description;
  final DsSize? size;
  final DsColor? color;
  final bool readOnly;
  final FocusNode? focusNode;

  @override
  State<DsSwitch> createState() => _DsSwitchState();
}

class _DsSwitchState extends State<DsSwitch> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.normal);
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final trackWidth = switch (sizeMode) {
      DsSize.sm => 36.0,
      DsSize.md => 44.0,
      DsSize.lg => 52.0,
    };
    final trackHeight = switch (sizeMode) {
      DsSize.sm => 20.0,
      DsSize.md => 24.0,
      DsSize.lg => 28.0,
    };
    final thumbSize = trackHeight - 4;

    final trackColor = widget.value
        ? colorScale.baseDefault
        : colorScale.surfaceDefault;
    final trackBorder = widget.value
        ? colorScale.baseDefault
        : colorScale.borderDefault;
    final thumbColor = widget.value
        ? colorScale.baseContrastDefault
        : colorScale.backgroundDefault;

    Widget track = AnimatedContainer(
      duration: duration,
      width: trackWidth,
      height: trackHeight,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(trackHeight / 2),
        border: Border.all(color: trackBorder, width: 1),
      ),
      child: AnimatedAlign(
        duration: duration,
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

    if (_isFocused) {
      track = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            trackHeight / 2 + DsFocus.ringWidth,
          ),
          border: Border.all(
            color: colorScale.borderStrong,
            width: DsFocus.ringWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DsFocus.ringWidth),
          child: track,
        ),
      );
    }

    final hasLabelContent = widget.label != null || widget.description != null;

    Widget result = Semantics(
      toggled: widget.value,
      enabled: !widget.readOnly,
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
        child: GestureDetector(
          onTap: widget.readOnly
              ? null
              : () => widget.onChanged?.call(!widget.value),
          child: hasLabelContent
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.description != null
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    track,
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.label != null) widget.label!,
                        if (widget.description != null)
                          DefaultTextStyle(
                            style: theme.typography.bodySm.copyWith(
                              color: colorScale.textSubtle,
                            ),
                            child: widget.description!,
                          ),
                      ],
                    ),
                  ],
                )
              : track,
        ),
      ),
    );

    return result;
  }
}
