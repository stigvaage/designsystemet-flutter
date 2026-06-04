import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scale.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';

/// Severity-based notification banner for inline messages.
///
/// Displays an icon, optional [title], body content, and an optional close
/// button. Set [severity] to info, warning, success, or danger.
class DsAlert extends StatelessWidget {
  const DsAlert({
    super.key,
    required this.child,
    this.severity = DsSeverity.info,
    this.title,
    this.closable = false,
    this.onClose,
    this.color,
    this.size,
  });

  final Widget child;
  final DsSeverity severity;
  final Widget? title;
  final bool closable;
  final VoidCallback? onClose;
  final DsColor? color;
  final DsSize? size;

  DsColor get _severityColor => switch (severity) {
    DsSeverity.info => DsColor.info,
    DsSeverity.warning => DsColor.warning,
    DsSeverity.success => DsColor.success,
    DsSeverity.danger => DsColor.danger,
  };

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final effectiveColor = color ?? _severityColor;
    final colorScale = theme.colorScheme.resolve(effectiveColor);
    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);

    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: colorScale.surfaceTinted,
          borderRadius: radius,
          border: Border(
            left: BorderSide(color: colorScale.borderDefault, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Severity icon
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 2),
              child: _SeverityIcon(
                severity: severity,
                color: colorScale.baseDefault,
              ),
            ),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: DefaultTextStyle(
                        style: theme.typography.bodyMd.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScale.textDefault,
                        ),
                        child: title!,
                      ),
                    ),
                  DefaultTextStyle(
                    style: theme.typography.bodyMd.copyWith(
                      color: colorScale.textDefault,
                    ),
                    child: child,
                  ),
                ],
              ),
            ),
            // Close button
            if (closable)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _CloseButton(colorScale: colorScale, onClose: onClose),
              ),
          ],
        ),
      ),
    );
  }
}

/// The dismiss control rendered when [DsAlert.closable] is `true`.
///
/// Tracks its own focus state so it can reserve and paint a focus ring
/// (via [DsFocus.reserveRing]) without shifting layout, and shows the
/// click cursor on hover. Activates on tap and on Enter/Space.
class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.colorScale, required this.onClose});

  final DsColorScale colorScale;
  final VoidCallback? onClose;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    Widget button = SizedBox(
      width: 44,
      height: 44,
      child: Center(
        child: Icon(DsIcons.x, size: 16, color: widget.colorScale.textSubtle),
      ),
    );

    // Always reserve focus ring space to prevent layout shift.
    button = DsFocus.reserveRing(
      focused: _isFocused,
      radius: BorderRadius.zero,
      scale: widget.colorScale,
      child: button,
    );

    return Semantics(
      button: true,
      label: 'Lukk varsel',
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onClose?.call();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(onTap: widget.onClose, child: button),
        ),
      ),
    );
  }
}

class _SeverityIcon extends StatelessWidget {
  const _SeverityIcon({required this.severity, required this.color});
  final DsSeverity severity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (severity) {
      DsSeverity.info => DsIcons.info,
      DsSeverity.warning => DsIcons.triangleAlert,
      DsSeverity.success => DsIcons.circleCheck,
      DsSeverity.danger => DsIcons.circleX,
    };
    return Icon(icon, size: 18, color: color);
  }
}
