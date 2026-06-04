import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/components/toggle_group/ds_toggle_group.dart';
import 'package:designsystemet_flutter/src/utils/ds_focus.dart';
import 'package:designsystemet_flutter/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return DsTheme(
      data: DsThemeDigdir.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  group('DsToggleGroup', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two', 'Three'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
    });

    testWidgets('calls onChanged with index when an item is tapped', (
      tester,
    ) async {
      int? changed;
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two', 'Three'],
            selectedIndex: 0,
            onChanged: (i) => changed = i,
          ),
        ),
      );
      await tester.tap(find.text('Two'));
      expect(changed, 1);
    });

    testWidgets('primary variant fills selected item with base color', (
      tester,
    ) async {
      final scale = DsThemeDigdir.light().colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two'],
            selectedIndex: 0,
            onChanged: (_) {},
            color: DsColor.accent,
          ),
        ),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, scale.baseDefault);
    });

    testWidgets(
      'secondary variant renders with surface fill on selected item',
      (tester) async {
        final scale = DsThemeDigdir.light().colorScheme.resolve(DsColor.accent);
        await tester.pumpWidget(
          wrapWithTheme(
            DsToggleGroup(
              items: const ['One', 'Two'],
              selectedIndex: 0,
              onChanged: (_) {},
              color: DsColor.accent,
              variant: DsToggleGroupVariant.secondary,
            ),
          ),
        );
        expect(find.text('One'), findsOneWidget);
        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer).first,
        );
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, scale.surfaceActive);
      },
    );

    testWidgets('unselected segments have no fill in both variants', (
      tester,
    ) async {
      for (final variant in DsToggleGroupVariant.values) {
        await tester.pumpWidget(
          wrapWithTheme(
            DsToggleGroup(
              items: const ['One', 'Two'],
              selectedIndex: 0,
              onChanged: (_) {},
              variant: variant,
            ),
          ),
        );
        // The segment containing 'Two' is unselected → no background fill.
        final twoSegment = tester.widget<AnimatedContainer>(
          find
              .ancestor(
                of: find.text('Two'),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final decoration = twoSegment.decoration as BoxDecoration?;
        expect(
          decoration?.color,
          isNull,
          reason: 'unselected fill should be null for $variant',
        );
      }
    });

    testWidgets(
      'tapping a segment requests focus so arrow keys navigate afterwards',
      (tester) async {
        // Regression: previously a tap never requested focus, so the
        // KeyboardListener had no focus and arrow-key navigation did nothing
        // after a mouse/touch interaction.
        final changes = <int>[];
        await tester.pumpWidget(
          wrapWithTheme(
            DsToggleGroup(
              items: const ['One', 'Two', 'Three'],
              selectedIndex: 0,
              onChanged: changes.add,
            ),
          ),
        );

        // Activate the first segment by tap (mouse/touch path).
        await tester.tap(find.text('One'));
        await tester.pump();
        expect(changes, [0]);

        // The first segment's focus node should now hold focus, so an
        // ArrowRight moves selection to index 1.
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        expect(changes, [0, 1]);
      },
    );

    testWidgets('focused segment shows a focus ring', (tester) async {
      final scale = DsThemeDigdir.light().colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two'],
            selectedIndex: 0,
            onChanged: (_) {},
            color: DsColor.accent,
          ),
        ),
      );

      // No ring before focus.
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

      expect(hasRing('One'), isFalse);

      // Tap to focus the first segment → ring appears.
      await tester.tap(find.text('One'));
      await tester.pump();
      expect(hasRing('One'), isTrue);
      expect(hasRing('Two'), isFalse);
    });

    testWidgets(
      'reserves transparent focus ring space when unfocused to avoid overlap',
      (tester) async {
        // Regression (WCAG 2.4.7): the 3px focus ring used to paint flush
        // against the segment fill/text and the outer group border because no
        // ring space was reserved. Now a transparent ring (border + padding of
        // DsFocus.ringWidth) is always present, so the visible ring on focus
        // does not overlap content. Verify both states reserve the space.
        await tester.pumpWidget(
          wrapWithTheme(
            DsToggleGroup(
              items: const ['One', 'Two'],
              selectedIndex: 0,
              onChanged: (_) {},
              color: DsColor.accent,
            ),
          ),
        );

        // The DecoratedBox wrapping a segment must have a 3px border (so ring
        // space is reserved) and a child Padding of 3px on all sides.
        bool reservesRingSpace(String label) {
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
            if (border.top.width != DsFocus.ringWidth) return false;
            final child = box.child;
            if (child is! Padding) return false;
            return child.padding == const EdgeInsets.all(DsFocus.ringWidth);
          });
        }

        // Unfocused segment still reserves the ring space (transparent border).
        expect(reservesRingSpace('Two'), isTrue);

        // Focused segment also has padded ring space (now with a visible ring).
        await tester.tap(find.text('One'));
        await tester.pump();
        expect(reservesRingSpace('One'), isTrue);
      },
    );

    testWidgets('segments expose button semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('One')).flagsCollection.isButton,
        isTrue,
      );
      expect(
        tester.getSemantics(find.text('Two')).flagsCollection.isButton,
        isTrue,
      );
    });

    testWidgets('growing items.length does not throw a RangeError', (
      tester,
    ) async {
      // Regression: focus nodes were only built in initState. Adding items
      // used to index past the original list length and throw RangeError.
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two', 'Three', 'Four'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Four'), findsOneWidget);

      // The freshly added segment is still keyboard-navigable.
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two', 'Three', 'Four'],
            selectedIndex: 0,
            onChanged: changes.add,
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

    testWidgets('shrinking items.length does not throw', (tester) async {
      // Regression: stale focus nodes used to leak / index out of range when
      // the item list shrank.
      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One', 'Two', 'Three'],
            selectedIndex: 2,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.pumpWidget(
        wrapWithTheme(
          DsToggleGroup(
            items: const ['One'],
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Two'), findsNothing);
      expect(find.text('Three'), findsNothing);
      expect(find.text('One'), findsOneWidget);
    });
  });
}
