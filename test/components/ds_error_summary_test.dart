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
/// [finder]. Used to drive keyboard/focus tests for error links that do not
/// expose a public `focusNode`.
Future<void> focusEnclosing(WidgetTester tester, Finder finder) async {
  final context = tester.element(finder);
  Focus.of(context).requestFocus();
  await tester.pump(); // process the focus change
  await tester.pump(); // rebuild with the focus ring
}

void main() {
  group('DsErrorSummary', () {
    testWidgets('renders error list', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsErrorSummary(errors: ['Error 1', 'Error 2'])),
      );
      expect(find.textContaining('Error 1'), findsOneWidget);
      expect(find.textContaining('Error 2'), findsOneWidget);
    });

    testWidgets('renders custom title', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsErrorSummary(errors: ['E1'], title: 'Fix these')),
      );
      expect(find.text('Fix these'), findsOneWidget);
    });

    // Regression (#35): the default heading is the official Designsystemet
    // Norwegian ErrorSummary heading, not the English "Errors".
    testWidgets('defaults to the Norwegian heading', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsErrorSummary(errors: ['E1'])),
      );
      expect(find.text('Du må rette opp følgende'), findsOneWidget);
      expect(find.text('Errors'), findsNothing);
    });

    testWidgets('calls onErrorTap when error tapped', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsErrorSummary(
            errors: const ['Error A', 'Error B'],
            onErrorTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await tester.tap(find.textContaining('Error B'));
      expect(tappedIndex, 1);
    });

    // Each tappable error exposes the link role (consistent with breadcrumbs).
    testWidgets('tappable errors expose the link role', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsErrorSummary(
            errors: const ['Error A', 'Error B'],
            onErrorTap: (_) {},
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.link == true,
        ),
        findsNWidgets(2),
      );
    });

    // Plain (non-tappable) errors are NOT links.
    testWidgets('non-tappable errors are not links', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsErrorSummary(errors: ['Error A'])),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.link == true,
        ),
        findsNothing,
      );
    });

    // Regression (#32, WCAG 2.4.7): a focused error link must show a visible
    // focus indicator — a borderStrong focus ring of focus-ring width.
    testWidgets('shows a visible focus ring (borderStrong) when an error link '
        'is focused', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.danger);
      await tester.pumpWidget(
        wrapWithTheme(
          DsErrorSummary(
            errors: const ['Error A', 'Error B'],
            onErrorTap: (_) {},
          ),
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

      await focusEnclosing(tester, find.textContaining('Error A'));

      expect(hasFocusRing(), isTrue);
    });

    // Regression (#32): the focus ring space is always reserved (transparent
    // border of focus-ring width) so focusing a link does not shift the layout.
    testWidgets('reserves focus ring space on error links even when not '
        'focused', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsErrorSummary(
            errors: const ['Error A', 'Error B'],
            onErrorTap: (_) {},
          ),
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

    // Regression (#32): Enter activates the focused error link.
    testWidgets('Enter activates the focused error link', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          DsErrorSummary(
            errors: const ['Error A', 'Error B'],
            onErrorTap: (i) => tappedIndex = i,
          ),
        ),
      );
      await focusEnclosing(tester, find.textContaining('Error B'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(tappedIndex, 1);
    });

    // #36: the size prop scales the container padding.
    testWidgets('size scales the container padding', (tester) async {
      Future<EdgeInsetsGeometry?> containerPadding(DsSize size) async {
        await tester.pumpWidget(
          wrapWithTheme(DsErrorSummary(errors: const ['E1'], size: size)),
        );
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(DsErrorSummary),
                matching: find.byType(Container),
              )
              .first,
        );
        return container.padding;
      }

      final sm = await containerPadding(DsSize.sm);
      final md = await containerPadding(DsSize.md);
      final lg = await containerPadding(DsSize.lg);
      expect(sm, equals(const EdgeInsets.all(12)));
      expect(md, equals(const EdgeInsets.all(16)));
      expect(lg, equals(const EdgeInsets.all(20)));
    });

    // #36: the color prop is honoured (non-danger color resolves a different
    // border color).
    testWidgets('color prop changes the panel border color', (tester) async {
      final theme = DsThemeDigdir.light();
      final accent = theme.colorScheme.resolve(DsColor.accent);

      await tester.pumpWidget(
        wrapWithTheme(
          const DsErrorSummary(errors: ['E1'], color: DsColor.accent),
        ),
      );

      final hasAccentBorder = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) {
            final decoration = c.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border && border.top.color == accent.borderDefault;
          });
      expect(hasAccentBorder, isTrue);
    });
  });
}
