import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
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
        final size = context.knobs.object.dropdown(
          label: 'Størrelse',
          options: DsSize.values,
          initialOption: DsSize.md,
          labelBuilder: (v) => v.name,
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
            size: size,
            error: hasError ? 'Ugyldig e-postadresse' : null,
            child: const DsTextfield(),
          ),
        );
      },
    ),
  ],
);
