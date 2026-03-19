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
  group('DsDialog', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDialog(child: Text('Dialog body')),
        ),
      );
      expect(find.text('Dialog body'), findsOneWidget);
    });

    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDialog(
            title: Text('Dialog title'),
            child: Text('Body'),
          ),
        ),
      );
      expect(find.text('Dialog title'), findsOneWidget);
    });

    testWidgets('close button calls onClose', (tester) async {
      var closed = false;
      // DsDialog._handleClose calls Navigator.of(context).pop(), so we
      // need a Navigator ancestor.
      await tester.pumpWidget(
        wrapWithTheme(
          Navigator(
            onGenerateRoute: (_) => PageRouteBuilder(
              pageBuilder: (context, a, sa) => DsDialog(
                onClose: () => closed = true,
                child: const Text('body'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk dialog',
      ));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('has scopesRoute and namesRoute semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDialog(child: Text('body')),
        ),
      );
      // Verify via the Semantics widget properties directly
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.scopesRoute == true,
        ),
      );
      expect(semanticsWidget.properties.scopesRoute, isTrue);
      expect(semanticsWidget.properties.namesRoute, isTrue);
    });

    testWidgets('close button has "Lukk dialog" semantic label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsDialog(onClose: () {}, child: const Text('body')),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Lukk dialog',
        ),
        findsOneWidget,
      );
    });
  });
}
