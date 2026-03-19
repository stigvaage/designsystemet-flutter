import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../spinner/ds_spinner.dart';

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

  @override
  State<DsButton> createState() => _DsButtonState();
}

class _DsButtonState extends State<DsButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isDisabled => widget.disabled || widget.loading;

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

    final content = _buildContent(fgColor);

    Widget button = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Semantics(
        button: true,
        enabled: !_isDisabled,
        child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            border: border,
          ),
          child: content,
        ),
      ),
    );

    // Always reserve focus ring space to prevent layout shift
    final focusDecoration = _isFocused && !_isDisabled
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

    button = DecoratedBox(
      decoration: focusDecoration,
      child: Padding(
        padding: const EdgeInsets.all(DsFocus.ringWidth),
        child: button,
      ),
    );

    if (_isDisabled) {
      button = Opacity(opacity: theme.disabledOpacity, child: button);
    }

    return Focus(
      focusNode: widget.focusNode,
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

  Widget _buildContent(Color fgColor) {
    final theme = DsTheme.of(context);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final verticalPadding = switch (sizeMode) {
      DsSize.sm => 6.0,
      DsSize.md => 10.0,
      DsSize.lg => 14.0,
    };
    final horizontalPadding = switch (sizeMode) {
      DsSize.sm => 12.0,
      DsSize.md => 16.0,
      DsSize.lg => 20.0,
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 14.0,
      DsSize.md => 16.0,
      DsSize.lg => 18.0,
    };

    final textStyle = TextStyle(
      fontFamily: theme.typography.fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: fgColor,
    );

    Widget content;
    if (widget.loading) {
      content = DsSpinner(size: sizeMode, color: widget.color);
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
