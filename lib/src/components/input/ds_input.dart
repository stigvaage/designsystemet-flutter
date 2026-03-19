import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../field/ds_field.dart';

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
    this.textInputAction,
    this.inputFormatters,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.textAlign = TextAlign.start,
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
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final TextAlign textAlign;

  @override
  State<DsInput> createState() => _DsInputState();
}

class _DsInputState extends State<DsInput> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  bool _isHovered = false;
  bool _isFocused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(DsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
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
    final effectiveError = widget.error ?? DsFieldScope.of(context)?.error;
    final hasError = effectiveError != null;
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

    final textStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      color: colorScale.textDefault,
    );

    // TextField requires Material, MaterialLocalizations, and
    // Directionality ancestors. Only wrap in fallback Localizations when
    // MaterialLocalizations is NOT already provided by an ancestor (e.g.
    // MaterialApp). Wrapping unconditionally creates a nested scope that
    // can interfere with the TextField's platform input connection.
    final hasMaterialLocalizations =
        Localizations.of<MaterialLocalizations>(
          context,
          MaterialLocalizations,
        ) !=
        null;

    Widget textFieldTree = Material(
      type: MaterialType.transparency,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: colorScale.baseDefault,
            selectionColor: colorScale.surfaceActive,
            selectionHandleColor: colorScale.baseDefault,
          ),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !widget.disabled,
          style: textStyle,
          cursorColor: colorScale.baseDefault,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          textCapitalization: widget.textCapitalization,
          onTap: widget.onTap,
          textAlign: widget.textAlign,
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
                  null,
          expands: false,
          decoration: InputDecoration.collapsed(
            hintText: widget.placeholder,
            hintStyle: textStyle.copyWith(color: colorScale.textSubtle),
          ),
        ),
      ),
    );

    if (!hasMaterialLocalizations) {
      final locale = Localizations.maybeLocaleOf(context) ?? const Locale('en');
      textFieldTree = Localizations(
        locale: locale,
        delegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        child: textFieldTree,
      );
    }

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
            child: Padding(padding: padding, child: textFieldTree),
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
        child: Opacity(opacity: theme.disabledOpacity, child: result),
      );
    }

    // TextField provides its own Semantics (textField, enabled, readOnly,
    // hintText). Only add the outer MouseRegion for hover tracking.
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: result,
    );
  }
}
