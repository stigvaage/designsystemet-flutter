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
  group('DsAlert', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAlert(child: Text('Something happened')),
        ),
      );
      expect(find.text('Something happened'), findsOneWidget);
    });

    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAlert(
            title: Text('Alert title'),
            child: Text('Body'),
          ),
        ),
      );
      expect(find.text('Alert title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('renders severity icon for each severity', (tester) async {
      for (final severity in DsSeverity.values) {
        await tester.pumpWidget(
          wrapWithTheme(
            DsAlert(severity: severity, child: const Text('msg')),
          ),
        );
        // Each severity renders an Icon widget
        expect(find.byType(Icon), findsAtLeast(1));
      }
    });

    testWidgets('closable shows close button', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(closable: true, onClose: () {}, child: const Text('msg')),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Lukk varsel',
        ),
        findsOneWidget,
      );
    });

    testWidgets('onClose called when close button tapped', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(
            closable: true,
            onClose: () => closed = true,
            child: const Text('msg'),
          ),
        ),
      );
      // Find the GestureDetector inside the close button Semantics
      final closeButton = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk varsel',
      );
      await tester.tap(find.descendant(
        of: closeButton,
        matching: find.byType(GestureDetector),
      ));
      expect(closed, isTrue);
    });

    testWidgets('has liveRegion semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAlert(child: Text('msg'))),
      );
      // Verify the Semantics widget properties directly
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.liveRegion == true,
        ),
      );
      expect(semanticsWidget.properties.liveRegion, isTrue);
    });

    testWidgets('close button has "Lukk varsel" semantic label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(closable: true, onClose: () {}, child: const Text('msg')),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Lukk varsel',
        ),
      );
      expect(semanticsWidget.properties.label, 'Lukk varsel');
    });
  });
}
