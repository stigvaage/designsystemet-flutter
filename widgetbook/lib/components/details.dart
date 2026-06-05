import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

final detailsComponent = WidgetbookComponent(
  name: 'DsDetails',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final variant = context.knobs.object.dropdown(
          label: 'Variant',
          options: DsDetailsVariant.values,
          initialOption: DsDetailsVariant.default_,
          labelBuilder: (v) => v.name,
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsDetails(
            variant: variant,
            summary: const Text('Klikk for å se mer'),
            child: const Text(
              'Skjult innhold vises her når panelet er utvidet.',
            ),
          ),
        );
      },
    ),
  ],
);
