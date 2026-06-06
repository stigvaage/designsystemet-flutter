import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _ToggleGroupPreview extends StatefulWidget {
  const _ToggleGroupPreview({this.disabled = false, this.disabledIndices});
  final bool disabled;
  final Set<int>? disabledIndices;

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
        disabled: widget.disabled,
        disabledIndices: widget.disabledIndices,
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
      builder: (context) {
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final disableMiddle = context.knobs.boolean(
          label: 'Deaktiver «Uke»-segment',
          initialValue: false,
        );
        return _ToggleGroupPreview(
          disabled: disabled,
          disabledIndices: disableMiddle ? const {1} : null,
        );
      },
    ),
  ],
);
