import 'package:flutter/widgets.dart';
import 'ds_theme_data.dart';

/// Provides [DsThemeData] to all Designsystemet components in the widget tree.
///
/// Wrap your app or a subtree with [DsTheme] to supply design tokens.
/// Retrieve the active theme with [DsTheme.of].
///
/// [DsTheme] arver fra [InheritedTheme] slik at temaet kan fanges og bæres over
/// rutegrenser (dialoger, overlays) med [InheritedTheme.capture]/[wrap] — på
/// samme måte som Flutter sitt eget Material `Theme`.
class DsTheme extends InheritedTheme {
  /// Oppretter et [DsTheme] som eksponerer [data] for etterkommere.
  const DsTheme({super.key, required this.data, required super.child});

  /// Det aktive token-settet for dette subtreet.
  final DsThemeData data;

  /// Returnerer nærmeste [DsThemeData]; kaster hvis ingen [DsTheme] finnes.
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

  /// Returnerer nærmeste [DsThemeData], eller null hvis ingen [DsTheme] finnes.
  static DsThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<DsTheme>();
    return widget?.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      DsTheme(data: data, child: child);

  @override
  bool updateShouldNotify(DsTheme oldWidget) => data != oldWidget.data;
}
