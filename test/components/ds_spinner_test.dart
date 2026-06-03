import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsSpinner', () {
    testWidgets('defaults to "Laster inn" aria-label as a live region', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsSpinner()));
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Laster inn' &&
              w.properties.liveRegion == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses a custom ariaLabel when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSpinner(ariaLabel: 'Laster brukere …')),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Laster brukere …',
        ),
        findsOneWidget,
      );
    });
  });
}
