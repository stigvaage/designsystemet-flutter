import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _SwitchPreview extends StatefulWidget {
  const _SwitchPreview({
    required this.readOnly,
    required this.disabled,
    required this.label,
    required this.description,
  });
  final bool readOnly;
  final bool disabled;
  final String? label;
  final String? description;

  @override
  State<_SwitchPreview> createState() => _SwitchPreviewState();
}

class _SwitchPreviewState extends State<_SwitchPreview> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DsSwitch(
        value: _value,
        readOnly: widget.readOnly,
        disabled: widget.disabled,
        label: widget.label == null ? null : Text(widget.label!),
        description: widget.description == null
            ? null
            : Text(widget.description!),
        onChanged: (v) => setState(() => _value = v),
      ),
    );
  }
}

final switchComponent = WidgetbookComponent(
  name: 'DsSwitch',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final readOnly = context.knobs.boolean(
          label: 'Skrivebeskyttet',
          initialValue: false,
        );
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final label = context.knobs.string(
          label: 'Etikett',
          initialValue: 'Varsler',
        );
        final description = context.knobs.string(
          label: 'Beskrivelse',
          initialValue: '',
        );

        return _SwitchPreview(
          readOnly: readOnly,
          disabled: disabled,
          label: label.isEmpty ? null : label,
          description: description.isEmpty ? null : description,
        );
      },
    ),
  ],
);
