import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final checkboxComponent = WidgetbookComponent(
  name: 'DsCheckbox',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final checked = context.knobs.boolean(label: 'Avkrysset', initialValue: false);
        final indeterminate = context.knobs.boolean(label: 'Ubestemt', initialValue: false);
        final readOnly = context.knobs.boolean(label: 'Skrivebeskyttet', initialValue: false);

        return Center(
          child: DsCheckbox(
            value: checked,
            indeterminate: indeterminate,
            readOnly: readOnly,
            onChanged: (_) {},
            label: const Text('Jeg godtar vilkårene'),
          ),
        );
      },
    ),
  ],
);
