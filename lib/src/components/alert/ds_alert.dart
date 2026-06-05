import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scale.dart';
import '../../theme/ds_size_scope.dart';
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

  /// Innholdet i varselboksen.
  final Widget child;

  /// Alvorlighetsgrad som styrer ikon og fargeskala.
  final DsSeverity severity;

  /// Valgfri tittel som vises over [child] med halvfet vekt.
  final Widget? title;

  /// Om varselboksen kan lukkes via en lukkeknapp.
  final bool closable;

  /// Tilbakeringing som kjøres når lukkeknappen aktiveres.
  ///
  /// Lukkeknappen er kun interaktiv (fokuserbar og tastaturstyrt) når denne
  /// er satt; er den `null` vises ingen aktiv lukkeknapp selv om [closable]
  /// er `true`.
  final VoidCallback? onClose;

  /// Overstyrer fargerollen som ellers utledes fra [severity].
  final DsColor? color;

  /// Størrelse på varselboksen (`sm`/`md`/`lg`).
  ///
  /// Styrer innvendig polstring, ikonstørrelse og typografi. Faller tilbake
  /// til nærmeste [DsSizeScope] (standard `md`) når den ikke er satt.
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

    // Faller tilbake til nærmeste størrelsesomfang (standard md) når ikke satt,
    // på samme måte som DsButton/DsSpinner.
    final sizeMode = size ?? DsSizeScope.of(context);
    final padding = sizeMode.pick(sm: 12.0, md: 16.0, lg: 20.0);
    final iconSize = sizeMode.pick(sm: 16.0, md: 18.0, lg: 22.0);
    final bodyStyle = sizeMode.pick(
      sm: theme.typography.bodySm,
      md: theme.typography.bodyMd,
      lg: theme.typography.bodyLg,
    );

    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: colorScale.surfaceTinted,
          borderRadius: radius,
          // Offisiell Designsystemet Alert bruker en heldekkende, tynn kant
          // på alle sider (--dsc-alert-border-*), ikke en tykk venstrestripe.
          border: Border.all(color: colorScale.borderDefault, width: 1),
        ),
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Severity icon
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 2),
              child: _SeverityIcon(
                severity: severity,
                // textDefault gir tilstrekkelig kontrast mot surfaceTinted for
                // alle alvorlighetsgrader (WCAG 1.4.11), i motsetning til
                // baseDefault som feiler for warning/info.
                color: colorScale.textDefault,
                size: iconSize,
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
                        style: bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScale.textDefault,
                        ),
                        child: title!,
                      ),
                    ),
                  DefaultTextStyle(
                    style: bodyStyle.copyWith(color: colorScale.textDefault),
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
/// click cursor on hover. Activates on tap and on Enter/Space/Escape.
///
/// The control is only interactive — focusable, key-handling and showing the
/// click cursor — when [onClose] is non-null; otherwise it renders as inert
/// (matching the `canRequestFocus: enabled` convention used by other
/// interactive components).
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
    final isInteractive = widget.onClose != null;

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
      button: isInteractive,
      label: 'Lukk varsel',
      child: Focus(
        canRequestFocus: isInteractive,
        onKeyEvent: (node, event) {
          final onClose = widget.onClose;
          if (onClose != null &&
              event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space ||
                  event.logicalKey == LogicalKeyboardKey.escape)) {
            onClose();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
        },
        child: MouseRegion(
          cursor: isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(onTap: widget.onClose, child: button),
        ),
      ),
    );
  }
}

class _SeverityIcon extends StatelessWidget {
  const _SeverityIcon({
    required this.severity,
    required this.color,
    required this.size,
  });
  final DsSeverity severity;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Gi ikonet en norsk per-alvorlighetsgrad-etikett slik at skjermlesere
    // annonserer klassifiseringen (severity formidles ikke kun via farge/form).
    final (icon, label) = switch (severity) {
      DsSeverity.info => (DsIcons.info, 'Informasjon'),
      DsSeverity.warning => (DsIcons.triangleAlert, 'Advarsel'),
      DsSeverity.success => (DsIcons.circleCheck, 'Vellykket'),
      DsSeverity.danger => (DsIcons.circleX, 'Feil'),
    };
    return Icon(icon, size: size, color: color, semanticLabel: label);
  }
}
