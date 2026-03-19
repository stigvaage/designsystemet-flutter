import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

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
          DsPagination(
            currentPage: 1,
            totalPages: 5,
            onPageChanged: (_) {},
          ),
        ),
      );
      for (var i = 1; i <= 5; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('current page has selected semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsPagination(
            currentPage: 2,
            totalPages: 3,
            onPageChanged: (_) {},
          ),
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

    testWidgets('tapping current page does not fire callback', (
      tester,
    ) async {
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
          DsPagination(
            currentPage: 1,
            totalPages: 3,
            onPageChanged: (_) {},
          ),
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
          DsPagination(
            currentPage: 3,
            totalPages: 3,
            onPageChanged: (_) {},
          ),
        ),
      );
      final theme = DsThemeDigdir.light();
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final nextOpacity = opacityWidgets.last;
      expect(nextOpacity.opacity, theme.disabledOpacity);
    });
  });
}
