import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

final listComponent = WidgetbookComponent(
  name: 'DsList',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final ordered = context.knobs.boolean(
          label: 'Nummerert',
          initialValue: false,
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsList(
            ordered: ordered,
            items: const [
              Text('Første element'),
              Text('Andre element'),
              Text('Tredje element'),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Punktliste',
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: DsList(
            ordered: false,
            items: [
              Text('Første element'),
              Text('Andre element'),
              Text('Tredje element'),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Nummerert liste',
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: DsList(
            ordered: true,
            items: [
              Text('Første element'),
              Text('Andre element'),
              Text('Tredje element'),
            ],
          ),
        );
      },
    ),
  ],
);
