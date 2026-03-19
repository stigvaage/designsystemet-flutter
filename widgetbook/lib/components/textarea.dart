import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final textareaComponent = WidgetbookComponent(
  name: 'DsTextarea',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final hasError = context.knobs.boolean(
          label: 'Feil',
          initialValue: false,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsTextarea(
            rows: 4,
            disabled: disabled,
            error: hasError ? 'Obligatorisk felt' : null,
          ),
        );
      },
    ),
  ],
);
