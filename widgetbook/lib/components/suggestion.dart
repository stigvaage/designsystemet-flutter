import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

final suggestionComponent = WidgetbookComponent(
  name: 'DsSuggestion',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: DsSuggestion(
          items: ['Oslo', 'Bergen', 'Trondheim', 'Stavanger', 'Tromsø'],
        ),
      ),
    ),
  ],
);
