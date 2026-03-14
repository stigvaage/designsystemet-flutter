import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final tagComponent = WidgetbookComponent(
  name: 'DsTag',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final text = context.knobs.string(label: 'Tekst', initialValue: 'Etikett');
        return Center(child: DsTag(child: Text(text)));
      },
    ),
  ],
);
