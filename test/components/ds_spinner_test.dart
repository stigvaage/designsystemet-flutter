import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child, {bool disableAnimations = false}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: DsTheme(
      data: DsThemeDigdir.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    ),
  );
}

/// Returns the painter currently driving the spinner's [CustomPaint].
///
/// The spinner rebuilds its painter every animation frame, so a stable
/// reference across pumps means the spinner is not animating.
CustomPainter spinnerPainter(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(DsSpinner),
      matching: find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter != null,
      ),
    ),
  );
  return paint.painter!;
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

    testWidgets('animates the painter when motion is enabled', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsSpinner()));

      final before = spinnerPainter(tester);
      // Advance the repeating controller; the spinner rebuilds its painter
      // every frame, so a fresh instance proves it is animating.
      await tester.pump(const Duration(milliseconds: 200));
      final after = spinnerPainter(tester);

      expect(
        identical(before, after),
        isFalse,
        reason: 'painter should be rebuilt each animation frame',
      );
    });

    testWidgets('does not animate when disableAnimations is set', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSpinner(), disableAnimations: true),
      );

      final before = spinnerPainter(tester);
      // With reduced motion the controller is stopped, so no rebuild happens
      // and the painter reference stays identical across pumps.
      await tester.pump(const Duration(milliseconds: 500));
      final after = spinnerPainter(tester);

      expect(
        identical(before, after),
        isTrue,
        reason: 'painter must not be rebuilt when animations are disabled',
      );
    });
  });
}
