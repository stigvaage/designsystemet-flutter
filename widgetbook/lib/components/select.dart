import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _SelectPreview extends StatefulWidget {
  const _SelectPreview({required this.disabled, required this.error});
  final bool disabled;
  final String? error;

  @override
  State<_SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<_SelectPreview> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DsSelect(
        items: const ['Oslo', 'Bergen', 'Trondheim', 'Stavanger'],
        selectedIndex: _selectedIndex,
        placeholder: 'Velg by',
        disabled: widget.disabled,
        error: widget.error,
        onChanged: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

final selectComponent = WidgetbookComponent(
  name: 'DsSelect',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final disabled = context.knobs.boolean(
          label: 'Deaktivert',
          initialValue: false,
        );
        final hasError = context.knobs.boolean(
          label: 'Feil',
          initialValue: false,
        );
        return _SelectPreview(
          disabled: disabled,
          error: hasError ? 'Velg en by' : null,
        );
      },
    ),
  ],
);
