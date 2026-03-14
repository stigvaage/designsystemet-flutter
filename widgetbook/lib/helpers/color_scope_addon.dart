import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

class DsColorScopeAddon extends WidgetbookAddon<DsColor> {
  DsColorScopeAddon()
      : super(
          name: 'Fargeskala',
        );

  static final _colors = <String, DsColor>{
    'Accent': DsColor.accent,
    'Neutral': DsColor.neutral,
    'Brand 1': DsColor.brand1,
    'Brand 2': DsColor.brand2,
    'Brand 3': DsColor.brand3,
    'Success': DsColor.success,
    'Danger': DsColor.danger,
    'Warning': DsColor.warning,
    'Info': DsColor.info,
  };

  @override
  List<Field> get fields => [
        ObjectDropdownField<String>(
          name: 'Fargeskala',
          values: _colors.keys.toList(),
          initialValue: 'Accent',
          labelBuilder: (value) => value.toString(),
        ),
      ];

  @override
  DsColor valueFromQueryGroup(Map<String, String> group) {
    final name = group['Fargeskala'] ?? 'Accent';
    return _colors[name] ?? DsColor.accent;
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    DsColor setting,
  ) {
    return DsColorScope(
      color: setting,
      child: child,
    );
  }
}
