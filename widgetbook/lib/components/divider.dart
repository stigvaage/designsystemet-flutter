import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final dividerComponent = WidgetbookComponent(
  name: 'DsDivider',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final vertical = context.knobs.boolean(
          label: 'Vertikal',
          initialValue: false,
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: vertical ? 100 : null,
            child: DsDivider(vertical: vertical),
          ),
        );
      },
    ),
  ],
);
