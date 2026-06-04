import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsCheckbox', () {
    testWidgets('toggles value when tapped', (tester) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (v) => newValue = v,
            label: const Text('Accept'),
          ),
        ),
      );
      await tester.tap(find.byType(DsCheckbox));
      expect(newValue, isTrue);
    });

    testWidgets('tapping the label TEXT toggles the checkbox', (tester) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (v) => newValue = v,
            label: const Text('Godta vilkår'),
          ),
        ),
      );
      // Tapping the associated label text (not the box) must toggle it.
      await tester.tap(find.text('Godta vilkår'));
      expect(newValue, isTrue);
    });

    testWidgets('outline variant renders bordered container with borderSubtle '
        'when unchecked', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            label: const Text('Outline'),
            variant: DsSelectionVariant.outline,
          ),
        ),
      );

      final hasOutlineBorder = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) {
            final decoration = c.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top.color == colorScale.borderSubtle &&
                border.top.width == 1;
          });
      expect(hasOutlineBorder, isTrue);
    });

    testWidgets('outline variant uses baseDefault border when checked', (
      tester,
    ) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: true,
            onChanged: (_) {},
            label: const Text('Outline'),
            variant: DsSelectionVariant.outline,
          ),
        ),
      );

      final hasCheckedBorder = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) {
            final decoration = c.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top.color == colorScale.baseDefault &&
                border.top.width == 1;
          });
      expect(hasCheckedBorder, isTrue);
    });

    testWidgets('outline variant toggles when tapping the padding zone', (
      tester,
    ) async {
      bool? newValue;
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (v) => newValue = v,
            variant: DsSelectionVariant.outline,
            label: const Text('Outline'),
          ),
        ),
      );
      final rect = tester.getRect(find.byType(DsCheckbox));
      await tester.tapAt(rect.topLeft + const Offset(4, 4));
      expect(newValue, isTrue);
    });

    testWidgets('does not call onChanged when readOnly', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) => called = true,
            readOnly: true,
            label: const Text('RO'),
          ),
        ),
      );
      await tester.tap(find.byType(DsCheckbox));
      expect(called, isFalse);
    });

    testWidgets('indeterminate reports mixed tri-state semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            indeterminate: true,
            label: const Text('Mixed'),
          ),
        ),
      );

      final hasMixedSemantics = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any(
            (s) => s.properties.mixed == true && s.properties.checked != true,
          );
      expect(hasMixedSemantics, isTrue);
    });

    testWidgets('non-indeterminate does not report mixed semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: true,
            onChanged: (_) {},
            label: const Text('Checked'),
          ),
        ),
      );

      final hasCheckedSemantics = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any(
            (s) => s.properties.checked == true && s.properties.mixed != true,
          );
      expect(hasCheckedSemantics, isTrue);
    });
  });
}
