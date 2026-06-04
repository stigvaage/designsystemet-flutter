import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_size_tokens.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../spinner/ds_spinner.dart';

/// A Designsystemet button with primary, secondary, and tertiary variants.
///
/// Supports [loading] state (shows spinner), [icon] placement, and inherits
/// color/size from [DsColorScope]/[DsSizeScope] when not set explicitly.
class DsButton extends StatefulWidget {
  const DsButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = DsButtonVariant.primary,
    this.size,
    this.color,
    this.disabled = false,
    this.loading = false,
    this.icon,
    this.iconPosition = DsIconPosition.left,
    this.focusNode,
    this.autofocus = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final DsSize? size;
  final DsColor? color;
  final bool disabled;
  final bool loading;
  final Widget? icon;
  final DsIconPosition iconPosition;
  final FocusNode? focusNode;

  /// Whether this button should request focus when it is first inserted into
  /// the tree. Forwarded to the underlying [Focus] widget. Defaults to `false`.
  final bool autofocus;

  @override
  State<DsButton> createState() => _DsButtonState();
}

class _DsButtonState extends State<DsButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isDisabled =>
      widget.disabled || widget.loading || widget.onPressed == null;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);

    final bgColor = _resolveBackgroundColor(colorScale);
    final fgColor = _resolveForegroundColor(colorScale);
    final border = _resolveBorder(colorScale);
    final duration = DsAnimation.resolveDuration(context, DsAnimation.fast);

    final content = _buildContent(theme, fgColor);

    Widget button = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Semantics(
        button: true,
        enabled: !_isDisabled,
        // Announce the loading state to assistive technology so the spinner
        // (which replaces the visible label) is not silent.
        label: widget.loading ? 'Laster' : null,
        child: AnimatedContainer(
          duration: duration,
          curve: DsAnimation.defaultCurve,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            border: border,
          ),
          child: content,
        ),
      ),
    );

    // Always reserve focus ring space to prevent layout shift.
    button = DsFocus.reserveRing(
      focused: _isFocused && !_isDisabled,
      radius: radius,
      scale: colorScale,
      child: button,
    );

    if (_isDisabled) {
      button = Opacity(opacity: theme.disabledOpacity, child: button);
    }

    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (!_isDisabled &&
            event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onPressed?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (focused) {
        setState(() => _isFocused = focused);
      },
      child: MouseRegion(
        cursor: _isDisabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!_isDisabled) setState(() => _isHovered = true);
        },
        onExit: (_) {
          if (!_isDisabled) setState(() => _isHovered = false);
        },
        child: GestureDetector(
          onTapDown: (_) {
            if (!_isDisabled) setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            if (!_isDisabled) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          },
          onTapCancel: () {
            if (!_isDisabled) setState(() => _isPressed = false);
          },
          child: button,
        ),
      ),
    );
  }

  Widget _buildContent(DsThemeData theme, Color fgColor) {
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final verticalPadding = sizeMode.pick(sm: 6.0, md: 10.0, lg: 14.0);
    final horizontalPadding = sizeMode.pick(sm: 12.0, md: 16.0, lg: 20.0);
    final fontSize = DsSizeValues.fontSize(sizeMode);

    final textStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: fgColor,
    );

    Widget content;
    if (widget.loading) {
      // Paint the spinner with the button's foreground/contrast color (the
      // same color the label uses) so it stays visible on every variant —
      // notably on the filled `baseDefault` primary background.
      content = DsSpinner(size: sizeMode, paintColor: fgColor);
    } else {
      final textWidget = DefaultTextStyle(
        style: textStyle,
        child: widget.child,
      );

      if (widget.icon != null) {
        final iconWidget = IconTheme(
          data: IconThemeData(color: fgColor, size: fontSize + 2),
          child: widget.icon!,
        );
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.iconPosition == DsIconPosition.left
              ? [iconWidget, const SizedBox(width: 8), textWidget]
              : [textWidget, const SizedBox(width: 8), iconWidget],
        );
      } else {
        content = textWidget;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Align(
        alignment: Alignment.center,
        heightFactor: 1.0,
        child: content,
      ),
    );
  }

  Color _resolveBackgroundColor(DsColorScale scale) {
    return switch (widget.variant) {
      DsButtonVariant.primary =>
        _isPressed
            ? scale.baseActive
            : _isHovered
            ? scale.baseHover
            : scale.baseDefault,
      DsButtonVariant.secondary =>
        _isPressed
            ? scale.surfaceActive
            : _isHovered
            ? scale.surfaceHover
            : const Color(0x00000000),
      DsButtonVariant.tertiary =>
        _isPressed
            ? scale.surfaceActive
            : _isHovered
            ? scale.surfaceHover
            : const Color(0x00000000),
    };
  }

  Color _resolveForegroundColor(DsColorScale scale) {
    return switch (widget.variant) {
      DsButtonVariant.primary => scale.baseContrastDefault,
      DsButtonVariant.secondary => scale.textDefault,
      DsButtonVariant.tertiary => scale.textDefault,
    };
  }

  Border? _resolveBorder(DsColorScale scale) {
    return switch (widget.variant) {
      DsButtonVariant.primary => null,
      DsButtonVariant.secondary => Border.all(
        color: scale.borderDefault,
        width: 1,
      ),
      DsButtonVariant.tertiary => null,
    };
  }
}
