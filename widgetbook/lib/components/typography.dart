import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final headingComponent = WidgetbookComponent(
  name: 'DsHeading',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final level = context.knobs.object.dropdown(
          label: 'Nivå',
          options: DsHeadingLevel.values,
          initialOption: DsHeadingLevel.md,
          labelBuilder: (v) => v.name,
        );
        final text = context.knobs.string(
          label: 'Tekst',
          initialValue: 'Overskrift',
        );
        return Center(
          child: DsHeading(text: text, level: level),
        );
      },
    ),
  ],
);

final paragraphComponent = WidgetbookComponent(
  name: 'DsParagraph',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final bodySize = context.knobs.object.dropdown(
          label: 'Størrelse',
          options: DsBodySize.values,
          initialOption: DsBodySize.md,
          labelBuilder: (v) => v.name,
        );
        final variant = context.knobs.object.dropdown(
          label: 'Variant',
          options: DsBodyVariant.values,
          initialOption: DsBodyVariant.standard,
          labelBuilder: (v) => v.name,
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsParagraph(
            text:
                'Dette er en eksempeltekst som viser hvordan brødtekst ser ut i Designsystemet.',
            bodySize: bodySize,
            variant: variant,
          ),
        );
      },
    ),
  ],
);

final labelComponent = WidgetbookComponent(
  name: 'DsLabel',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final text = context.knobs.string(
          label: 'Tekst',
          initialValue: 'Feltetikett',
        );
        return Center(child: DsLabel(text: text));
      },
    ),
  ],
);

final validationMessageComponent = WidgetbookComponent(
  name: 'DsValidationMessage',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final isError = context.knobs.boolean(
          label: 'Feil',
          initialValue: true,
        );
        return Center(
          child: DsValidationMessage(
            message: isError ? 'Dette feltet er påkrevd' : 'Gyldig verdi',
            isError: isError,
          ),
        );
      },
    ),
  ],
);
