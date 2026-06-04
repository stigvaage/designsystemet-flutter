import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
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

    testWidgets('error state renders with DsSelect', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect<String>(
            options: [DsSelectOption<String>(value: 'a', label: 'A')],
            error: 'Required',
          ),
        ),
      );
      expect(find.byType(DsSelect<String>), findsOneWidget);
    });

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
  });
}
