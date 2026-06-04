import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _ChipPreview extends StatefulWidget {
  const _ChipPreview({
    required this.removable,
    required this.disabled,
    required this.size,
  });
  final bool removable;
  final bool disabled;
  final DsSize size;

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
        disabled: widget.disabled,
        size: widget.size,
        onTap: widget.disabled
            ? null
            : () => setState(() => _selected = !_selected),
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
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final size = context.knobs.object.dropdown(
          label: 'Størrelse',
          options: DsSize.values,
          initialOption: DsSize.md,
          labelBuilder: (v) => v.name,
        );
        return _ChipPreview(
          removable: removable,
          disabled: disabled,
          size: size,
        );
      },
    ),
  ],
);
