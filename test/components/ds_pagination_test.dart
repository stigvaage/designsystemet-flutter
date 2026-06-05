import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/services.dart';
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

/// Requests focus on the nearest [Focus] ancestor of [target] and pumps so the
/// focus change settles. Used to drive keyboard activation in tests since
/// [DsPagination] creates its focus nodes internally.
Future<void> _focusAncestorOf(WidgetTester tester, Finder target) async {
  final context = tester.element(target);
  final focusNode = Focus.of(context);
  focusNode.requestFocus();
  // First pump grants focus; a second lets the Focus.onFocusChange callback
  // drive the item's setState so the focus ring actually repaints.
  await tester.pump();
  await tester.pump();
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
      // The current page conveys its state through a Norwegian status hint in
      // the label and stays announced as selected (closest to aria-current).
      final semanticsWidget = tester.widget<Semantics>(
        _semanticsWithLabel('Side 2, gjeldende side'),
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

    testWidgets('current page stays interactive and fires onPageChanged', (
      tester,
    ) async {
      // The official component keeps the current page a real, clickable button
      // (usePagination only adds aria-current; it never demotes it to a span).
      var changedTo = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 2,
            totalPages: 3,
            onPageChanged: (p) => changedTo = p,
          ),
        ),
      );
      await tester.tap(find.text('2'));
      expect(changedTo, 2);
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

    testWidgets('pressing Enter on a focused page button calls onPageChanged', (
      tester,
    ) async {
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
      await _focusAncestorOf(tester, find.text('3'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(changedTo, 3);
    });

    testWidgets('pressing Space on a focused page button calls onPageChanged', (
      tester,
    ) async {
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
      await _focusAncestorOf(tester, find.text('2'));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(changedTo, 2);
    });

    testWidgets('pressing Enter on the focused next arrow advances the page', (
      tester,
    ) async {
      var changedTo = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 2,
            totalPages: 5,
            onPageChanged: (p) => changedTo = p,
          ),
        ),
      );
      await _focusAncestorOf(tester, find.text('›'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(changedTo, 3);
    });

    testWidgets('pressing Space on the focused previous arrow goes back', (
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
      await _focusAncestorOf(tester, find.text('‹'));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(changedTo, 2);
    });

    testWidgets('focused interactive item shows the borderStrong focus ring', (
      tester,
    ) async {
      final theme = DsThemeDigdir.light();
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 1, totalPages: 3, onPageChanged: (_) {}),
        ),
      );

      // No item is focused yet: no DecoratedBox should paint the focus colour.
      bool hasFocusRing() =>
          tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((box) {
            final decoration = box.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top.color == theme.colorScheme.accent.borderStrong;
          });
      expect(hasFocusRing(), isFalse);

      await _focusAncestorOf(tester, find.text('2'));

      // Once focused, DsFocus.reserveRing paints the borderStrong ring.
      expect(hasFocusRing(), isTrue);
    });

    testWidgets('disabled previous arrow is not focusable', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 1, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      // The disabled arrow renders a plain glyph without a Focus wrapper, so
      // there is no focusable ancestor of the '‹' text.
      final context = tester.element(find.text('‹'));
      expect(Focus.maybeOf(context), isNull);
    });

    testWidgets('active page stays a button and is announced as selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 2, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      // The current page remains a real button (official parity) and conveys
      // current-page state via selected + a Norwegian label hint.
      final activeSemantics = tester.widget<Semantics>(
        _semanticsWithLabel('Side 2, gjeldende side'),
      );
      expect(activeSemantics.properties.button, isTrue);
      expect(activeSemantics.properties.selected, isTrue);

      // A non-active page is also a button, without the current-page hint.
      final inactiveSemantics = tester.widget<Semantics>(
        _semanticsWithLabel('Side 1'),
      );
      expect(inactiveSemantics.properties.button, isTrue);
      expect(inactiveSemantics.properties.selected, isFalse);
    });

    testWidgets('current page stays focusable', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 2, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      // The current page is not demoted to an inert indicator: it has a
      // focusable ancestor like every other interactive page button.
      final context = tester.element(find.text('2'));
      expect(Focus.maybeOf(context), isNotNull);
    });

    testWidgets('wraps the control in a navigation landmark with a label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(currentPage: 1, totalPages: 3, onPageChanged: (_) {}),
        ),
      );
      // Default Norwegian landmark label, matching the official
      // `--dsc-pagination-label` ('Bla i sider').
      expect(_semanticsWithLabel('Bla i sider'), findsOneWidget);
    });

    testWidgets('navigation landmark label is overridable', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 1,
            totalPages: 3,
            onPageChanged: (_) {},
            ariaLabel: 'Sidenavigering',
          ),
        ),
      );
      expect(_semanticsWithLabel('Sidenavigering'), findsOneWidget);
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
