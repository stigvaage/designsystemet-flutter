import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final spinnerComponent = WidgetbookComponent(
  name: 'DsSpinner',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Center(child: DsSpinner()),
    ),
  ],
);
