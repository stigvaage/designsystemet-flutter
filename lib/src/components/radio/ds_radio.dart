import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

class DsRadio extends StatefulWidget {
  const DsRadio({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.size,
    this.color,
    this.error,
    this.readOnly = false,
    this.focusNode,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final DsSize? size;
  final DsColor? color;
  final String? error;
  final bool readOnly;
  final FocusNode? focusNode;

  @override
  State<DsRadio> createState() => _DsRadioState();
}

class _DsRadioState extends State<DsRadio> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);

    final outerSize = switch (sizeMode) {
      DsSize.sm => 18.0,
      DsSize.md => 22.0,
      DsSize.lg => 26.0,
    };
    final innerSize = outerSize * 0.5;

    final borderColor = widget.value
        ? colorScale.baseDefault
        : (_isHovered ? colorScale.borderStrong : colorScale.borderDefault);

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

    if (_isFocused) {
      circle = DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScale.borderStrong,
            width: DsFocus.ringWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DsFocus.ringWidth),
          child: circle,
        ),
      );
    }

    return Semantics(
      selected: widget.value,
      enabled: !widget.readOnly,
      child: Focus(
        focusNode: widget.focusNode,
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.readOnly ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.readOnly ? null : () => widget.onChanged?.call(!widget.value),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                circle,
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
  }
}
