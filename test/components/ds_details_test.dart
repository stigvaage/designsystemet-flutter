import 'dart:ui' show Tristate;

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
  group('DsDetails', () {
    testWidgets('renders summary', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('Click to expand'),
            child: Text('Hidden content'),
          ),
        ),
      );
      expect(find.text('Click to expand'), findsOneWidget);
    });

    testWidgets('expands on tap', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('expands on Enter when summary is focused', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      final focusNode = Focus.of(tester.element(find.text('Summary')));
      focusNode.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);

      // A second Enter collapses it again.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      final semantics = tester.getSemantics(find.byType(DsDetails));
      expect(semantics.flagsCollection.isExpanded, Tristate.isFalse);
    });

    testWidgets('toggles on Space when summary is focused', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      final focusNode = Focus.of(tester.element(find.text('Summary')));
      focusNode.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      final semantics = tester.getSemantics(find.byType(DsDetails));
      expect(semantics.flagsCollection.isExpanded, isNot(Tristate.none));
    });

    testWidgets('summary exposes a button with an onTap action', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      // The summary exposes a button with a tap action (keyboard/AT operable).
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.button == true &&
              w.properties.onTap != null,
        ),
        findsOneWidget,
      );
    });

    testWidgets('tap in the summary padding still toggles', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      // The summary row has 12px of padding around the content. Tapping the
      // top-left padding zone (1px in) must hit-test as opaque and toggle.
      final summaryRow = find.descendant(
        of: find.byType(DsDetails),
        matching: find.byType(GestureDetector),
      );
      final topLeft = tester.getTopLeft(summaryRow.first);
      await tester.tapAt(topLeft + const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('has expanded semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('S'),
            initiallyExpanded: true,
            child: Text('C'),
          ),
        ),
      );
      final semantics = tester.getSemantics(find.byType(DsDetails));
      expect(semantics.flagsCollection.isExpanded, isNot(Tristate.none));
    });

    testWidgets('tinted variant fills with surfaceTinted', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('Summary'),
            variant: DsDetailsVariant.tinted,
            child: Text('Content'),
          ),
        ),
      );

      final context = tester.element(find.byType(DsDetails));
      final theme = DsTheme.of(context);
      final colorScale = theme.colorScheme.resolve(DsColorScope.of(context));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DsDetails),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, colorScale.surfaceTinted);
    });

    testWidgets('default variant has no fill', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DsDetails),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNull);
    });
  });
}
