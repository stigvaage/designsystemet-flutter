import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../field/ds_field.dart';

/// Core text input component styled with Designsystemet tokens.
///
/// Wraps Material [TextField] for platform-native editing behavior.
/// Prefer [DsTextfield] for single-line inputs or [DsField] to add labels.
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
    if (_focusNode.hasFocus) _ensureVisibleAboveKeyboard();
  }

  /// Scrolls the focused field above the soft keyboard so the user can see
  /// what they are typing. No-op when the field is not inside a [Scrollable]
  /// (keyboard avoidance is then left to Scaffold.resizeToAvoidBottomInset).
  ///
  /// Runs one extra frame after focus so it targets the post-keyboard
  /// (shrunken) viewport instead of racing EditableText's own caret reveal;
  /// it converges to the same end state, so the two do not oscillate.
  void _ensureVisibleAboveKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_focusNode.hasFocus) return;
      if (Scrollable.maybeOf(context) == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasFocus || !context.mounted) return;
        Scrollable.ensureVisible(
          context,
          alignment: 0.1, // small margin above the keyboard
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        );
      });
    });
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
          // contentPadding lives INSIDE the TextField (not an outer Padding)
          // so the field's own hit-test area covers the whole control — a tap
          // anywhere opens the keyboard on the FIRST tap. isCollapsed keeps the
          // tight vertical metrics of the previous InputDecoration.collapsed.
          decoration: InputDecoration(
            isCollapsed: true,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: padding,
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

    final canFocusByTap = !widget.disabled && !widget.readOnly;

    // No tap handler wraps the whole field: the TextField now hit-tests its
    // entire area (contentPadding above), so it wins the gesture and opens the
    // keyboard on the FIRST tap. A competing ancestor GestureDetector/Listener
    // would steal that first tap — the double-tap-to-open-keyboard bug.
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
            // Translucent (not opaque): a tap on the prefix gutter focuses the
            // field, but an interactive prefix child still handles its own tap.
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: canFocusByTap ? _focusNode.requestFocus : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: widget.prefix!,
              ),
            ),
          ],
          Expanded(child: textFieldTree),
          if (widget.suffix != null) ...[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: canFocusByTap ? _focusNode.requestFocus : null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: widget.suffix!,
              ),
            ),
          ],
        ],
      ),
    );

    // The focus-ring wrapper is ALWAYS in the tree (its space is always
    // reserved); only its decoration toggles. Inserting/removing the
    // DecoratedBox+Padding on focus would change the widget type under the
    // MouseRegion, tearing down and recreating the TextField element — which
    // kills the in-flight first-tap keyboard open (the double-tap bug). Keeping
    // the structure constant also removes the 3px layout jump on focus.
    final showFocusRing = _isFocused && !widget.disabled && !widget.readOnly;
    result = DecoratedBox(
      decoration: showFocusRing
          ? DsFocus.focusRingWithRadius(colorScale, radius)
          : const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(DsFocus.ringWidth),
        child: result,
      ),
    );

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
