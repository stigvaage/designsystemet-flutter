import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _CheckboxPreview extends StatefulWidget {
  const _CheckboxPreview({
    required this.readOnly,
    required this.disabled,
    required this.description,
    required this.error,
  });
  final bool readOnly;
  final bool disabled;
  final String? description;
  final String? error;

  @override
  State<_CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<_CheckboxPreview> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DsCheckbox(
        value: _checked,
        readOnly: widget.readOnly,
        disabled: widget.disabled,
        description: widget.description == null
            ? null
            : Text(widget.description!),
        error: widget.error,
        onChanged: (v) => setState(() => _checked = v),
        label: const Text('Jeg godtar vilkårene'),
      ),
    );
  }
}

final checkboxComponent = WidgetbookComponent(
  name: 'DsCheckbox',
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
        final description = context.knobs.string(
          label: 'Beskrivelse',
          initialValue: '',
        );
        final hasError = context.knobs.boolean(
          label: 'Feil',
          initialValue: false,
        );

        return _CheckboxPreview(
          readOnly: readOnly,
          disabled: disabled,
          description: description.isEmpty ? null : description,
          error: hasError ? 'Du må godta vilkårene' : null,
        );
      },
    ),
  ],
);
