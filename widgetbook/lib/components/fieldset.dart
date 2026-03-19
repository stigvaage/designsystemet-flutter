import 'package:flutter/widgets.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final fieldsetComponent = WidgetbookComponent(
  name: 'DsFieldset',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: DsFieldset(
          legend: 'Personopplysninger',
          children: [
            DsField(label: 'Fornavn', child: DsTextfield()),
            SizedBox(height: 12),
            DsField(label: 'Etternavn', child: DsTextfield()),
          ],
        ),
      ),
    ),
  ],
);
