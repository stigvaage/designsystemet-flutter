import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/components/toggle_group/ds_toggle_group.dart';
import 'package:designsystemet_flutter/theme.dart';
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
  });
}
