import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _ChipPreview extends StatefulWidget {
  const _ChipPreview({required this.removable});
  final bool removable;

  @override
  State<_ChipPreview> createState() => _ChipPreviewState();
}

class _ChipPreviewState extends State<_ChipPreview> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DsChip(
        selected: _selected,
        removable: widget.removable,
        onTap: () => setState(() => _selected = !_selected),
        onRemove: widget.removable ? () {} : null,
        child: const Text('Flutter'),
      ),
    );
  }
}

final chipComponent = WidgetbookComponent(
  name: 'DsChip',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final removable = context.knobs.boolean(
          label: 'Fjernbar',
          initialValue: false,
        );
        return _ChipPreview(removable: removable);
      },
    ),
  ],
);
