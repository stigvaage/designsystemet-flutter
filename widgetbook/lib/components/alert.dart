import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final alertComponent = WidgetbookComponent(
  name: 'DsAlert',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final severity = context.knobs.object.dropdown(
          label: 'Alvorlighetsgrad',
          options: DsSeverity.values,
          initialOption: DsSeverity.info,
          labelBuilder: (v) => v.name,
        );
        final closable = context.knobs.boolean(label: 'Lukkbar', initialValue: false);
        final showTitle = context.knobs.boolean(label: 'Vis tittel', initialValue: true);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: DsAlert(
            severity: severity,
            closable: closable,
            title: showTitle ? const Text('Varselmelding') : null,
            child: const Text('Dette er en melding til brukeren.'),
          ),
        );
      },
    ),
  ],
);
