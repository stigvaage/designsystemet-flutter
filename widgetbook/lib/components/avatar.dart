import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final avatarComponent = WidgetbookComponent(
  name: 'DsAvatar',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final name = context.knobs.string(
          label: 'Navn',
          initialValue: 'Ola Nordmann',
        );
        return Center(child: DsAvatar(name: name));
      },
    ),
  ],
);

final avatarStackComponent = WidgetbookComponent(
  name: 'DsAvatarStack',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Center(
        child: DsAvatarStack(
          children: [
            DsAvatar(name: 'Ola Nordmann'),
            DsAvatar(name: 'Kari Hansen'),
            DsAvatar(name: 'Per Olsen'),
          ],
        ),
      ),
    ),
  ],
);
