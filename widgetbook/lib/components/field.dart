import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final fieldComponent = WidgetbookComponent(
  name: 'DsField',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Etikett',
          initialValue: 'E-post',
        );
        final description = context.knobs.string(
          label: 'Beskrivelse',
          initialValue: 'Skriv inn e-postadressen din',
        );
        final hasError = context.knobs.boolean(
          label: 'Feil',
          initialValue: false,
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsField(
            label: label,
            description: description,
            error: hasError ? 'Ugyldig e-postadresse' : null,
            child: const DsTextfield(),
          ),
        );
      },
    ),
  ],
);
