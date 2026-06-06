import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

final searchComponent = WidgetbookComponent(
  name: 'DsSearch',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final clearable = context.knobs.boolean(
          label: 'Tømmbar',
          initialValue: false,
        );
        final clearLabel = context.knobs.string(
          label: 'Tøm-etikett',
          initialValue: 'Tøm',
        );
        // Tom streng faller tilbake til komponentens norske standard «Søk...».
        final placeholder = context.knobs.string(
          label: 'Plassholder',
          initialValue: '',
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsSearch(
            placeholder: placeholder.isEmpty ? null : placeholder,
            clearable: clearable,
            clearLabel: clearLabel,
          ),
        );
      },
    ),
  ],
);
