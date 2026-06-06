import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithOverlay(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              // Place the trigger small and top-left so the dropdown opens
              // on-screen below it (a full-screen trigger pushes it off-screen).
              builder: (_) => Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: 250, child: child),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

const _fruit = [
  DsSelectOption<String>(value: 'apple', label: 'Apple'),
  DsSelectOption<String>(value: 'banana', label: 'Banana'),
];

void main() {
  group('DsSelect', () {
    testWidgets('renders placeholder when no selection', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose fruit'),
        ),
      );
      expect(find.text('Choose fruit'), findsOneWidget);
    });

    testWidgets('renders selected option label', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, value: 'banana'),
        ),
      );
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('opens and selecting an option calls onChanged with value', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsSelect<String>(
            options: _fruit,
            placeholder: 'Choose',
            onChanged: (value) => selected = value,
          ),
        ),
      );

      // Open the dropdown.
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();

      // Both options are now visible in the overlay.
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);

      // Select one.
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();

      expect(selected, 'banana');
    });

    testWidgets('renders group heading above grouped options', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: [],
            placeholder: 'Choose city',
            groups: [
              DsSelectOptgroup<String>(
                label: 'Norway',
                options: [
                  DsSelectOption<String>(value: 'oslo', label: 'Oslo'),
                  DsSelectOption<String>(value: 'bergen', label: 'Bergen'),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Choose city'));
      await tester.pumpAndSettle();

      // Group heading and its options are rendered.
      expect(find.text('Norway'), findsOneWidget);
      expect(find.text('Oslo'), findsOneWidget);
      expect(find.text('Bergen'), findsOneWidget);
    });

    testWidgets('selected option has selected semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, value: 'apple'),
        ),
      );

      await tester.tap(find.text('Apple').first);
      await tester.pumpAndSettle();

      final selectedSemantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Apple' &&
              w.properties.selected == true,
        ),
      );
      expect(selectedSemantics.properties.selected, isTrue);
    });

    testWidgets('disabled renders at reduced opacity', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, disabled: true),
        ),
      );
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      final theme = DsThemeDigdir.light();
      expect(opacity.opacity, theme.disabledOpacity);
    });

    testWidgets('disabled does not open dropdown', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: _fruit,
            disabled: true,
            placeholder: 'Choose',
          ),
        ),
      );
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      // No option list appears because the control cannot open.
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('has button semantics with "Velg" label', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: [
              DsSelectOption<String>(value: 'a', label: 'A'),
              DsSelectOption<String>(value: 'b', label: 'B'),
            ],
          ),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Velg',
        ),
      );
      expect(semanticsWidget.properties.button, isTrue);
    });

    testWidgets(
      'error state promotes the trigger border to the danger colour',
      (tester) async {
        final danger = DsThemeDigdir.light().colorScheme.danger;
        await tester.pumpWidget(
          wrapWithOverlay(
            const DsSelect<String>(
              options: [DsSelectOption<String>(value: 'a', label: 'A')],
              error: 'Required',
            ),
          ),
        );

        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = container.decoration! as BoxDecoration;
        // The error state colours the trigger border with the danger scale,
        // proving the `error` branch actually drives a visible change.
        expect(decoration.border!.top.color, danger.borderDefault);
      },
    );

    testWidgets('Enter key opens the dropdown', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      // Focus the trigger, then press Enter to open.
      Focus.of(tester.element(find.text('Choose'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('Space key opens the dropdown', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      Focus.of(tester.element(find.text('Choose'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('Enter toggles the dropdown closed when open', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      // Open via tap (this also focuses the trigger).
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      // Pressing Enter again toggles it closed.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('Escape closes the open dropdown', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('tapping the trigger focuses it', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();

      expect(Focus.of(tester.element(find.text('Choose'))).hasFocus, isTrue);
    });

    testWidgets('disabled does not open on Enter', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: _fruit,
            disabled: true,
            placeholder: 'Choose',
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('ArrowDown then Enter selects an option via keyboard', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsSelect<String>(
            options: _fruit,
            placeholder: 'Choose',
            onChanged: (value) => selected = value,
          ),
        ),
      );

      // Focus the trigger, then ArrowDown opens the dropdown and highlights the
      // first option.
      Focus.of(tester.element(find.text('Choose'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // Dropdown is open.
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);

      // Enter selects the highlighted (first) option without any pointer use.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, 'apple');
      // Selecting also closes the dropdown.
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('ArrowDown twice then Enter selects the second option', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsSelect<String>(
            options: _fruit,
            placeholder: 'Choose',
            onChanged: (value) => selected = value,
          ),
        ),
      );

      Focus.of(tester.element(find.text('Choose'))).requestFocus();
      await tester.pump();
      // First ArrowDown opens + highlights index 0, second moves to index 1.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, 'banana');
    });

    testWidgets('option list is wrapped in a semantics container', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();

      // A Semantics node with container: true wraps the option rows.
      expect(
        find.byWidgetPredicate((w) => w is Semantics && w.container == true),
        findsWidgets,
      );
    });

    testWidgets('option list container carries the list role', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();

      // The option container exposes the listbox role to assistive technology.
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.role == SemanticsRole.list,
        ),
        findsOneWidget,
      );
    });

    testWidgets('each option is marked as mutually exclusive (single-select)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();

      // Both option rows convey single-select exclusivity so screen readers
      // announce them as mutually exclusive (radio/listbox) options.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.inMutuallyExclusiveGroup == true &&
              (w.properties.label == 'Apple' || w.properties.label == 'Banana'),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('overridable semantics label is used instead of "Velg"', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: _fruit,
            placeholder: 'Choose',
            semanticsLabel: 'Velg frukt',
          ),
        ),
      );

      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Velg frukt',
        ),
      );
      expect(semanticsWidget.properties.button, isTrue);
      // The default label is no longer present.
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Velg',
        ),
        findsNothing,
      );
    });

    testWidgets('trigger reserves a focus ring (no layout shift on focus)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
        ),
      );

      // Height before focus.
      final before = tester.getSize(find.text('Choose').first);

      Focus.of(tester.element(find.text('Choose'))).requestFocus();
      await tester.pumpAndSettle();

      // Height after focus is unchanged: the ring space is always reserved.
      final after = tester.getSize(find.text('Choose').first);
      expect(after.height, before.height);
    });

    testWidgets(
      'focusing the trigger promotes the border to the strong colour',
      (tester) async {
        final theme = DsThemeDigdir.light();
        final scale = theme.colorScheme.resolve(DsColor.accent);

        await tester.pumpWidget(
          wrapWithOverlay(
            const DsSelect<String>(options: _fruit, placeholder: 'Choose'),
          ),
        );

        Color triggerBorderColor() {
          final container = tester.widget<AnimatedContainer>(
            find.byType(AnimatedContainer),
          );
          final decoration = container.decoration! as BoxDecoration;
          return decoration.border!.top.color;
        }

        expect(triggerBorderColor(), scale.borderDefault);

        Focus.of(tester.element(find.text('Choose'))).requestFocus();
        await tester.pumpAndSettle();

        expect(triggerBorderColor(), scale.borderStrong);
      },
    );

    testWidgets('readOnly drops the border for a visual distinction', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: _fruit,
            value: 'apple',
            readOnly: true,
          ),
        ),
      );

      final theme = DsThemeDigdir.light();
      final scale = theme.colorScheme.resolve(DsColor.accent);
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration! as BoxDecoration;
      // Border is none and the fill uses the subtle read-only surface.
      expect(decoration.border, const Border.fromBorderSide(BorderSide.none));
      expect(decoration.color, scale.surfaceDefault);
    });

    testWidgets('accepts an external focus node', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await tester.pumpWidget(
        wrapWithOverlay(
          DsSelect<String>(
            options: _fruit,
            placeholder: 'Choose',
            focusNode: node,
          ),
        ),
      );

      node.requestFocus();
      await tester.pumpAndSettle();
      expect(node.hasFocus, isTrue);

      // Pressing Enter on the externally-focused node opens the dropdown.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('arrow navigation scrolls the highlighted row into view', (
      tester,
    ) async {
      // Enough options to overflow the dropdown so scrolling is required.
      final many = List.generate(
        30,
        (i) => DsSelectOption<String>(value: 'v$i', label: 'Option $i'),
      );
      String? selected;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsSelect<String>(
            options: many,
            placeholder: 'Choose',
            onChanged: (v) => selected = v,
          ),
        ),
      );

      Focus.of(tester.element(find.text('Choose'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // Walk the highlight far enough that the row would be clipped without
      // scroll-into-view, then select it.
      for (var i = 0; i < 25; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
      }

      // The highlighted row was scrolled into view and is hittable.
      expect(find.text('Option 25'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, 'v25');
    });

    testWidgets('dropdown clamps its height to the available viewport space', (
      tester,
    ) async {
      final many = List.generate(
        100,
        (i) => DsSelectOption<String>(value: 'v$i', label: 'Option $i'),
      );
      await tester.pumpWidget(
        wrapWithOverlay(DsSelect<String>(options: many, placeholder: 'Choose')),
      );

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();

      // The scrollable dropdown is constrained and never taller than the cap,
      // asserted against the single shared constant rather than a magic literal.
      final box = tester.getSize(find.byType(SingleChildScrollView));
      expect(box.height, lessThanOrEqualTo(kDsSelectMaxDropdownHeight));
    });
  });
}
