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

/// Mounts [dialog] inside a [Navigator] so [DsDialog]'s `Navigator.pop` works.
Widget wrapWithNavigator(Widget dialog) {
  return wrapWithTheme(
    Navigator(
      onGenerateRoute: (_) =>
          PageRouteBuilder(pageBuilder: (context, a, sa) => dialog),
    ),
  );
}

Finder findCloseButton() {
  return find.byWidgetPredicate(
    (w) => w is Semantics && w.properties.label == 'Lukk dialogvindu',
  );
}

void main() {
  group('DsDialog', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsDialog(child: Text('Dialog body'))),
      );
      expect(find.text('Dialog body'), findsOneWidget);
    });

    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDialog(title: Text('Dialog title'), child: Text('Body')),
        ),
      );
      expect(find.text('Dialog title'), findsOneWidget);
    });

    testWidgets('shows close button by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsDialog(child: Text('body'))),
      );
      expect(findCloseButton(), findsOneWidget);
    });

    testWidgets('hides close button when closeButton is false', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsDialog(closeButton: false, child: Text('body'))),
      );
      expect(findCloseButton(), findsNothing);
    });

    testWidgets('close button calls onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        wrapWithNavigator(
          DsDialog(onClose: () => closed = true, child: const Text('body')),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(findCloseButton());
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('close button tap target is fully hittable (not just glyph)', (
      tester,
    ) async {
      var closed = false;
      await tester.pumpWidget(
        wrapWithNavigator(
          DsDialog(onClose: () => closed = true, child: const Text('body')),
        ),
      );
      await tester.pumpAndSettle();
      // Tap near the top-left corner of the 44x44 box, off the centered glyph,
      // to verify HitTestBehavior.opaque makes the whole box tappable.
      final rect = tester.getRect(findCloseButton());
      await tester.tapAt(rect.topLeft + const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('Escape closes dialog and fires onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        wrapWithNavigator(
          DsDialog(onClose: () => closed = true, child: const Text('body')),
        ),
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.text('body'), findsNothing);
    });

    testWidgets('Escape closes even when closeButton is hidden', (
      tester,
    ) async {
      var closed = false;
      await tester.pumpWidget(
        wrapWithNavigator(
          DsDialog(
            closeButton: false,
            onClose: () => closed = true,
            child: const Text('body'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('requests focus on open', (tester) async {
      await tester.pumpWidget(
        wrapWithNavigator(const DsDialog(child: Text('body'))),
      );
      await tester.pumpAndSettle();
      expect(
        FocusManager.instance.primaryFocus,
        isNotNull,
        reason: 'dialog should claim focus on open',
      );
    });

    testWidgets('close button reserves focus ring space', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsDialog(onClose: () {}, child: const Text('body'))),
      );
      // DsFocus.reserveRing wraps the close button in a DecoratedBox so the
      // ring gap is always reserved (no layout shift on focus).
      expect(
        find.descendant(
          of: findCloseButton(),
          matching: find.byType(DecoratedBox),
        ),
        findsWidgets,
      );
    });

    testWidgets('close button paints focus ring when focused', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsDialog(onClose: () {}, child: const Text('body'))),
      );
      final closeButton = findCloseButton();

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

    testWidgets('has scopesRoute and namesRoute semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsDialog(child: Text('body'))),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.scopesRoute == true,
        ),
      );
      expect(semanticsWidget.properties.scopesRoute, isTrue);
      expect(semanticsWidget.properties.namesRoute, isTrue);
    });

    testWidgets('close button has "Lukk dialogvindu" semantic label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(DsDialog(onClose: () {}, child: const Text('body'))),
      );
      expect(findCloseButton(), findsOneWidget);
    });

    testWidgets('does not dismiss on barrier tap by default', (tester) async {
      var closed = false;
      late BuildContext navContext;
      await tester.pumpWidget(
        wrapWithTheme(
          Navigator(
            onGenerateRoute: (_) => PageRouteBuilder(
              pageBuilder: (context, a, sa) {
                navContext = context;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
      DsDialog.show<void>(
        context: navContext,
        builder: (context) =>
            DsDialog(onClose: () => closed = true, child: const Text('body')),
      );
      await tester.pumpAndSettle();
      // Tap far outside the centered dialog (top-left corner of the screen).
      await tester.tapAt(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(closed, isFalse);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('dismisses on barrier tap when closeOnBarrierTap is true', (
      tester,
    ) async {
      var closed = false;
      late BuildContext navContext;
      await tester.pumpWidget(
        wrapWithTheme(
          Navigator(
            onGenerateRoute: (_) => PageRouteBuilder(
              pageBuilder: (context, a, sa) {
                navContext = context;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
      DsDialog.show<void>(
        context: navContext,
        closeOnBarrierTap: true,
        builder: (context) =>
            DsDialog(onClose: () => closed = true, child: const Text('body')),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.text('body'), findsNothing);
    });
  });
}
