import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final tableComponent = WidgetbookComponent(
  name: 'DsTable',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: DsTable(
          columns: ['Navn', 'Epost', 'Rolle'],
          rows: [
            ['Ola Nordmann', 'ola@example.no', 'Admin'],
            ['Kari Hansen', 'kari@example.no', 'Bruker'],
            ['Per Olsen', 'per@example.no', 'Redaktør'],
          ],
        ),
      ),
    ),
  ],
);
