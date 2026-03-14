import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

class DsThemeAddon extends WidgetbookAddon<DsThemeData> {
  DsThemeAddon()
      : super(
          name: 'Tema',
        );

  final _themes = {
    'Lys (Light)': DsThemeDigdir.light(),
    'Mørk (Dark)': DsThemeDigdir.dark(),
  };

  @override
  List<Field> get fields => [
        ObjectDropdownField<String>(
          name: 'Tema',
          values: _themes.keys.toList(),
          initialValue: _themes.keys.first,
          labelBuilder: (value) => value.toString(),
        ),
      ];

  @override
  DsThemeData valueFromQueryGroup(Map<String, String> group) {
    final themeName = group['Tema'] ?? _themes.keys.first;
    return _themes[themeName] ?? DsThemeDigdir.light();
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    DsThemeData setting,
  ) {
    return DsTheme(
      data: setting,
      child: ColoredBox(
        color: setting.colorScheme.neutral.backgroundDefault,
        child: child,
      ),
    );
  }
}
