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
          columns: [Text('Navn'), Text('Epost'), Text('Rolle')],
          rows: [
            [Text('Ola Nordmann'), Text('ola@example.no'), Text('Admin')],
            [Text('Kari Hansen'), Text('kari@example.no'), Text('Bruker')],
            [Text('Per Olsen'), Text('per@example.no'), Text('Redaktør')],
          ],
        ),
      ),
    ),
  ],
);
