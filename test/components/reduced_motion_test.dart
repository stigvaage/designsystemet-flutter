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

/// The current animation progress painted by the spinner.
///
/// Reaches into the spinner's [CustomPaint] and reads the painter's `progress`
/// field via the public [CustomPainter.shouldRepaint] contract: a painter only
/// repaints when its progress changes, so comparing two painters across a pump
/// tells us whether the arc actually moved.
CustomPainter _spinnerPainter(WidgetTester tester) {
  final customPaint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(DsSpinner),
      matching: find.byType(CustomPaint),
    ),
  );
  return customPaint.painter!;
}

void main() {
  group('Reduced motion', () {
    testWidgets('DsSpinner stops animating when disableAnimations is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSpinner(), disableAnimations: true),
      );

      // The spinner still renders so screen readers announce its live region…
      expect(find.byType(DsSpinner), findsOneWidget);

      // …but no ticker is scheduled, so the controller is genuinely stopped
      // (WCAG 2.3.3 / prefers-reduced-motion). transientCallbackCount counts
      // scheduled frame callbacks; an animating Ticker keeps one alive.
      expect(tester.binding.transientCallbackCount, 0);

      // And the painted arc does not advance across time.
      final before = _spinnerPainter(tester);
      await tester.pump(const Duration(milliseconds: 400));
      final after = _spinnerPainter(tester);
      expect(
        after.shouldRepaint(before),
        isFalse,
        reason: 'Spinner-armen skal ikke bevege seg når bevegelse er redusert',
      );
    });

    testWidgets('DsSpinner animates normally by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSpinner(), disableAnimations: false),
      );

      expect(find.byType(DsSpinner), findsOneWidget);

      // A running controller keeps a frame callback scheduled.
      expect(tester.binding.transientCallbackCount, greaterThan(0));

      // The painted arc advances over time.
      final before = _spinnerPainter(tester);
      await tester.pump(const Duration(milliseconds: 200));
      final after = _spinnerPainter(tester);
      expect(
        after.shouldRepaint(before),
        isTrue,
        reason: 'Spinner-armen skal bevege seg når animasjon er på',
      );

      // Stop the running ticker so the test does not leak a pending timer.
      await tester.pumpWidget(
        wrapWithTheme(const SizedBox.shrink(), disableAnimations: false),
      );
    });
  });
}
