import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final cardComponent = WidgetbookComponent(
  name: 'DsCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final elevated = context.knobs.boolean(label: 'Opphøyd', initialValue: false);
        final clickable = context.knobs.boolean(label: 'Klikkbar', initialValue: false);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsCard(
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
