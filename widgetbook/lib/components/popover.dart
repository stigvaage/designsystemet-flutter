import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final popoverComponent = WidgetbookComponent(
  name: 'DsPopover',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Center(
        child: DsPopover(
          trigger: Text('Klikk for popover'),
          content: Text('Innhold i popover-panelet.'),
        ),
      ),
    ),
  ],
);
