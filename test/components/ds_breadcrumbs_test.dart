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

/// Requests focus on the nearest enclosing [Focus] of the widget found by
/// [finder]. Used to drive keyboard/focus tests for breadcrumb links that do
/// not expose a public `focusNode`.
Future<void> focusEnclosing(WidgetTester tester, Finder finder) async {
  final context = tester.element(finder);
  Focus.of(context).requestFocus();
  await tester.pump(); // process the focus change
  await tester.pump(); // rebuild with the focus ring
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

    testWidgets('renders chevron separators between items', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['A', 'B', 'C'])),
      );
      // 3 items → 2 chevron separators (matching the official chevron icon).
      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == DsIcons.chevronRight,
        ),
        findsNWidgets(2),
      );
      // No literal slash separators remain.
      expect(find.text('/'), findsNothing);
    });

    // Regression (overflow): a long trail in a constrained width must wrap
    // (official `<ol>` uses flex-wrap: wrap) rather than throw a RenderFlex
    // overflow.
    testWidgets('wraps long trail in a narrow width without overflowing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: SizedBox(
              width: 200,
              child: DsBreadcrumbs(
                items: [
                  'Hjemmeside',
                  'Komponentbibliotek',
                  'Navigasjonskomponenter',
                  'Brødsmulesti detaljer',
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
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

    testWidgets('has "Du er her:" semantics label by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsBreadcrumbs(items: ['Home', 'Page'])),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Du er her:',
        ),
        findsOneWidget,
      );
    });

    testWidgets('custom ariaLabel is used as the landmark label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBreadcrumbs(
            items: ['A', 'B'],
            ariaLabel: 'Brødsmulenavigasjon',
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Brødsmulenavigasjon',
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
      // The current page is still a link (aria-current="page") with the
      // "Gjeldende side" hint, matching the official focusable last crumb.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.link == true &&
              w.properties.hint == 'Gjeldende side',
        ),
        findsOneWidget,
      );
    });

    // Regression: the current (last) crumb is a focusable link in the tab
    // order and activates on Enter, matching the official `<a aria-current>`.
    testWidgets('Enter activates the focused current (last) crumb', (
      tester,
    ) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsBreadcrumbs(
            items: const ['Home', 'Current'],
            onItemTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await focusEnclosing(tester, find.text('Current'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(tappedIndex, 1);
    });

    // Regression: the chevron separator must use the theme size token
    // (--ds-size-6) and the text-subtle color, matching the official
    // --dsc-breadcrumbs-icon-size / --dsc-breadcrumbs-color.
    testWidgets('chevron separator uses the size-6 token and text-subtle', (
      tester,
    ) async {
      late DsThemeData themeData;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              themeData = DsTheme.of(context);
              return const DsBreadcrumbs(items: ['A', 'B']);
            },
          ),
        ),
      );
      final colorScale = themeData.colorScheme.resolve(DsColor.accent);
      final chevron = tester.widget<Icon>(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == DsIcons.chevronRight,
        ),
      );
      expect(chevron.size, themeData.sizeTokens.size6);
      expect(chevron.color, colorScale.textSubtle);
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
              w.properties.label == 'Du er her:' &&
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

    // Regression (WCAG 2.4.7): a focused breadcrumb link must show a visible
    // focus indicator — a borderStrong focus ring of focus-ring width.
    testWidgets('shows a visible focus ring (borderStrong) when a link is '
        'focused', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          DsBreadcrumbs(items: const ['Home', 'Current'], onItemTap: (_) {}),
        ),
      );

      bool hasFocusRing() =>
          tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((d) {
            final decoration = d.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top.color == colorScale.borderStrong &&
                border.top.width == 3.0;
          });

      // No focus ring before focusing.
      expect(hasFocusRing(), isFalse);

      await focusEnclosing(tester, find.text('Home'));

      expect(hasFocusRing(), isTrue);
    });

    // Regression: the focus ring space is always reserved (transparent border
    // of focus-ring width) so focusing a link does not shift the layout.
    testWidgets('reserves focus ring space on links even when not focused', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsBreadcrumbs(items: const ['Home', 'Current'], onItemTap: (_) {}),
        ),
      );
      final reserved = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((d) {
            final decoration = d.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top.color.a == 0.0 &&
                border.top.width == 3.0;
          });
      expect(reserved, isTrue);
    });

    // Regression: Enter activates the focused link (keyboard operability).
    testWidgets('Enter activates the focused link', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsBreadcrumbs(
            items: const ['Home', 'Products', 'Current'],
            onItemTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await focusEnclosing(tester, find.text('Products'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(tappedIndex, 1);
    });

    // Regression: link-role convention — Space must NOT activate a breadcrumb
    // link (native hyperlinks activate on Enter only; Space is reserved for
    // scrolling and button-role controls).
    testWidgets('Space does not activate the focused link', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsBreadcrumbs(
            items: const ['Home', 'Products', 'Current'],
            onItemTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await focusEnclosing(tester, find.text('Products'));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(tappedIndex, -1);
    });
  });
}
