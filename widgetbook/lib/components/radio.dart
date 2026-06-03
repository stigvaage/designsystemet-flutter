import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _RadioPreview extends StatefulWidget {
  const _RadioPreview({required this.readOnly});
  final bool readOnly;

  @override
  State<_RadioPreview> createState() => _RadioPreviewState();
}

class _RadioPreviewState extends State<_RadioPreview> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: DsRadio(
                value: _selectedIndex == i,
                readOnly: widget.readOnly,
                onChanged: (_) => setState(() => _selectedIndex = i),
                label: Text('Alternativ ${String.fromCharCode(65 + i)}'),
              ),
            ),
        ],
      ),
    );
  }
}

final radioComponent = WidgetbookComponent(
  name: 'DsRadio',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final readOnly = context.knobs.boolean(
          label: 'Skrivebeskyttet',
          initialValue: false,
        );

        return _RadioPreview(readOnly: readOnly);
      },
    ),
  ],
);
