import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

final errorSummaryComponent = WidgetbookComponent(
  name: 'DsErrorSummary',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final size = context.knobs.object.dropdown(
          label: 'Størrelse',
          options: DsSize.values,
          initialOption: DsSize.md,
          labelBuilder: (v) => v.name,
        );
        // Tom streng faller tilbake til komponentens norske standardtittel
        // «Du må rette opp følgende».
        final title = context.knobs.string(label: 'Tittel', initialValue: '');
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsErrorSummary(
            size: size,
            title: title.isEmpty ? null : title,
            errors: const [
              'Fornavn er påkrevd',
              'E-post er ugyldig',
              'Velg minst ett alternativ',
            ],
          ),
        );
      },
    ),
  ],
);
