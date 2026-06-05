import 'package:flutter/widgets.dart';
import '../theme/ds_color_scope.dart';
import '../theme/ds_theme.dart';
import '../theme/ds_typography.dart';
import '../utils/ds_enums.dart';

/// Overskriftskomponent som bruker Designsystemets typografi-tokens.
///
/// Den offisielle `Heading` har to uavhengige egenskaper: et semantisk
/// overskriftsnivå (HTML `h1`–`h6`) og en visuell størrelse (`data-size`).
/// [DsHeading] speiler dette med [level] for den visuelle størrelsen og
/// [semanticLevel] (1–6) for det semantiske overskriftsnivået som annonseres
/// til skjermlesere via `Semantics(headingLevel:)`.
class DsHeading extends StatelessWidget {
  const DsHeading({
    super.key,
    required this.text,
    this.level = DsHeadingLevel.md,
    this.semanticLevel = 2,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : assert(
         semanticLevel >= 1 && semanticLevel <= 6,
         'semanticLevel må være mellom 1 og 6',
       );

  /// Overskriftsteksten som vises.
  final String text;

  /// Den visuelle størrelsen på overskriften (styrer typografi-token).
  ///
  /// Tilsvarer den offisielle `data-size`-egenskapen og påvirker kun det
  /// visuelle uttrykket, ikke det semantiske overskriftsnivået.
  final DsHeadingLevel level;

  /// Det semantiske overskriftsnivået (1–6) som annonseres til skjermlesere.
  ///
  /// Tilsvarer den offisielle `level`-egenskapen (HTML `h1`–`h6`, standard 2).
  /// Settes uavhengig av den visuelle [level]-størrelsen.
  final int semanticLevel;

  /// Valgfri overstyring av fargetema; faller tilbake til [DsColorScope].
  final DsColor? color;

  /// Horisontal justering av overskriftsteksten.
  final TextAlign? textAlign;

  /// Maksimalt antall linjer før avkutting.
  final int? maxLines;

  /// Hvordan tekst som ikke får plass håndteres.
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final style = _resolveStyle(
      theme.typography,
    ).copyWith(color: colorScale.textDefault);

    return Semantics(
      header: true,
      headingLevel: semanticLevel,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  TextStyle _resolveStyle(DsTypography typography) {
    return switch (level) {
      DsHeadingLevel.xxl => typography.heading2xl,
      DsHeadingLevel.xl => typography.headingXl,
      DsHeadingLevel.lg => typography.headingLg,
      DsHeadingLevel.md => typography.headingMd,
      DsHeadingLevel.sm => typography.headingSm,
      DsHeadingLevel.xs => typography.headingXs,
      DsHeadingLevel.xxs => typography.heading2xs,
    };
  }
}
