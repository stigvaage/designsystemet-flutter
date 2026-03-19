import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import 'helpers/color_scope_addon.dart';
import 'helpers/size_scope_addon.dart';
import 'helpers/theme_addon.dart';
import 'widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: widgetbookComponents,
      addons: [DsThemeAddon(), DsColorScopeAddon(), DsSizeScopeAddon()],
    );
  }
}
