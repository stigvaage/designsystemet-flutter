import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final errorSummaryComponent = WidgetbookComponent(
  name: 'DsErrorSummary',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: DsErrorSummary(
          title: 'Rett følgende feil',
          errors: [
            'Fornavn er påkrevd',
            'E-post er ugyldig',
            'Velg minst ett alternativ',
          ],
        ),
      ),
    ),
  ],
);
