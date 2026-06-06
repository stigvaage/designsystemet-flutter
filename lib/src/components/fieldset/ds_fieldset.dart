import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// Grupperer relaterte skjemaelementer under en synlig [legend]-overskrift.
///
/// Speiler det offisielle Designsystemet sitt `Fieldset`: en kantløs gruppe med
/// en `Legend` (overskrift) og en valgfri [description] (hjelpetekst) over de
/// grupperte feltene. Legenden eksponeres som gruppens overskrift for
/// skjermlesere, slik at hvert felt i gruppen leses i riktig kontekst.
class DsFieldset extends StatelessWidget {
  /// Oppretter et feltsett med en [legend]-overskrift over [children].
  const DsFieldset({
    super.key,
    required this.legend,
    required this.children,
    this.description,
    this.size,
    this.color,
  });

  /// Overskrift for gruppen av skjemaelementer. Eksponeres som gruppens
  /// overskrift (heading) for skjermlesere.
  final String legend;

  /// Skjemaelementene som grupperes.
  final List<Widget> children;

  /// Valgfri hjelpetekst som vises under [legend] og gir utfyllende kontekst
  /// for hele gruppen. `null` betyr ingen hjelpetekst.
  final String? description;

  /// Størrelse på feltsettet. Styrer typografi og avstander. Faller tilbake til
  /// nærmeste [DsSizeScope] (eller [DsSize.md]) når den er `null`.
  final DsSize? size;

  /// Fargetema for feltsettet. Faller tilbake til nærmeste [DsColorScope] når
  /// den er `null`.
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    // Løs feltsett-størrelsen på samme måte som [DsField] slik at legend,
    // beskrivelse og avstander skalerer i takt med resten av skjemaet.
    final sizeMode = size ?? DsSizeScope.of(context);

    // Skaler legend- og beskrivelsestypografien med størrelsen, i tråd med
    // body-mappingen som brukes ellers i biblioteket (sm→bodyMd osv.).
    final legendStyle = sizeMode.pick(
      sm: theme.typography.bodyMd,
      md: theme.typography.bodyLg,
      lg: theme.typography.bodyXl,
    );
    final descriptionStyle = sizeMode.pick(
      sm: theme.typography.bodySm,
      md: theme.typography.bodyMd,
      lg: theme.typography.bodyLg,
    );

    // Token-baserte avstander (step = 4): size2 = 8, size3 = 12, size4 = 16.
    final tokens = theme.sizeTokens;
    final legendGap = sizeMode.pick(
      sm: tokens.size1,
      md: tokens.size2,
      lg: tokens.size2,
    );
    final contentGap = sizeMode.pick(
      sm: tokens.size2,
      md: tokens.size3,
      lg: tokens.size4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Den synlige legenden er den eneste kilden til gruppens tilgjengelige
        // navn, og merkes som overskrift (header) slik at skjermlesere
        // annonserer den én gang som gruppens overskrift — på linje med
        // header-semantikken i [DsTable].
        Semantics(
          header: true,
          child: Text(
            legend,
            style: legendStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScale.textDefault,
            ),
          ),
        ),
        if (description != null) ...[
          SizedBox(height: legendGap),
          Text(
            description!,
            style: descriptionStyle.copyWith(
              color: theme.colorScheme.neutral.textSubtle,
            ),
          ),
        ],
        SizedBox(height: contentGap),
        ...children,
      ],
    );
  }
}
