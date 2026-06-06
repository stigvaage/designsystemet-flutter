import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _DropdownPreview extends StatefulWidget {
  const _DropdownPreview();

  @override
  State<_DropdownPreview> createState() => _DropdownPreviewState();
}

class _DropdownPreviewState extends State<_DropdownPreview> {
  String _selected = 'Åpne meny ▾';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DsDropdown(
        trigger: Text(_selected),
        items: const [
          DsDropdownItem(label: 'Alternativ 1'),
          DsDropdownItem(label: 'Alternativ 2'),
          DsDropdownItem(label: 'Alternativ 3'),
        ],
        onSelected: (index) {
          setState(() {
            _selected = ['Alternativ 1', 'Alternativ 2', 'Alternativ 3'][index];
          });
        },
      ),
    );
  }
}

final dropdownComponent = WidgetbookComponent(
  name: 'DsDropdown',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const _DropdownPreview(),
    ),
  ],
);
