import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final switchComponent = WidgetbookComponent(
  name: 'DsSwitch',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final value = context.knobs.boolean(label: 'På', initialValue: false);
        final readOnly = context.knobs.boolean(
          label: 'Skrivebeskyttet',
          initialValue: false,
        );

        return Center(
          child: DsSwitch(value: value, readOnly: readOnly, onChanged: (_) {}),
        );
      },
    ),
  ],
);
