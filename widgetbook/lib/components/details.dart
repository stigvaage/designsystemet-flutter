import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final detailsComponent = WidgetbookComponent(
  name: 'DsDetails',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: DsDetails(
            summary: Text('Klikk for å se mer'),
            child: Text('Skjult innhold vises her når panelet er utvidet.'),
          ),
        );
      },
    ),
  ],
);
