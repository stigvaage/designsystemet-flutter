import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/components/radio/ds_radio.dart';
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

    testWidgets('tapping an already-selected radio does NOT deselect it', (
      tester,
    ) async {
      bool? changedTo;
      var callCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: true,
            onChanged: (v) {
              changedTo = v;
              callCount++;
            },
            label: const Text('Allerede valgt'),
          ),
        ),
      );
      await tester.tap(find.byType(DsRadio));
      // Radio selection is idempotent: re-activating must not call
      // onChanged(false) (which would leave the group with nothing selected).
      expect(callCount, 0);
      expect(changedTo, isNull);
    });

    testWidgets(
      'pressing Space on an already-selected radio does NOT deselect',
      (tester) async {
        bool? changedTo;
        var callCount = 0;
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await tester.pumpWidget(
          wrapWithTheme(
            DsRadio(
              value: true,
              onChanged: (v) {
                changedTo = v;
                callCount++;
              },
              focusNode: focusNode,
              label: const Text('Allerede valgt'),
            ),
          ),
        );
        focusNode.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(callCount, 0);
        expect(changedTo, isNull);
      },
    );

    testWidgets('pressing Space on an unselected radio selects it', (
      tester,
    ) async {
      bool? changedTo;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (v) => changedTo = v,
            focusNode: focusNode,
            label: const Text('Velg med tastatur'),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
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

    testWidgets('outline variant selects when tapping the padding zone', (
      tester,
    ) async {
      bool? changedTo;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (v) => changedTo = v,
            variant: DsSelectionVariant.outline,
            label: const Text('Outline'),
          ),
        ),
      );
      final rect = tester.getRect(find.byType(DsRadio));
      await tester.tapAt(rect.topLeft + const Offset(4, 4));
      expect(changedTo, isTrue);
    });

    testWidgets('outline checked uses baseDefault border color', (
      tester,
    ) async {
      final scale = DsThemeDigdir.light().colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: true,
            onChanged: (_) {},
            variant: DsSelectionVariant.outline,
            label: const Text('On'),
          ),
        ),
      );
      final outline = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.padding == const EdgeInsets.all(12));
      expect(
        ((outline.decoration as BoxDecoration).border! as Border).top.color,
        scale.baseDefault,
      );
    });

    testWidgets('renders the error message text below the control', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            error: 'Du må velge et alternativ',
            label: const Text('Velg'),
          ),
        ),
      );
      expect(find.text('Du må velge et alternativ'), findsOneWidget);
    });

    testWidgets('error message is announced via a live region', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            error: 'Påkrevd felt',
            label: const Text('Velg'),
          ),
        ),
      );
      final liveRegion = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.liveRegion == true,
      );
      expect(liveRegion, findsOneWidget);
    });

    testWidgets('error state uses the danger scale for the circle border', (
      tester,
    ) async {
      final danger = DsThemeDigdir.light().colorScheme.danger;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            error: 'Feil',
            label: const Text('Velg'),
          ),
        ),
      );
      // The radio circle is a circular Container with a 1.5px border.
      final circle = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) {
            final d = c.decoration;
            return d is BoxDecoration && d.shape == BoxShape.circle;
          });
      final border = (circle.decoration as BoxDecoration).border! as Border;
      expect(border.top.color, danger.borderDefault);
    });

    testWidgets('no error message when error is null', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(value: false, onChanged: (_) {}, label: const Text('Velg')),
        ),
      );
      final liveRegion = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.liveRegion == true,
      );
      expect(liveRegion, findsNothing);
    });

    testWidgets('disabled does not call onChanged when tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) => called = true,
            disabled: true,
            label: const Text('Deaktivert'),
          ),
        ),
      );
      // A disabled radio is wrapped in IgnorePointer, so the tap does not hit
      // it (warnIfMissed: false) and onChanged is never called.
      await tester.tap(find.byType(DsRadio), warnIfMissed: false);
      expect(called, isFalse);
    });

    testWidgets('disabled dims the control with disabledOpacity', (
      tester,
    ) async {
      final opacity = DsThemeDigdir.light().disabledOpacity;
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            disabled: true,
            label: const Text('Deaktivert'),
          ),
        ),
      );
      final dimmed = tester.widget<Opacity>(find.byType(Opacity));
      expect(dimmed.opacity, opacity);
      // Disabled controls also block pointer interaction.
      expect(find.byType(IgnorePointer), findsOneWidget);
    });

    testWidgets('enabled control does not wrap in Opacity', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(value: false, onChanged: (_) {}, label: const Text('Aktiv')),
        ),
      );
      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('null onChanged is treated as non-interactive (Space no-op)', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: null,
            focusNode: focusNode,
            label: const Text('Uten handler'),
          ),
        ),
      );
      // A non-interactive radio cannot take focus, so Space cannot select it.
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('non-interactive radio reports enabled: false in semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsRadio(
            value: false,
            onChanged: null,
            label: Text('Uten handler'),
          ),
        ),
      );
      final enabledFalse = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.enabled == false,
      );
      expect(enabledFalse, findsWidgets);
    });

    testWidgets('autofocus requests focus on build', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            autofocus: true,
            focusNode: focusNode,
            label: const Text('Autofokus'),
          ),
        ),
      );
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('selected state is reflected in semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(value: true, onChanged: (_) {}, label: const Text('Valgt')),
        ),
      );
      final selected = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.selected == true,
      );
      expect(selected, findsWidgets);
    });

    testWidgets(
      'radio role is announced via inMutuallyExclusiveGroup + checked',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DsRadio(value: true, onChanged: (_) {}, label: const Text('Valgt')),
          ),
        );
        final radioRole = find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.inMutuallyExclusiveGroup == true &&
              w.properties.checked == true,
        );
        expect(radioRole, findsWidgets);
      },
    );

    testWidgets('unchecked radio reports checked: false in semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            label: const Text('Ikke valgt'),
          ),
        ),
      );
      final unchecked = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.inMutuallyExclusiveGroup == true &&
            w.properties.checked == false,
      );
      expect(unchecked, findsWidgets);
    });

    testWidgets('error is exposed as the control semantics hint', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(
            value: false,
            onChanged: (_) {},
            error: 'Du må velge et alternativ',
            label: const Text('Velg'),
          ),
        ),
      );
      final withHint = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.inMutuallyExclusiveGroup == true &&
            w.properties.hint == 'Du må velge et alternativ',
      );
      expect(withHint, findsWidgets);
    });
  });
}
