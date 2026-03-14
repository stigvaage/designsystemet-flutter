import 'package:flutter/widgets.dart';
import 'ds_theme_data.dart';

class DsTheme extends InheritedWidget {
  const DsTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final DsThemeData data;

  static DsThemeData of(BuildContext context) {
    final theme = maybeOf(context);
    if (theme == null) {
      throw FlutterError.fromParts([
        ErrorSummary('No DsTheme found in the widget tree.'),
        ErrorDescription(
          'DsTheme.of() was called with a context that does not contain a DsTheme widget.\n'
          'No DsTheme ancestor could be found starting from the context that was passed to '
          'DsTheme.of().',
        ),
        ErrorHint(
          'Wrap your app or widget subtree with a DsTheme widget:\n'
          '  DsTheme(\n'
          '    data: DsThemeDigdir.light(),\n'
          '    child: MyApp(),\n'
          '  )',
        ),
        context.describeElement('The context used was'),
      ]);
    }
    return theme;
  }

  static DsThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<DsTheme>();
    return widget?.data;
  }

  @override
  bool updateShouldNotify(DsTheme oldWidget) => data != oldWidget.data;
}
