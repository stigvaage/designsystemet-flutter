import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _SwitchPreview extends StatefulWidget {
  const _SwitchPreview({required this.readOnly});
  final bool readOnly;

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

        return _SwitchPreview(readOnly: readOnly);
      },
    ),
  ],
);
