import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithOverlay(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) => Align(
              alignment: Alignment.topLeft,
              child: child,
            ),
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
  });
}
