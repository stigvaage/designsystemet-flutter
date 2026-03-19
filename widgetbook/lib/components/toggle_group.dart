import 'package:flutter/widgets.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final toggleGroupComponent = WidgetbookComponent(
  name: 'DsToggleGroup',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => Center(
        child: DsToggleGroup(
          items: const ['Dag', 'Uke', 'Måned'],
          selectedIndex: 0,
          onChanged: (_) {},
        ),
      ),
    ),
  ],
);
