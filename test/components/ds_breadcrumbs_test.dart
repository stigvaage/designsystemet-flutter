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
  group('DsBreadcrumbs', () {
    testWidgets('renders all item texts', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBreadcrumbs(items: ['Home', 'Products', 'Details']),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
    });

    testWidgets('renders slash separators between items', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['A', 'B', 'C'])),
      );
      // 3 items → 2 separators
      expect(find.text('/'), findsNWidgets(2));
    });

    testWidgets('last item is not underlined', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['Home', 'Current'])),
      );
      final lastText = tester.widget<Text>(find.text('Current'));
      expect(lastText.style?.decoration, isNot(TextDecoration.underline));
    });

    testWidgets('onItemTap called with correct index for non-last item', (
      tester,
    ) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsBreadcrumbs(
            items: const ['Home', 'Products', 'Current'],
            onItemTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await tester.tap(find.text('Products'));
      expect(tappedIndex, 1);
    });

    testWidgets('has "Brødsmulenavigasjon" semantics label', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['Home', 'Page'])),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Brødsmulenavigasjon',
        ),
        findsOneWidget,
      );
    });

    testWidgets('custom ariaLabel is used as the landmark label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBreadcrumbs(items: ['A', 'B'], ariaLabel: 'Du er her:'),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Du er her:',
        ),
        findsOneWidget,
      );
    });

    testWidgets('last item exposes aria-current via "Gjeldende side" hint', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['Home', 'Current'])),
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Current' &&
              w.properties.hint == 'Gjeldende side',
        ),
        findsOneWidget,
      );
    });

    // Regression: the '/' separator must use the bodySm typography token
    // (fontFamily/height/letterSpacing/weight), not a raw TextStyle(fontSize).
    testWidgets('slash separator uses the bodySm typography token', (
      tester,
    ) async {
      late DsTypography typography;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              typography = DsTheme.of(context).typography;
              return const DsBreadcrumbs(items: ['A', 'B']);
            },
          ),
        ),
      );
      final separator = tester.widget<Text>(find.text('/'));
      final expected = typography.bodySm;
      expect(separator.style?.fontSize, expected.fontSize);
      expect(separator.style?.fontFamily, expected.fontFamily);
      expect(separator.style?.height, expected.height);
      expect(separator.style?.letterSpacing, expected.letterSpacing);
      expect(separator.style?.fontWeight, expected.fontWeight);
    });

    // Regression: the navigation landmark must form a single grouped
    // container (React `<nav><ol>`), so AT announces it as one region.
    testWidgets('navigation landmark is a grouped container', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['Home', 'Page'])),
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Brødsmulenavigasjon' &&
              w.container == true,
        ),
        findsOneWidget,
      );
    });

    // Regression: each link exposes a positional hint within the trail.
    testWidgets('link items expose a positional hint', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBreadcrumbs(items: ['Home', 'Products', 'Current']),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.link == true &&
              w.properties.hint == 'Steg 1 av 3',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.link == true &&
              w.properties.hint == 'Steg 2 av 3',
        ),
        findsOneWidget,
      );
    });
  });
}
