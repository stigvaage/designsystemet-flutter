import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final dropdownComponent = WidgetbookComponent(
  name: 'DsDropdown',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => Center(
        child: const DsDropdown(
          trigger: Text('Åpne meny ▾'),
          items: [
            DsDropdownItem(label: 'Alternativ 1'),
            DsDropdownItem(label: 'Alternativ 2'),
            DsDropdownItem(label: 'Alternativ 3'),
          ],
        ),
      ),
    ),
  ],
);
