import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
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
        // Tom streng faller tilbake til navnebasert standardetikett.
        final semanticLabel = context.knobs.string(
          label: 'Tilgjengelighetsetikett',
          initialValue: '',
        );
        return Center(
          child: DsAvatar(
            name: name,
            semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
          ),
        );
      },
    ),
  ],
);

final avatarStackComponent = WidgetbookComponent(
  name: 'DsAvatarStack',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final size = context.knobs.object.dropdown(
          label: 'Størrelse',
          options: DsSize.values,
          initialOption: DsSize.md,
          labelBuilder: (v) => v.name,
        );
        return Center(
          child: DsAvatarStack(
            size: size,
            children: const [
              DsAvatar(name: 'Ola Nordmann'),
              DsAvatar(name: 'Kari Hansen'),
              DsAvatar(name: 'Per Olsen'),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Med overflyt («+N»)',
      builder: (context) {
        final size = context.knobs.object.dropdown(
          label: 'Størrelse',
          options: DsSize.values,
          initialOption: DsSize.md,
          labelBuilder: (v) => v.name,
        );
        final max = context.knobs.int.slider(
          label: 'Maks synlige',
          initialValue: 3,
          min: 1,
          max: 6,
        );
        return Center(
          child: DsAvatarStack(
            size: size,
            max: max,
            children: const [
              DsAvatar(name: 'Ola Nordmann'),
              DsAvatar(name: 'Kari Hansen'),
              DsAvatar(name: 'Per Olsen'),
              DsAvatar(name: 'Liv Berg'),
              DsAvatar(name: 'Nils Dahl'),
              DsAvatar(name: 'Eva Lund'),
            ],
          ),
        );
      },
    ),
  ],
);
