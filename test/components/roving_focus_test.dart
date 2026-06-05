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
  group('Roving focus', () {
    testWidgets('DsTabs changes selection on tap', (tester) async {
      var selectedTab = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return DsTabs(
                tabs: const ['A', 'B', 'C'],
                initialIndex: selectedTab,
                onChanged: (i) => setState(() => selectedTab = i),
                children: const [
                  Text('Panel A'),
                  Text('Panel B'),
                  Text('Panel C'),
                ],
              );
            },
          ),
        ),
      );
      expect(selectedTab, 0);
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selectedTab, 1);
    });

    // --- Roving focus: keyboard navigation (WAI-ARIA Tabs / WCAG 2.1.1) -----

    testWidgets('DsTabs ArrowRight moves selection and wraps to first', (
      tester,
    ) async {
      var selectedTab = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return DsTabs(
                tabs: const ['A', 'B', 'C'],
                value: selectedTab,
                onChanged: (i) => setState(() => selectedTab = i),
                children: const [
                  Text('Panel A'),
                  Text('Panel B'),
                  Text('Panel C'),
                ],
              );
            },
          ),
        ),
      );

      // Seat keyboard focus on the first tab (tap requests focus on its node),
      // so subsequent arrow keys route to the tab's key handler.
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(selectedTab, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(selectedTab, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(selectedTab, 2);

      // Wraps from the last tab back to the first.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(selectedTab, 0);
    });

    testWidgets('DsTabs ArrowLeft wraps from first to last', (tester) async {
      var selectedTab = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return DsTabs(
                tabs: const ['A', 'B', 'C'],
                value: selectedTab,
                onChanged: (i) => setState(() => selectedTab = i),
                children: const [
                  Text('Panel A'),
                  Text('Panel B'),
                  Text('Panel C'),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pump();
      expect(selectedTab, 0);

      // From the first tab, ArrowLeft wraps to the last.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(selectedTab, 2);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(selectedTab, 1);
    });

    testWidgets('DsTabs Home/End jump to first and last tab', (tester) async {
      var selectedTab = 1;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return DsTabs(
                tabs: const ['A', 'B', 'C'],
                value: selectedTab,
                onChanged: (i) => setState(() => selectedTab = i),
                children: const [
                  Text('Panel A'),
                  Text('Panel B'),
                  Text('Panel C'),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selectedTab, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(selectedTab, 2);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(selectedTab, 0);
    });

    testWidgets('DsTabs shows correct panel for selected tab', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['First', 'Second'],
            initialIndex: 0,
            children: [Text('Content 1'), Text('Content 2')],
          ),
        ),
      );
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
    });

    testWidgets('DsToggleGroup changes selection on tap', (tester) async {
      var selected = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return DsToggleGroup(
                items: const ['X', 'Y', 'Z'],
                selectedIndex: selected,
                onChanged: (i) => setState(() => selected = i),
              );
            },
          ),
        ),
      );
      expect(selected, 0);
      await tester.tap(find.text('Y'));
      await tester.pump();
      expect(selected, 1);
    });
  });
}
