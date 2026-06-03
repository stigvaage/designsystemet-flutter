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
  });
}
