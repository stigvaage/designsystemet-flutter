import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final buttonComponent = WidgetbookComponent(
  name: 'DsButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final variant = context.knobs.object.dropdown(
          label: 'Variant',
          options: DsButtonVariant.values,
          initialOption: DsButtonVariant.primary,
          labelBuilder: (v) => v.name,
        );
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final loading = context.knobs.boolean(
          label: 'Laster',
          initialValue: false,
        );
        final text = context.knobs.string(
          label: 'Tekst',
          initialValue: 'Klikk her',
        );

        return Center(
          child: DsButton(
            variant: variant,
            disabled: disabled,
            loading: loading,
            onPressed: () {},
            child: Text(text),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Med ikon',
      builder: (context) {
        final variant = context.knobs.object.dropdown(
          label: 'Variant',
          options: DsButtonVariant.values,
          initialOption: DsButtonVariant.primary,
          labelBuilder: (v) => v.name,
        );
        final iconPosition = context.knobs.object.dropdown(
          label: 'Ikonplassering',
          options: DsIconPosition.values,
          initialOption: DsIconPosition.left,
          labelBuilder: (v) => v.name,
        );
        final text = context.knobs.string(
          label: 'Tekst',
          initialValue: 'Send inn',
        );

        return Center(
          child: DsButton(
            variant: variant,
            onPressed: () {},
            icon: const Icon(DsIcons.send),
            iconPosition: iconPosition,
            child: Text(text),
          ),
        );
      },
    ),
  ],
);
