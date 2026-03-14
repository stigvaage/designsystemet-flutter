import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

class DsInput extends StatefulWidget {
  const DsInput({
    super.key,
    this.controller,
    this.size,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.autofocus = false,
    this.placeholder,
  });

  final TextEditingController? controller;
  final DsSize? size;
  final String? error;
  final bool disabled;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final bool autofocus;
  final String? placeholder;

  @override
  State<DsInput> createState() => _DsInputState();
}

class _DsInputState extends State<DsInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final dangerScale = theme.colorScheme.danger;
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final hasError = widget.error != null;
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    };

    final fontSize = switch (sizeMode) {
      DsSize.sm => 14.0,
      DsSize.md => 16.0,
      DsSize.lg => 18.0,
    };

    Color borderColor;
    if (widget.disabled) {
      borderColor = colorScale.borderDefault;
    } else if (hasError) {
      borderColor = dangerScale.borderDefault;
    } else if (_isFocused) {
      borderColor = colorScale.borderStrong;
    } else if (_isHovered) {
      borderColor = colorScale.borderStrong;
    } else {
      borderColor = colorScale.borderDefault;
    }

    final borderSide = widget.readOnly
        ? BorderSide.none
        : BorderSide(color: borderColor, width: 1);

    final Widget input = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: TextStyle(
        fontFamily: theme.typography.fontFamily,
        fontSize: fontSize,
        color: colorScale.textDefault,
      ),
      cursorColor: colorScale.baseDefault,
      backgroundCursorColor: colorScale.surfaceDefault,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
    );

    Widget result = AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
        color: widget.readOnly
            ? colorScale.surfaceDefault
            : colorScale.backgroundDefault,
        borderRadius: radius,
        border: Border.fromBorderSide(borderSide),
      ),
      child: Row(
        children: [
          if (widget.prefix != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: widget.prefix!,
            ),
          ],
          Expanded(
            child: Padding(padding: padding, child: input),
          ),
          if (widget.suffix != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: widget.suffix!,
            ),
          ],
        ],
      ),
    );

    if (_isFocused && !widget.disabled && !widget.readOnly) {
      result = DecoratedBox(
        decoration: DsFocus.focusRingWithRadius(colorScale, radius),
        child: Padding(
          padding: const EdgeInsets.all(DsFocus.ringWidth),
          child: result,
        ),
      );
    }

    if (widget.disabled) {
      result = IgnorePointer(
        child: Opacity(
          opacity: theme.disabledOpacity,
          child: result,
        ),
      );
    }

    return Semantics(
      textField: true,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: result,
      ),
    );
  }
}
