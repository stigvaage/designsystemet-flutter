import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final tooltipComponent = WidgetbookComponent(
  name: 'DsTooltip',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Center(
        child: DsTooltip(
          message: 'Hjelpetekst vises her',
          child: Text('Hold markøren over meg'),
        ),
      ),
    ),
  ],
);
