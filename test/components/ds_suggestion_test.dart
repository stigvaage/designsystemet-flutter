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
  group('DsSuggestion', () {
    testWidgets('renders all item texts', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsSuggestion(items: ['Oslo', 'Bergen', 'Trondheim']),
        ),
      );
      expect(find.text('Oslo'), findsOneWidget);
      expect(find.text('Bergen'), findsOneWidget);
      expect(find.text('Trondheim'), findsOneWidget);
    });

    testWidgets('onSelected called with correct index', (tester) async {
      var selectedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSuggestion(
            items: const ['Oslo', 'Bergen'],
            onSelected: (i) => selectedIndex = i,
          ),
        ),
      );
      await tester.tap(find.text('Bergen'));
      expect(selectedIndex, 1);
    });

    testWidgets('has button semantics on each item', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsSuggestion(items: ['Oslo', 'Bergen']),
        ),
      );
      // Each item has Semantics(button: true, label: itemText)
      final semanticsWidgets = tester.widgetList<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.button == true,
        ),
      );
      expect(semanticsWidgets.length, 2);
    });

    testWidgets('each item semantic label matches text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsSuggestion(items: ['Stavanger']),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.button == true &&
              w.properties.label == 'Stavanger',
        ),
      );
      expect(semanticsWidget.properties.label, 'Stavanger');
    });
  });
}
