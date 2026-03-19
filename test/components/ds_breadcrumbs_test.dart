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
        wrapWithTheme(
          const DsBreadcrumbs(items: ['A', 'B', 'C']),
        ),
      );
      // 3 items → 2 separators
      expect(find.text('/'), findsNWidgets(2));
    });

    testWidgets('last item is not underlined', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBreadcrumbs(items: ['Home', 'Current']),
        ),
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
        wrapWithTheme(
          const DsBreadcrumbs(items: ['Home', 'Page']),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Brødsmulenavigasjon',
        ),
        findsOneWidget,
      );
    });
  });
}
