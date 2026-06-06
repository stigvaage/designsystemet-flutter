import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _SelectPreview extends StatefulWidget {
  const _SelectPreview({
    required this.disabled,
    required this.readOnly,
    required this.error,
    required this.semanticsLabel,
    this.initialValue,
  });
  final bool disabled;
  final bool readOnly;
  final String? error;
  final String semanticsLabel;
  final String? initialValue;

  @override
  State<_SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<_SelectPreview> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  static const _options = <DsSelectOption<String>>[
    DsSelectOption<String>(value: 'oslo', label: 'Oslo'),
    DsSelectOption<String>(value: 'bergen', label: 'Bergen'),
  ];

  static const _groups = <DsSelectOptgroup<String>>[
    DsSelectOptgroup<String>(
      label: 'Midt-Norge',
      options: [
        DsSelectOption<String>(value: 'trondheim', label: 'Trondheim'),
        DsSelectOption<String>(value: 'molde', label: 'Molde'),
      ],
    ),
    DsSelectOptgroup<String>(
      label: 'Vestlandet',
      options: [
        DsSelectOption<String>(value: 'stavanger', label: 'Stavanger'),
        DsSelectOption<String>(value: 'alesund', label: 'Ålesund'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DsSelect<String>(
        options: _options,
        groups: _groups,
        value: _value,
        placeholder: 'Velg by',
        disabled: widget.disabled,
        readOnly: widget.readOnly,
        error: widget.error,
        semanticsLabel: widget.semanticsLabel,
        onChanged: (value) => setState(() => _value = value),
      ),
    );
  }
}

final selectComponent = WidgetbookComponent(
  name: 'DsSelect',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final readOnly = context.knobs.boolean(
          label: 'Skrivebeskyttet',
          initialValue: false,
        );
        final hasError = context.knobs.boolean(
          label: 'Feil',
          initialValue: false,
        );
        final semanticsLabel = context.knobs.string(
          label: 'Tilgjengelighetsetikett',
          initialValue: 'Velg',
        );
        return _SelectPreview(
          disabled: disabled,
          readOnly: readOnly,
          error: hasError ? 'Velg en by' : null,
          semanticsLabel: semanticsLabel,
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Skrivebeskyttet / deaktivert',
      builder: (context) {
        final mode = context.knobs.object.dropdown(
          label: 'Modus',
          options: const ['Skrivebeskyttet', 'Deaktivert'],
          initialOption: 'Skrivebeskyttet',
          labelBuilder: (v) => v,
        );
        return _SelectPreview(
          disabled: mode == 'Deaktivert',
          readOnly: mode == 'Skrivebeskyttet',
          error: null,
          semanticsLabel: 'Velg',
          initialValue: 'bergen',
        );
      },
    ),
  ],
);
