import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final linkComponent = WidgetbookComponent(
  name: 'DsLink',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final inverted = context.knobs.boolean(label: 'Invertert', initialValue: false);
        return Center(
          child: DsLink(
            text: 'Gå til designsystemet.no',
            inverted: inverted,
            onTap: () {},
          ),
        );
      },
    ),
  ],
);
