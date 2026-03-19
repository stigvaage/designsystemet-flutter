import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final radioComponent = WidgetbookComponent(
  name: 'DsRadio',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final selected = context.knobs.boolean(
          label: 'Valgt',
          initialValue: false,
        );
        final readOnly = context.knobs.boolean(
          label: 'Skrivebeskyttet',
          initialValue: false,
        );

        return Center(
          child: DsRadio(
            value: selected,
            readOnly: readOnly,
            onChanged: (_) {},
            label: const Text('Alternativ A'),
          ),
        );
      },
    ),
  ],
);
