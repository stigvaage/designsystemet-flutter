import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final tabsComponent = WidgetbookComponent(
  name: 'DsTabs',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: DsTabs(
          tabs: ['Oversikt', 'Detaljer', 'Innstillinger'],
          children: [
            Text('Oversiktsinnhold'),
            Text('Detaljinnhold'),
            Text('Innstillinger'),
          ],
        ),
      ),
    ),
  ],
);
