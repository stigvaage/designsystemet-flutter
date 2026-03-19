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
  group('DsBadge', () {
    testWidgets('renders child without badge when count is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBadge(child: Text('Icon')),
        ),
      );
      expect(find.text('Icon'), findsOneWidget);
      // No badge count text — no Stack used when count is null
      expect(find.byType(Stack), findsNothing);
    });

    testWidgets('renders count text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBadge(count: 5, child: Text('Icon')),
        ),
      );
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('caps count at maxCount with "+" suffix', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBadge(count: 150, maxCount: 99, child: Text('Icon')),
        ),
      );
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('has semantic label with count', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBadge(count: 5, child: Text('Icon')),
        ),
      );
      // Verify via Semantics widget properties
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == '5 varsler',
        ),
      );
      expect(semanticsWidget.properties.label, '5 varsler');
    });

    testWidgets('singular semantic label for count=1', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsBadge(count: 1, child: Text('Icon')),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == '1 varsel',
        ),
      );
      expect(semanticsWidget.properties.label, '1 varsel');
    });
  });
}
