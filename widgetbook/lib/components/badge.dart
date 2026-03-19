import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final badgeComponent = WidgetbookComponent(
  name: 'DsBadge',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final count = context.knobs.double
            .slider(label: 'Antall', min: 0, max: 99, initialValue: 3)
            .toInt();
        final overlap = context.knobs.boolean(
          label: 'Overlapp',
          initialValue: false,
        );
        return Center(
          child: DsBadge(
            count: count,
            overlap: overlap,
            child: const DsAvatar(name: 'Ola Nordmann'),
          ),
        );
      },
    ),
  ],
);
