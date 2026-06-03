import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _ToggleGroupPreview extends StatefulWidget {
  const _ToggleGroupPreview();

  @override
  State<_ToggleGroupPreview> createState() => _ToggleGroupPreviewState();
}

class _ToggleGroupPreviewState extends State<_ToggleGroupPreview> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DsToggleGroup(
        items: const ['Dag', 'Uke', 'Måned'],
        selectedIndex: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

final toggleGroupComponent = WidgetbookComponent(
  name: 'DsToggleGroup',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const _ToggleGroupPreview(),
    ),
  ],
);
