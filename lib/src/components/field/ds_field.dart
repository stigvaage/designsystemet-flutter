import 'package:flutter/widgets.dart';

import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../typography/ds_label.dart';
import '../../typography/ds_validation_message.dart';
import '../../utils/ds_enums.dart';

/// Form field wrapper that composes a label, description, input, and validation message.
///
/// Place any input widget (e.g. [DsTextfield], [DsCheckbox]) as [child].
/// When [error] is set, a [DsValidationMessage] is shown below the input.
class DsField extends StatelessWidget {
  const DsField({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.error,
    this.size,
  });

  final Widget child;
  final String? label;
  final String? description;
  final String? error;
  final DsSize? size;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);

    // Resolve the field size the same way [DsLabel] does so label, description
    // and validation message all scale together. Matches the official
    // Designsystemet `data-size` cascade across the whole field.
    final sizeMode = size ?? DsSizeScope.of(context);

    // Same body-size mapping that [DsLabel] applies: sm→bodyMd, md→bodyLg,
    // lg→bodyXl. This keeps description and validation text in step with the
    // scaling label instead of being pinned to bodyMd.
    final bodyStyle = sizeMode.pick(
      sm: theme.typography.bodyMd,
      md: theme.typography.bodyLg,
      lg: theme.typography.bodyXl,
    );

    // [DsValidationMessage] pins its own text to bodyMd and takes no size
    // parameter, so scale it proportionally to the resolved field size
    // (bodyMd → 1.0, bodyLg → 1.125, bodyXl → 1.25). This is applied on top of
    // any user text scaling so accessibility settings are still respected.
    final validationScale = sizeMode.pick(sm: 1.0, md: 1.125, lg: 1.25);

    // Compose the field's hint from the description and the error so a focused
    // input announces help text and the validation problem together. Both are
    // optional, so the hint is null when neither is present.
    final hint = [description, error].whereType<String>().join('. ').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            // The visible label is decorative for assistive tech: its content is
            // re-exposed programmatically as the input's accessible name via the
            // [Semantics] wrapper below, so it is hidden here to avoid a
            // duplicate, detached announcement.
            child: ExcludeSemantics(
              child: DsLabel(text: label!, size: sizeMode),
            ),
          ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            // Likewise excluded: the description is surfaced as part of the
            // input's hint below instead of as a separate text node.
            child: ExcludeSemantics(
              child: Text(
                description!,
                style: bodyStyle.copyWith(
                  color: theme.colorScheme.neutral.textSubtle,
                ),
              ),
            ),
          ),
        // Associate the label, description and error with the input for
        // assistive technologies. [MergeSemantics] folds this name/hint into the
        // wrapped input's own semantics node (e.g. [DsInput]'s `textField`
        // node), so a screen reader announces "label, value, help. error" as a
        // single field instead of disconnected siblings. [DsFieldScope] also
        // forwards the same values down so input components can refine their own
        // semantics if needed.
        MergeSemantics(
          child: Semantics(
            label: label,
            hint: hint.isEmpty ? null : hint,
            child: DsFieldScope(
              label: label,
              description: description,
              error: error,
              child: child,
            ),
          ),
        ),
        if (error != null)
          MediaQuery(
            // Compose the field size factor with the user's current text
            // scaler so the validation message scales with the field while
            // still honouring accessibility text-scaling settings.
            data: MediaQuery.of(context).copyWith(
              textScaler: _ScaledTextScaler(
                MediaQuery.textScalerOf(context),
                validationScale,
              ),
            ),
            // Announce valid → invalid transitions to assistive technologies the
            // moment the message appears. The [DsValidationMessage] itself
            // carries the danger styling.
            child: Semantics(
              liveRegion: true,
              child: DsValidationMessage(message: error!),
            ),
          ),
      ],
    );
  }
}

/// A [TextScaler] that multiplies an [inner] scaler by a fixed [factor].
///
/// Used to apply the field's size step to [DsValidationMessage] (which pins
/// its own text to `bodyMd`) without discarding the user's accessibility text
/// scaling carried by [inner].
class _ScaledTextScaler extends TextScaler {
  const _ScaledTextScaler(this.inner, this.factor);

  final TextScaler inner;
  final double factor;

  @override
  double scale(double fontSize) => inner.scale(fontSize) * factor;

  // Derives the legacy factor from [scale] so the deprecated
  // [TextScaler.textScaleFactor] getter is never read directly.
  @override
  double get textScaleFactor => inner.scale(1.0) * factor;

  @override
  bool operator ==(Object other) =>
      other is _ScaledTextScaler &&
      other.inner == inner &&
      other.factor == factor;

  @override
  int get hashCode => Object.hash(inner, factor);
}

/// Eksponerer den omsluttende [DsField]-tilstanden ([label], [description] og
/// [error]) for inndata-widgets lenger ned i treet.
///
/// Inndatakomponenter (f.eks. [DsInput]/[DsTextfield], [DsCheckbox]) leser
/// [DsFieldScope.of] for å gjengi feiltilstand (rød kantlinje) i takt med
/// feltets valideringsmelding, og kan i tillegg forbedre sin egen semantikk med
/// feltets etikett og beskrivelse. Returnerer `null` når det ikke finnes en
/// omsluttende [DsField].
class DsFieldScope extends InheritedWidget {
  /// Oppretter et scope som videreformidler [label], [description] og [error]
  /// til etterkommere. Bare [error] er påkrevd av hensyn til bakoverkompatible
  /// kallsteder; [label] og [description] er valgfrie og `null` som standard.
  const DsFieldScope({
    super.key,
    required this.error,
    this.label,
    this.description,
    required super.child,
  });

  /// Feltets etikett, eller `null` når feltet ikke har en etikett. Inndatafelt
  /// kan bruke denne som sitt tilgjengelige navn (accessible name).
  final String? label;

  /// Feltets hjelpetekst, eller `null` når feltet ikke har beskrivelse.
  /// Inndatafelt kan eksponere denne som en del av sitt hint.
  final String? description;

  /// Gjeldende valideringsfeil, eller `null` når feltet er gyldig.
  final String? error;

  /// Returnerer nærmeste omsluttende [DsFieldScope], eller `null` hvis ingen
  /// finnes.
  static DsFieldScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DsFieldScope>();

  @override
  bool updateShouldNotify(DsFieldScope oldWidget) =>
      error != oldWidget.error ||
      label != oldWidget.label ||
      description != oldWidget.description;
}
