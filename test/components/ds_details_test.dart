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

      // A second Enter collapses it again. The expanded/collapsed state lives
      // on the focusable summary button node (merged with its label), not on
      // the outer container.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      final semantics = tester.getSemantics(find.bySemanticsLabel('Summary'));
      expect(semantics.flagsCollection.isButton, isTrue);
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
      // The expanded state is exposed on the focusable summary button node.
      final semantics = tester.getSemantics(find.bySemanticsLabel('Summary'));
      expect(semantics.flagsCollection.isButton, isTrue);
      expect(semantics.flagsCollection.isExpanded, Tristate.isTrue);
    });

    testWidgets('forwards an external focusNode to the summary', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        wrapWithTheme(
          DsDetails(
            focusNode: focusNode,
            summary: const Text('Summary'),
            child: const Text('Content'),
          ),
        ),
      );

      // Requesting focus on the external node focuses the summary, and a
      // keyboard activation through that focus toggles the disclosure.
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);
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

    testWidgets('button and expanded state live on the same node', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('S'),
            initiallyExpanded: true,
            child: Text('C'),
          ),
        ),
      );
      // The disclosure role (button) and the expanded flag must be exposed on
      // ONE node — the focusable summary trigger — matching the ARIA
      // disclosure pattern and DsDropdown.
      final semantics = tester.getSemantics(find.bySemanticsLabel('S'));
      expect(semantics.flagsCollection.isButton, isTrue);
      expect(semantics.flagsCollection.isExpanded, Tristate.isTrue);
    });

    testWidgets('collapsed content is excluded from semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      // Collapsed: the hidden child must not appear in the semantics tree,
      // even though the SizeTransition still keeps it in the widget tree.
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Content'), findsNothing);
      expect(find.text('Content'), findsOneWidget);

      // Expanding it brings the content into the semantics tree.
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Content'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('collapsed content is gated out of focus traversal', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      ExcludeFocus excludeFocus() => tester.widget<ExcludeFocus>(
        find.ancestor(
          of: find.text('Content'),
          matching: find.byType(ExcludeFocus),
        ),
      );

      // Collapsed: the content subtree is excluded from focus traversal.
      expect(excludeFocus().excluding, isTrue);

      // Expanding releases the focus gate.
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      expect(excludeFocus().excluding, isFalse);
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
