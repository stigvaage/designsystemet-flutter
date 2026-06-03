import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _CheckboxPreview extends StatefulWidget {
  const _CheckboxPreview({required this.readOnly});
  final bool readOnly;

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

        return _CheckboxPreview(readOnly: readOnly);
      },
    ),
  ],
);
