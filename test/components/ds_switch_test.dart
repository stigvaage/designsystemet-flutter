import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/components/switch/ds_switch.dart';
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

  group('DsSwitch', () {
    testWidgets('toggles value via onChanged when tapped', (tester) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(DsSwitch(value: false, onChanged: (v) => newValue = v)),
      );
      await tester.tap(find.byType(DsSwitch));
      expect(newValue, isTrue);
    });

    testWidgets('tapping the label TEXT toggles the switch', (tester) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSwitch(
            value: false,
            onChanged: (v) => newValue = v,
            label: const Text('Mørk modus'),
          ),
        ),
      );
      // Tapping the associated label text (not the track) must toggle it.
      await tester.tap(find.text('Mørk modus'));
      expect(newValue, isTrue);
    });

    testWidgets('does not call onChanged when readOnly', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSwitch(
            value: false,
            readOnly: true,
            onChanged: (_) => called = true,
          ),
        ),
      );
      await tester.tap(find.byType(DsSwitch));
      expect(called, isFalse);
    });

    testWidgets('outline variant renders a bordered box', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsSwitch(
            value: false,
            onChanged: (_) {},
            variant: DsSelectionVariant.outline,
          ),
        ),
      );
      expect(find.byType(DsSwitch), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DsSwitch),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNotNull);
    });

    testWidgets('outline variant toggles when tapping the padding/border zone', (
      tester,
    ) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSwitch(
            value: false,
            onChanged: (v) => newValue = v,
            variant: DsSelectionVariant.outline,
            label: const Text('Outline'),
          ),
        ),
      );
      // Tap inside the 12px outline padding near the corner (outside the track).
      final rect = tester.getRect(find.byType(DsSwitch));
      await tester.tapAt(rect.topLeft + const Offset(4, 4));
      expect(newValue, isTrue);
    });

    testWidgets('outline border: borderSubtle when off, baseDefault when on', (
      tester,
    ) async {
      final scale = DsThemeDigdir.light().colorScheme.resolve(DsColor.accent);
      Color outlineBorderColor() {
        final c = tester
            .widgetList<Container>(find.byType(Container))
            .firstWhere((c) => c.padding == const EdgeInsets.all(12));
        return ((c.decoration as BoxDecoration).border! as Border).top.color;
      }

      await tester.pumpWidget(
        wrapWithTheme(
          DsSwitch(
            value: false,
            onChanged: (_) {},
            variant: DsSelectionVariant.outline,
          ),
        ),
      );
      expect(outlineBorderColor(), scale.borderSubtle);

      await tester.pumpWidget(
        wrapWithTheme(
          DsSwitch(
            value: true,
            onChanged: (_) {},
            variant: DsSelectionVariant.outline,
          ),
        ),
      );
      expect(outlineBorderColor(), scale.baseDefault);
    });

    testWidgets('default variant has no outline container', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsSwitch(value: false, onChanged: (_) {})),
      );
      final hasOutline = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) => c.padding == const EdgeInsets.all(12));
      expect(hasOutline, isFalse);
    });
  });
}
