import 'package:flutter/widgets.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final suggestionComponent = WidgetbookComponent(
  name: 'DsSuggestion',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: const DsSuggestion(
          items: ['Oslo', 'Bergen', 'Trondheim', 'Stavanger', 'Tromsø'],
        ),
      ),
    ),
  ],
);
