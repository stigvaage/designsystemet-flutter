import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final chipComponent = WidgetbookComponent(
  name: 'DsChip',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final selected = context.knobs.boolean(label: 'Valgt', initialValue: false);
        final removable = context.knobs.boolean(label: 'Fjernbar', initialValue: false);
        return Center(
          child: DsChip(
            selected: selected,
            removable: removable,
            child: const Text('Flutter'),
          ),
        );
      },
    ),
  ],
);
