import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final dialogComponent = WidgetbookComponent(
  name: 'DsDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: DsDialog(
          title: Text('Bekreft handling'),
          child: Text('Er du sikker på at du vil fortsette?'),
        ),
      ),
    ),
  ],
);
