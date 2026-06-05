import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/utils/ds_focus.dart';
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
  group('DsTabs', () {
    testWidgets('renders all tab labels and the initial panel', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two'],
            children: [Text('Panel one'), Text('Panel two')],
          ),
        ),
      );
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Panel one'), findsOneWidget);
    });

    testWidgets('tapping a tab calls onChanged with its index', (tester) async {
      int? changed;
      await tester.pumpWidget(
        wrapWithTheme(
          DsTabs(
            tabs: const ['One', 'Two'],
            children: const [Text('Panel one'), Text('Panel two')],
            onChanged: (i) => changed = i,
          ),
        ),
      );
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(changed, 1);
    });

    testWidgets(
      'tapping a tab requests focus so arrow keys navigate afterwards',
      (tester) async {
        // Regression: previously a tap never requested focus, so the per-tab
        // Focus node had no focus and arrow-key navigation did nothing after a
        // mouse/touch interaction.
        final changes = <int>[];
        await tester.pumpWidget(
          wrapWithTheme(
            DsTabs(
              tabs: const ['One', 'Two', 'Three'],
              onChanged: changes.add,
              children: const [
                Text('Panel one'),
                Text('Panel two'),
                Text('Panel three'),
              ],
            ),
          ),
        );

        // Activate the first tab by tap (mouse/touch path).
        await tester.tap(find.text('One'));
        await tester.pump();
        expect(changes, [0]);

        // The first tab now holds focus, so ArrowRight moves selection to 1.
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        expect(changes, [0, 1]);
        expect(find.text('Panel two'), findsOneWidget);
      },
    );

    testWidgets('ArrowRight/ArrowLeft navigate and wrap around', (
      tester,
    ) async {
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          DsTabs(
            tabs: const ['One', 'Two', 'Three'],
            onChanged: changes.add,
            children: const [
              Text('Panel one'),
              Text('Panel two'),
              Text('Panel three'),
            ],
          ),
        ),
      );

      // Focus the first tab, then ArrowLeft wraps to the last tab.
      await tester.tap(find.text('One'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(changes, [0, 2]);
      expect(find.text('Panel three'), findsOneWidget);

      // ArrowRight from the last tab wraps back to the first.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(changes, [0, 2, 0]);
      expect(find.text('Panel one'), findsOneWidget);
    });

    testWidgets('Home and End jump to the first and last tab', (tester) async {
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          DsTabs(
            tabs: const ['One', 'Two', 'Three'],
            onChanged: changes.add,
            children: const [
              Text('Panel one'),
              Text('Panel two'),
              Text('Panel three'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('One'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(changes, [0, 2]);
      expect(find.text('Panel three'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(changes, [0, 2, 0]);
      expect(find.text('Panel one'), findsOneWidget);
    });

    testWidgets('focused tab shows a focus ring (WCAG 2.4.7)', (tester) async {
      final scale = DsThemeDigdir.light().colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two'],
            color: DsColor.accent,
            children: [Text('Panel one'), Text('Panel two')],
          ),
        ),
      );

      bool hasRing(String label) {
        final boxes = tester
            .widgetList<DecoratedBox>(
              find.ancestor(
                of: find.text(label),
                matching: find.byType(DecoratedBox),
              ),
            )
            .toList();
        return boxes.any((box) {
          final decoration = box.decoration;
          if (decoration is! BoxDecoration) return false;
          final border = decoration.border;
          if (border is! Border) return false;
          return border.top.color == scale.borderStrong &&
              border.top.width == DsFocus.ringWidth;
        });
      }

      // No ring before focus.
      expect(hasRing('One'), isFalse);

      // Tap to focus the first tab → ring appears.
      await tester.tap(find.text('One'));
      await tester.pump();
      expect(hasRing('One'), isTrue);
      expect(hasRing('Two'), isFalse);
    });

    testWidgets('tabs expose button + selected semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two'],
            initialIndex: 0,
            children: [Text('Panel one'), Text('Panel two')],
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('One')).flagsCollection.isButton,
        isTrue,
      );

      // The selected tab exposes selected: true; the other exposes selected:
      // false. Match on the Semantics widget properties directly.
      bool selectedFlag(String label) {
        final semantics = find.ancestor(
          of: find.text(label),
          matching: find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.selected != null,
          ),
        );
        final widget = tester.widget<Semantics>(semantics.first);
        return widget.properties.selected!;
      }

      expect(selectedFlag('One'), isTrue);
      expect(selectedFlag('Two'), isFalse);
    });

    testWidgets('growing tabs.length does not throw a RangeError', (
      tester,
    ) async {
      // Regression: focus nodes were only built in initState. Adding tabs used
      // to index past the original list length and throw RangeError.
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two'],
            children: [Text('Panel one'), Text('Panel two')],
          ),
        ),
      );

      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two', 'Three', 'Four'],
            children: [
              Text('Panel one'),
              Text('Panel two'),
              Text('Panel three'),
              Text('Panel four'),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Four'), findsOneWidget);

      // The freshly added tab is keyboard-navigable.
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          DsTabs(
            tabs: const ['One', 'Two', 'Three', 'Four'],
            onChanged: changes.add,
            children: const [
              Text('Panel one'),
              Text('Panel two'),
              Text('Panel three'),
              Text('Panel four'),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Four'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      // Index 3 (Four) wraps to index 0 with ArrowRight.
      expect(changes, [3, 0]);
    });

    testWidgets('shrinking tabs.length does not throw and clamps selection', (
      tester,
    ) async {
      // Select the last tab in a 3-tab list, then shrink to a single tab.
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two', 'Three'],
            initialIndex: 2,
            children: [
              Text('Panel one'),
              Text('Panel two'),
              Text('Panel three'),
            ],
          ),
        ),
      );
      expect(find.text('Panel three'), findsOneWidget);

      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(tabs: ['One'], children: [Text('Panel one')]),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Two'), findsNothing);
      expect(find.text('Three'), findsNothing);
      // Selection clamped into range → the remaining panel is shown.
      expect(find.text('Panel one'), findsOneWidget);
    });

    testWidgets('controlled value drives the selected tab', (tester) async {
      final changes = <int>[];

      Widget build(int value) {
        return wrapWithTheme(
          DsTabs(
            tabs: const ['One', 'Two', 'Three'],
            value: value,
            onChanged: changes.add,
            children: const [
              Text('Panel one'),
              Text('Panel two'),
              Text('Panel three'),
            ],
          ),
        );
      }

      await tester.pumpWidget(build(0));
      expect(find.text('Panel one'), findsOneWidget);

      // Tapping does not change the panel by itself in controlled mode; it only
      // reports via onChanged. The parent must update value.
      await tester.tap(find.text('Two'));
      await tester.pump();
      expect(changes, [1]);
      // Panel unchanged because value is still 0.
      expect(find.text('Panel one'), findsOneWidget);

      // Parent applies the change.
      await tester.pumpWidget(build(1));
      expect(find.text('Panel two'), findsOneWidget);
    });
  });
}
