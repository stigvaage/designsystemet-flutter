import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

class DsSizeScopeAddon extends WidgetbookAddon<DsSize> {
  DsSizeScopeAddon()
      : super(
          name: 'Størrelse',
        );

  static final _sizes = <String, DsSize>{
    'Liten (sm)': DsSize.sm,
    'Medium (md)': DsSize.md,
    'Stor (lg)': DsSize.lg,
  };

  @override
  List<Field> get fields => [
        ObjectDropdownField<String>(
          name: 'Størrelse',
          values: _sizes.keys.toList(),
          initialValue: 'Medium (md)',
          labelBuilder: (value) => value.toString(),
        ),
      ];

  @override
  DsSize valueFromQueryGroup(Map<String, String> group) {
    final name = group['Størrelse'] ?? 'Medium (md)';
    return _sizes[name] ?? DsSize.md;
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    DsSize setting,
  ) {
    return DsSizeScope(
      size: setting,
      child: child,
    );
  }
}
