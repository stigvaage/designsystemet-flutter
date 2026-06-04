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
/// [finder]. Used to drive keyboard tests for chips that do not expose a
/// public `focusNode`.
Future<void> focusEnclosing(WidgetTester tester, Finder finder) async {
  final context = tester.element(finder);
  Focus.of(context).requestFocus();
  await tester.pump(); // process the focus change
  await tester.pump(); // rebuild with the focus ring
}

void main() {
  group('DsChip', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsChip(child: Text('Flutter'))),
      );
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('selected chip uses base color background', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(const DsChip(selected: true, child: Text('Active'))),
      );
      // The outer Container should have baseDefault background
      final containers = tester.widgetList<Container>(find.byType(Container));
      final chipContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == colorScale.baseDefault,
      );
      expect(chipContainer, isNotNull);
    });

    testWidgets('onTap called when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(onTap: () => tapped = true, child: const Text('Tap')),
        ),
      );
      await tester.tap(find.byType(DsChip));
      expect(tapped, isTrue);
    });

    testWidgets('removable shows X icon with "Fjern" label', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(removable: true, onRemove: () {}, child: const Text('Tag')),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fjern',
        ),
        findsOneWidget,
      );
    });

    testWidgets('onRemove called when remove icon tapped', (tester) async {
      var removed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(
            removable: true,
            onRemove: () => removed = true,
            child: const Text('Tag'),
          ),
        ),
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fjern',
        ),
      );
      expect(removed, isTrue);
    });

    testWidgets('has button semantics when onTap set', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsChip(onTap: () {}, child: const Text('Click'))),
      );
      final semantics = tester.getSemantics(find.byType(DsChip));
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('DsChip.button calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.button(
            onTap: () => tapped = true,
            child: const Text('Action'),
          ),
        ),
      );
      await tester.tap(find.byType(DsChip));
      expect(tapped, isTrue);
    });

    testWidgets('DsChip.removable calls onRemove when icon tapped', (
      tester,
    ) async {
      var removed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.removable(
            onRemove: () => removed = true,
            child: const Text('Tag'),
          ),
        ),
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fjern',
        ),
      );
      expect(removed, isTrue);
    });

    testWidgets('DsChip.checkbox toggles selected via onChanged', (
      tester,
    ) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.checkbox(
            selected: false,
            onChanged: (value) => newValue = value,
            child: const Text('Bokmål'),
          ),
        ),
      );
      await tester.tap(find.byType(DsChip));
      expect(newValue, isTrue);

      newValue = null;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.checkbox(
            selected: true,
            onChanged: (value) => newValue = value,
            child: const Text('Bokmål'),
          ),
        ),
      );
      await tester.tap(find.byType(DsChip));
      expect(newValue, isFalse);
    });

    testWidgets('DsChip.checkbox exposes checked semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.checkbox(
            selected: true,
            onChanged: (_) {},
            child: const Text('Bokmål'),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.checked == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('DsChip.radio selects via onChanged', (tester) async {
      var selectedCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.radio(
            selected: false,
            onChanged: () => selectedCount++,
            child: const Text('Nynorsk'),
          ),
        ),
      );
      await tester.tap(find.byType(DsChip));
      expect(selectedCount, 1);
    });

    testWidgets('DsChip.radio is idempotent: tap on already selected chip '
        'does not re-fire onChanged', (tester) async {
      var selectedCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.radio(
            selected: true,
            onChanged: () => selectedCount++,
            child: const Text('Nynorsk'),
          ),
        ),
      );
      await tester.tap(find.byType(DsChip));
      await tester.pump();
      expect(selectedCount, 0);
    });

    testWidgets('DsChip.radio is idempotent: Enter/Space on already selected '
        'chip does not re-fire onChanged', (tester) async {
      var selectedCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.radio(
            selected: true,
            onChanged: () => selectedCount++,
            child: const Text('Nynorsk'),
          ),
        ),
      );
      await focusEnclosing(tester, find.text('Nynorsk'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selectedCount, 0);
    });

    testWidgets('DsChip.radio exposes selected semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.radio(
            selected: true,
            onChanged: () {},
            child: const Text('Nynorsk'),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.selected == true,
        ),
        findsOneWidget,
      );
    });

    // --- Regression: visible focus ring (WCAG 2.4.7) -----------------------

    testWidgets(
      'shows a visible focus ring (borderStrong) when chip is focused',
      (tester) async {
        final theme = DsThemeDigdir.light();
        final colorScale = theme.colorScheme.resolve(DsColor.accent);
        await tester.pumpWidget(
          wrapWithTheme(DsChip(onTap: () {}, child: const Text('Fokus'))),
        );

        // No focus ring before focusing: no DecoratedBox uses borderStrong.
        bool hasFocusRing() =>
            tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((d) {
              final decoration = d.decoration;
              if (decoration is! BoxDecoration) return false;
              final border = decoration.border;
              return border is Border &&
                  border.top.color == colorScale.borderStrong &&
                  border.top.width == 3.0;
            });

        expect(hasFocusRing(), isFalse);

        await focusEnclosing(tester, find.text('Fokus'));

        expect(hasFocusRing(), isTrue);
      },
    );

    testWidgets('reserves focus ring space even when not focused', (
      tester,
    ) async {
      // A transparent 3px border is always reserved so focusing does not shift
      // the layout. There should be at least one DecoratedBox with a fully
      // transparent border of focus-ring width.
      await tester.pumpWidget(
        wrapWithTheme(DsChip(onTap: () {}, child: const Text('Plass'))),
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

    // --- Regression: keyboard activation -----------------------------------

    testWidgets('Enter activates onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(onTap: () => tapped = true, child: const Text('Enter')),
        ),
      );
      await focusEnclosing(tester, find.text('Enter'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('Space activates onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(onTap: () => tapped = true, child: const Text('Space')),
        ),
      );
      await focusEnclosing(tester, find.text('Space'));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('Delete on the chip removes a removable chip', (tester) async {
      var removed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.removable(
            onRemove: () => removed = true,
            child: const Text('Slett'),
          ),
        ),
      );
      await focusEnclosing(tester, find.text('Slett'));
      await tester.sendKeyEvent(LogicalKeyboardKey.delete);
      await tester.pump();
      expect(removed, isTrue);
    });

    // --- Regression: remove icon is a real focusable button ----------------

    testWidgets('remove icon activates onRemove with Enter when focused', (
      tester,
    ) async {
      var removed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.removable(
            onRemove: () => removed = true,
            child: const Text('Fjernbar'),
          ),
        ),
      );
      // Focus the remove button via its "Fjern"-labelled Semantics subtree.
      final iconFinder = find.byWidgetPredicate((w) => w is Icon);
      await focusEnclosing(tester, iconFinder);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(removed, isTrue);
    });

    testWidgets('remove icon activates onRemove with Space when focused', (
      tester,
    ) async {
      var removed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.removable(
            onRemove: () => removed = true,
            child: const Text('Fjernbar'),
          ),
        ),
      );
      await focusEnclosing(tester, find.byWidgetPredicate((w) => w is Icon));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(removed, isTrue);
    });

    // --- Regression: non-contradictory selection semantics -----------------

    testWidgets(
      'selected button-role chip is toggled, not selected (no contradiction)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DsChip.button(
              selected: true,
              onTap: () {},
              child: const Text('Valgt knapp'),
            ),
          ),
        );
        // A button chip exposes button + toggled, never the contradictory
        // "selected" (selected is reserved for the radio role).
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Semantics &&
                w.properties.button == true &&
                w.properties.toggled == true &&
                w.properties.selected == null,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('default-constructor selected chip is not announced selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsChip(selected: true, child: Text('Standard valgt')),
        ),
      );
      // The default (button) role does not expose "selected".
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.selected == true,
        ),
        findsNothing,
      );
    });

    testWidgets('radio chip is announced selected, not button', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.radio(
            selected: true,
            onChanged: () {},
            child: const Text('Radio valgt'),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.selected == true &&
              w.properties.button == false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('checkbox chip is not announced as a button', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip.checkbox(
            selected: true,
            onChanged: (_) {},
            child: const Text('Avkrysning'),
          ),
        ),
      );
      // Checkbox role: checked, not button.
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.checked == true,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.button == true,
        ),
        findsNothing,
      );
    });
  });
}
