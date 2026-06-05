import 'package:flutter/widgets.dart';
import '../theme/ds_theme.dart';
import '../utils/ds_enums.dart';
import '../utils/ds_icons.dart';

/// Valideringsmelding som vises under skjemafelter.
///
/// Speiler den offisielle `ValidationMessage`: et alvorlighetsikon foran
/// teksten, fargelagt med riktig `*-text-subtle`-token. [severity] velger
/// fargevariant og ikon (danger/warning/info/success, standard danger).
///
/// Feil- og advarselsmeldinger pakkes i et `Semantics`-liveRegion slik at
/// skjermlesere annonserer dem automatisk når de dukker opp. Komponenter som
/// allerede pakker meldingen i sitt eget liveRegion bør ikke gjøre det igjen.
class DsValidationMessage extends StatelessWidget {
  const DsValidationMessage({
    super.key,
    required this.message,
    this.severity,
    this.isError = true,
  });

  /// Valideringsmeldingen som vises.
  final String message;

  /// Alvorlighetsgrad som styrer farge og ikon.
  ///
  /// Standard er [DsSeverity.danger]. Når den er `null`, utledes verdien fra
  /// [isError] for bakoverkompatibilitet.
  final DsSeverity? severity;

  /// Om meldingen er en feil (danger) eller suksess (success).
  ///
  /// Eldre API som beholdes for bakoverkompatibilitet. Foretrekk [severity],
  /// som også støtter warning og info. [isError] brukes kun når [severity] er
  /// `null`: `true` tilsvarer [DsSeverity.danger], `false` tilsvarer
  /// [DsSeverity.success].
  final bool isError;

  /// Den effektive alvorlighetsgraden, utledet fra [severity] eller [isError].
  DsSeverity get _effectiveSeverity =>
      severity ?? (isError ? DsSeverity.danger : DsSeverity.success);

  DsColor _severityColor(DsSeverity severity) => switch (severity) {
    DsSeverity.info => DsColor.info,
    DsSeverity.warning => DsColor.warning,
    DsSeverity.success => DsColor.success,
    DsSeverity.danger => DsColor.danger,
  };

  IconData _severityIcon(DsSeverity severity) => switch (severity) {
    DsSeverity.info => DsIcons.info,
    DsSeverity.warning => DsIcons.triangleAlert,
    DsSeverity.success => DsIcons.circleCheck,
    DsSeverity.danger => DsIcons.circleX,
  };

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final severity = _effectiveSeverity;
    final colorScale = theme.colorScheme.resolve(_severityColor(severity));

    // Offisiell .ds-validation-message bruker *-text-subtle for både tekst og
    // ikon.
    final textColor = colorScale.textSubtle;
    final textStyle = theme.typography.bodyMd.copyWith(color: textColor);

    // Ikonstørrelse og avstand drives av tokens i stedet for hardkodede tall.
    final iconSize = theme.typography.bodyMd.fontSize;
    final gap = theme.sizeTokens.size2;

    final content = Padding(
      // Avstand fra feltet over. Drives av et size-token.
      padding: EdgeInsets.only(top: theme.sizeTokens.size1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ikonet er dekorativt; selve meldingen leses som tekst.
          Padding(
            padding: EdgeInsets.only(right: gap),
            child: Icon(
              _severityIcon(severity),
              size: iconSize,
              color: textColor,
            ),
          ),
          Flexible(child: Text(message, style: textStyle)),
        ],
      ),
    );

    // Annonsér feil/advarsel automatisk via et liveRegion. Suksess- og
    // info-meldinger trenger ikke avbryte skjermleseren.
    final announce =
        severity == DsSeverity.danger || severity == DsSeverity.warning;
    if (announce) {
      return Semantics(liveRegion: true, child: content);
    }
    return content;
  }
}
