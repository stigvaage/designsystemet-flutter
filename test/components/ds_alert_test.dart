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

void main() {
  group('DsAlert', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAlert(child: Text('Something happened'))),
      );
      expect(find.text('Something happened'), findsOneWidget);
    });

    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAlert(title: Text('Alert title'), child: Text('Body')),
        ),
      );
      expect(find.text('Alert title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('renders severity icon for each severity', (tester) async {
      for (final severity in DsSeverity.values) {
        await tester.pumpWidget(
          wrapWithTheme(DsAlert(severity: severity, child: const Text('msg'))),
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
      await tester.tap(
        find.descendant(
          of: closeButton,
          matching: find.byType(GestureDetector),
        ),
      );
      expect(closed, isTrue);
    });

    testWidgets('Escape on focused close button calls onClose', (tester) async {
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
      final closeButton = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk varsel',
      );
      final descendantElement = tester.element(
        find.descendant(
          of: closeButton,
          matching: find.byType(GestureDetector),
        ),
      );
      Focus.of(descendantElement).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(closed, isTrue);
    });

    testWidgets('Enter and Space on focused close button call onClose', (
      tester,
    ) async {
      var closeCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(
            closable: true,
            onClose: () => closeCount++,
            child: const Text('msg'),
          ),
        ),
      );
      final closeButton = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk varsel',
      );
      final descendantElement = tester.element(
        find.descendant(
          of: closeButton,
          matching: find.byType(GestureDetector),
        ),
      );
      Focus.of(descendantElement).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(closeCount, 2);
    });

    testWidgets(
      'close button is inert (not a button, not focusable) when onClose is null',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const DsAlert(closable: true, child: Text('msg'))),
        );
        // The label is still present, but the button role is not announced
        // and the control is not focusable when there is nothing to do.
        final semantics = tester.widget<Semantics>(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == 'Lukk varsel',
          ),
        );
        expect(semantics.properties.button, isFalse);

        final focus = tester.widget<Focus>(
          find.descendant(
            of: find.byWidgetPredicate(
              (w) => w is Semantics && w.properties.label == 'Lukk varsel',
            ),
            matching: find.byType(Focus),
          ),
        );
        expect(focus.canRequestFocus, isFalse);
      },
    );

    testWidgets('severity icon exposes Norwegian semantic label', (
      tester,
    ) async {
      const expected = <DsSeverity, String>{
        DsSeverity.info: 'Informasjon',
        DsSeverity.warning: 'Advarsel',
        DsSeverity.success: 'Vellykket',
        DsSeverity.danger: 'Feil',
      };
      for (final entry in expected.entries) {
        await tester.pumpWidget(
          wrapWithTheme(DsAlert(severity: entry.key, child: const Text('msg'))),
        );
        expect(
          find.byWidgetPredicate(
            (w) => w is Icon && w.semanticLabel == entry.value,
          ),
          findsOneWidget,
          reason: 'Severity ${entry.key} should label icon "${entry.value}"',
        );
      }
    });

    testWidgets('has liveRegion semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAlert(child: Text('msg'))));
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

    testWidgets('close button shows click mouse cursor', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(closable: true, onClose: () {}, child: const Text('msg')),
        ),
      );
      final closeButton = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk varsel',
      );
      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(of: closeButton, matching: find.byType(MouseRegion)),
      );
      expect(mouseRegion.cursor, SystemMouseCursors.click);
    });

    testWidgets('close button reserves focus ring space', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(closable: true, onClose: () {}, child: const Text('msg')),
        ),
      );
      // DsFocus.reserveRing wraps the close button in a DecoratedBox so the
      // ring gap is always reserved (no layout shift on focus).
      final closeButton = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk varsel',
      );
      expect(
        find.descendant(of: closeButton, matching: find.byType(DecoratedBox)),
        findsWidgets,
      );
    });

    testWidgets('close button paints focus ring when focused', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsAlert(closable: true, onClose: () {}, child: const Text('msg')),
        ),
      );
      final closeButton = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Lukk varsel',
      );

      BoxDecoration ringDecoration() {
        final decorated = tester.widget<DecoratedBox>(
          find
              .descendant(of: closeButton, matching: find.byType(DecoratedBox))
              .first,
        );
        return decorated.decoration as BoxDecoration;
      }

      // Unfocused: the reserved border is transparent.
      expect(ringDecoration().border!.top.color.a, 0);

      // Focus the close button (look up the enclosing FocusNode from a
      // descendant element) and verify a visible ring appears.
      final descendantElement = tester.element(
        find.descendant(
          of: closeButton,
          matching: find.byType(GestureDetector),
        ),
      );
      Focus.of(descendantElement).requestFocus();
      // First pump grants focus; a second lets the Focus.onFocusChange callback
      // drive the button's setState so the reserved ring actually repaints.
      await tester.pump();
      await tester.pump();

      expect(ringDecoration().border!.top.color.a, greaterThan(0));
    });
  });
}
