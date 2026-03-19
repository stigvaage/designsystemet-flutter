import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final selectComponent = WidgetbookComponent(
  name: 'DsSelect',
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
          child: DsSelect(
            items: const ['Oslo', 'Bergen', 'Trondheim', 'Stavanger'],
            placeholder: 'Velg by',
            disabled: disabled,
            error: hasError ? 'Velg en by' : null,
          ),
        );
      },
    ),
  ],
);
