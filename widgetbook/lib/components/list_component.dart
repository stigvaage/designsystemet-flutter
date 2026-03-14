import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final listComponent = WidgetbookComponent(
  name: 'DsList',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final ordered = context.knobs.boolean(label: 'Nummerert', initialValue: false);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsList(
            ordered: ordered,
            items: const [Text('Første element'), Text('Andre element'), Text('Tredje element')],
          ),
        );
      },
    ),
  ],
);
