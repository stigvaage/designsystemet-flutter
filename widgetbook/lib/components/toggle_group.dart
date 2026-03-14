import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
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
