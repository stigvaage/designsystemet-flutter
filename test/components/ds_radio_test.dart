import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/components/radio/ds_radio.dart';
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

  group('DsRadio', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            label: const Text('Velg meg'),
          ),
        ),
      );
      expect(find.text('Velg meg'), findsOneWidget);
    });

    testWidgets('calls onChanged with toggled value when tapped', (
      tester,
    ) async {
      bool? changedTo;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (v) => changedTo = v,
            label: const Text('Radio'),
          ),
        ),
      );
      await tester.tap(find.byType(DsRadio));
      expect(changedTo, isTrue);
    });

    testWidgets('tapping the label TEXT selects the radio', (tester) async {
      bool? changedTo;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (v) => changedTo = v,
            label: const Text('Velg dette'),
          ),
        ),
      );
      // Tapping the associated label text (not the circle) must select it.
      await tester.tap(find.text('Velg dette'));
      expect(changedTo, isTrue);
    });

    testWidgets('does not call onChanged when readOnly', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) => called = true,
            readOnly: true,
            label: const Text('Skrivebeskyttet'),
          ),
        ),
      );
      await tester.tap(find.byType(DsRadio));
      expect(called, isFalse);
    });

    testWidgets('outline variant wraps control in a bordered container', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            variant: DsSelectionVariant.outline,
            label: const Text('Outline'),
          ),
        ),
      );
      // The outline wrapper is the Container with padding EdgeInsets.all(12)
      // (distinct from the radio circle, which has no padding).
      final hasOutlineWrapper = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) => c.padding == const EdgeInsets.all(12));
      expect(hasOutlineWrapper, isTrue);
    });

    testWidgets('default variant does not add an outline container', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            label: const Text('Default'),
          ),
        ),
      );
      // The default rendering does not add the outline wrapper
      // (no Container with padding EdgeInsets.all(12)).
      final hasOutlineWrapper = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) => c.padding == const EdgeInsets.all(12));
      expect(hasOutlineWrapper, isFalse);
    });
  });
}
