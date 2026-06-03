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

Finder _semanticsWithLabel(String label) {
  return find.byWidgetPredicate(
    (w) => w is Semantics && w.properties.label == label,
  );
}

void main() {
  group('DsPagination', () {
    testWidgets('renders page buttons for totalPages', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 1, totalPages: 5, onPageChanged: (_) {}),
        ),
      );
      for (var i = 1; i <= 5; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('current page has selected semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 2, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        _semanticsWithLabel('Side 2'),
      );
      expect(semanticsWidget.properties.selected, isTrue);
    });

    testWidgets('tapping page button calls onPageChanged', (tester) async {
      var changedTo = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 1,
            totalPages: 3,
            onPageChanged: (p) => changedTo = p,
          ),
        ),
      );
      await tester.tap(find.text('3'));
      expect(changedTo, 3);
    });

    testWidgets('tapping current page does not fire callback', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 2,
            totalPages: 3,
            onPageChanged: (_) => called = true,
          ),
        ),
      );
      await tester.tap(find.text('2'));
      expect(called, isFalse);
    });

    testWidgets('previous button calls onPageChanged(currentPage-1)', (
      tester,
    ) async {
      var changedTo = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 3,
            totalPages: 5,
            onPageChanged: (p) => changedTo = p,
          ),
        ),
      );
      // Tap the previous button (‹ character)
      await tester.tap(find.text('‹'));
      expect(changedTo, 2);
    });

    testWidgets('previous button disabled on first page', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 1, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      final theme = DsThemeDigdir.light();
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final prevOpacity = opacityWidgets.first;
      expect(prevOpacity.opacity, theme.disabledOpacity);
    });

    testWidgets('next button disabled on last page', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 3, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      final theme = DsThemeDigdir.light();
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final nextOpacity = opacityWidgets.last;
      expect(nextOpacity.opacity, theme.disabledOpacity);
    });

    testWidgets('renders ellipsis (…) for large page ranges', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 5, totalPages: 20, onPageChanged: (_) {}),
        ),
      );
      // computeSteps(5, 20) => [1, 0, 4, 5, 6, 0, 20] → two ellipses.
      expect(find.text('…'), findsNWidgets(2));
      expect(find.text('20'), findsOneWidget);
      // The collapsed middle pages are not rendered.
      expect(find.text('10'), findsNothing);
    });
  });

  group('DsPagination.computeSteps (official getSteps port)', () {
    test('renders every page when totalPages <= showPages', () {
      expect(DsPagination.computeSteps(1, 5), [1, 2, 3, 4, 5]);
      expect(DsPagination.computeSteps(4, 7), [1, 2, 3, 4, 5, 6, 7]);
    });
    test('collapses the tail near the start (0 = ellipsis)', () {
      expect(DsPagination.computeSteps(1, 10), [1, 2, 3, 4, 5, 0, 10]);
    });
    test('collapses the head near the end', () {
      expect(DsPagination.computeSteps(10, 10), [1, 0, 6, 7, 8, 9, 10]);
    });
    test('double ellipsis when current is centered', () {
      expect(DsPagination.computeSteps(5, 10), [1, 0, 4, 5, 6, 0, 10]);
    });
  });
}
