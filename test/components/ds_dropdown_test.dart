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
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) => Align(alignment: Alignment.topLeft, child: child),
          ),
        ],
      ),
    ),
  );
}

void main() {
  group('DsDropdown', () {
    testWidgets('renders trigger widget', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsDropdown(
            trigger: Text('Open'),
            items: [DsDropdownItem(label: 'Item 1')],
          ),
        ),
      );
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('opens menu on trigger tap', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsDropdown(
            trigger: Text('Open'),
            items: [
              DsDropdownItem(label: 'Alpha'),
              DsDropdownItem(label: 'Beta'),
            ],
          ),
        ),
      );
      expect(find.text('Alpha'), findsNothing);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      // Close before teardown to prevent setState-during-dispose
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    });

    testWidgets('onSelected called with correct index', (tester) async {
      var selectedIndex = -1;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            items: const [
              DsDropdownItem(label: 'A'),
              DsDropdownItem(label: 'B'),
            ],
            onSelected: (i) => selectedIndex = i,
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      expect(selectedIndex, 1);
      // Selection closes dropdown
    });

    testWidgets('closes after item selection', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            items: const [DsDropdownItem(label: 'Item')],
            onSelected: (_) {},
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Item'), findsOneWidget);
      await tester.tap(find.text('Item'));
      await tester.pumpAndSettle();
      expect(find.text('Item'), findsNothing);
    });

    testWidgets('has expanded semantics that toggles', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsDropdown(
            trigger: Text('Open'),
            items: [DsDropdownItem(label: 'X')],
          ),
        ),
      );
      final expandedSemantics = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.expanded != null,
      );
      var semanticsWidget = tester.widget<Semantics>(expandedSemantics);
      expect(semanticsWidget.properties.expanded, isFalse);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      semanticsWidget = tester.widget<Semantics>(expandedSemantics);
      expect(semanticsWidget.properties.expanded, isTrue);

      // Close before teardown
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    });

    testWidgets('per-item onTap fires alongside onSelected', (tester) async {
      var indexFromOnSelected = -1;
      var tappedLabel = '';
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            onSelected: (i) => indexFromOnSelected = i,
            items: [
              DsDropdownItem(label: 'A', onTap: () => tappedLabel = 'A'),
              DsDropdownItem(label: 'B', onTap: () => tappedLabel = 'B'),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(tappedLabel, 'B');
      expect(indexFromOnSelected, 1);
      // onTap selection closes the menu.
      expect(find.text('A'), findsNothing);
    });

    testWidgets('per-item onTap works without onSelected', (tester) async {
      var tappedLabel = '';
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            items: [
              DsDropdownItem(label: 'A', onTap: () => tappedLabel = 'A'),
              DsDropdownItem(label: 'B', onTap: () => tappedLabel = 'B'),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      expect(tappedLabel, 'A');
    });

    testWidgets('disabled item does not fire onTap or onSelected', (
      tester,
    ) async {
      var indexFromOnSelected = -1;
      var tapped = false;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            onSelected: (i) => indexFromOnSelected = i,
            items: [
              const DsDropdownItem(label: 'A'),
              DsDropdownItem(
                label: 'B',
                enabled: false,
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
      expect(indexFromOnSelected, -1);
      // Menu stays open because the disabled item did nothing.
      expect(find.text('A'), findsOneWidget);

      // Close before teardown.
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    });

    testWidgets('ArrowDown opens and Enter activates the first item', (
      tester,
    ) async {
      var selectedIndex = -1;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            onSelected: (i) => selectedIndex = i,
            items: const [
              DsDropdownItem(label: 'A'),
              DsDropdownItem(label: 'B'),
            ],
          ),
        ),
      );

      Focus.of(tester.element(find.text('Open'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      expect(find.text('A'), findsNothing);
    });

    testWidgets('ArrowDown twice then Enter activates the second item', (
      tester,
    ) async {
      var selectedIndex = -1;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            onSelected: (i) => selectedIndex = i,
            items: const [
              DsDropdownItem(label: 'A'),
              DsDropdownItem(label: 'B'),
            ],
          ),
        ),
      );

      Focus.of(tester.element(find.text('Open'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('ArrowDown skips a disabled item', (tester) async {
      var selectedIndex = -1;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            onSelected: (i) => selectedIndex = i,
            items: const [
              DsDropdownItem(label: 'A'),
              DsDropdownItem(label: 'B', enabled: false),
              DsDropdownItem(label: 'C'),
            ],
          ),
        ),
      );

      Focus.of(tester.element(find.text('Open'))).requestFocus();
      await tester.pump();
      // First ArrowDown opens + highlights A (index 0); second jumps over the
      // disabled B (index 1) to C (index 2).
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selectedIndex, 2);
    });

    testWidgets('Escape closes the menu', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsDropdown(
            trigger: Text('Open'),
            items: [DsDropdownItem(label: 'A')],
          ),
        ),
      );

      Focus.of(tester.element(find.text('Open'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('A'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('A'), findsNothing);
    });

    testWidgets('honours an external focusNode', (tester) async {
      final node = FocusNode();
      var selectedIndex = -1;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsDropdown(
            trigger: const Text('Open'),
            focusNode: node,
            onSelected: (i) => selectedIndex = i,
            items: const [
              DsDropdownItem(label: 'A'),
              DsDropdownItem(label: 'B'),
            ],
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      node.dispose();
    });

    testWidgets('size prop applies the canonical font size', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsDropdown(
            trigger: Text('Open'),
            size: DsSize.lg,
            items: [DsDropdownItem(label: 'A')],
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('A'));
      expect(text.style?.fontSize, 18.0);

      // Close before teardown.
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    });

    testWidgets('disposing while open does not throw', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsDropdown(
            trigger: Text('Open'),
            items: [DsDropdownItem(label: 'A')],
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('A'), findsOneWidget);

      // Replace the whole tree so the DsDropdown is disposed while still open.
      await tester.pumpWidget(wrapWithOverlay(const SizedBox.shrink()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
