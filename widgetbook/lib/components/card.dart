import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

final cardComponent = WidgetbookComponent(
  name: 'DsCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final variant = context.knobs.object.dropdown(
          label: 'Variant',
          options: DsCardVariant.values,
          initialOption: DsCardVariant.default_,
          labelBuilder: (v) => v.name,
        );
        final elevated = context.knobs.boolean(
          label: 'Opphøyd',
          initialValue: false,
        );
        final clickable = context.knobs.boolean(
          label: 'Klikkbar',
          initialValue: false,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsCard(
            variant: variant,
            elevated: elevated,
            onTap: clickable ? () {} : null,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DsCardHeader(child: Text('Korttittel')),
                DsCardBlock(child: Text('Innholdet i kortet vises her.')),
                DsCardFooter(child: Text('Bunntekst')),
              ],
            ),
          ),
        );
      },
    ),
  ],
);
