import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final textfieldComponent = WidgetbookComponent(
  name: 'DsTextfield',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final disabled = context.knobs.boolean(label: 'Deaktivert', initialValue: false);
        final readOnly = context.knobs.boolean(label: 'Skrivebeskyttet', initialValue: false);
        final hasError = context.knobs.boolean(label: 'Feil', initialValue: false);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsTextfield(
            disabled: disabled,
            readOnly: readOnly,
            error: hasError ? 'Vennligst fyll ut dette feltet' : null,
          ),
        );
      },
    ),
  ],
);
