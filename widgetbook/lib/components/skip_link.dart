import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final skipLinkComponent = WidgetbookComponent(
  name: 'DsSkipLink',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => Center(
        child: DsSkipLink(
          label: 'Hopp til hovedinnhold',
          onActivate: () {},
        ),
      ),
    ),
  ],
);
