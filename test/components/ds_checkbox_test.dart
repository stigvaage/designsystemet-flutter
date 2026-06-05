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

    testWidgets('error renders the message below the control', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            label: const Text('Godta'),
            error: 'Du må godta vilkårene',
          ),
        ),
      );

      expect(find.byType(DsValidationMessage), findsOneWidget);
      expect(find.text('Du må godta vilkårene'), findsOneWidget);
    });

    testWidgets('error renders the box with the danger border', (tester) async {
      final theme = DsThemeDigdir.light();
      final dangerScale = theme.colorScheme.resolve(DsColor.danger);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            label: const Text('Godta'),
            error: 'Påkrevd',
          ),
        ),
      );

      final hasDangerBorder = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) {
            final decoration = c.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top.color == dangerScale.borderDefault &&
                border.top.width == 1.5;
          });
      expect(hasDangerBorder, isTrue);
    });

    testWidgets('error message is wrapped in a live region', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            label: const Text('Godta'),
            error: 'Påkrevd',
          ),
        ),
      );

      final hasLiveRegion = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.liveRegion == true);
      expect(hasLiveRegion, isTrue);
    });

    testWidgets('error sets the semantics hint', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            label: const Text('Godta'),
            error: 'Påkrevd',
          ),
        ),
      );

      final hasHint = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.hint == 'Påkrevd');
      expect(hasHint, isTrue);
    });

    testWidgets('disabled does not call onChanged when tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) => called = true,
            disabled: true,
            label: const Text('Disabled'),
          ),
        ),
      );
      await tester.tap(find.byType(DsCheckbox));
      expect(called, isFalse);
    });

    testWidgets('disabled dims the control with theme opacity and ignores '
        'pointer', (tester) async {
      final theme = DsThemeDigdir.light();
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            disabled: true,
            label: const Text('Disabled'),
          ),
        ),
      );

      expect(find.byType(IgnorePointer), findsWidgets);
      final hasDimmedOpacity = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .any((o) => o.opacity == theme.disabledOpacity);
      expect(hasDimmedOpacity, isTrue);
    });

    testWidgets('disabled reports disabled semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            disabled: true,
            label: const Text('Disabled'),
          ),
        ),
      );

      final hasDisabledSemantics = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.enabled == false);
      expect(hasDisabledSemantics, isTrue);
    });

    testWidgets('null onChanged makes the checkbox non-interactive', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsCheckbox(value: false, onChanged: null, label: Text('Inert')),
        ),
      );
      // Tapping must not throw and must leave the value unchanged (no callback
      // to observe — the absence of an error is the assertion here).
      await tester.tap(find.byType(DsCheckbox));
      await tester.pump();
      expect(find.byType(DsCheckbox), findsOneWidget);
    });

    testWidgets('null onChanged reports disabled semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsCheckbox(value: false, onChanged: null, label: Text('Inert')),
        ),
      );

      // A null handler is folded into the enabled flag (like disabled/readOnly),
      // so assistive tech must announce the control as disabled.
      final hasDisabledSemantics = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.enabled == false);
      expect(hasDisabledSemantics, isTrue);
    });

    testWidgets('readOnly reports disabled semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            readOnly: true,
            label: const Text('RO'),
          ),
        ),
      );

      final hasDisabledSemantics = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.enabled == false);
      expect(hasDisabledSemantics, isTrue);
    });

    testWidgets('pressing Space toggles the checkbox', (tester) async {
      bool? newValue;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (v) => newValue = v,
            focusNode: focusNode,
            label: const Text('Godta'),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(newValue, isTrue);
    });

    testWidgets('pressing Enter does NOT toggle the checkbox', (tester) async {
      bool? newValue;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (v) => newValue = v,
            focusNode: focusNode,
            label: const Text('Godta'),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      // The handler is deliberately Space-only; Enter must be ignored.
      expect(newValue, isNull);
    });

    testWidgets('pressing Space is a no-op when readOnly', (tester) async {
      var called = false;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) => called = true,
            readOnly: true,
            focusNode: focusNode,
            label: const Text('RO'),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(called, isFalse);
    });

    testWidgets(
      'disabled/readOnly/null-handler checkbox cannot request focus',
      (tester) async {
        final disabledNode = FocusNode();
        final readOnlyNode = FocusNode();
        final nullNode = FocusNode();
        addTearDown(disabledNode.dispose);
        addTearDown(readOnlyNode.dispose);
        addTearDown(nullNode.dispose);

        await tester.pumpWidget(
          wrapWithTheme(
            Column(
              children: [
                DsCheckbox(
                  value: false,
                  onChanged: (_) {},
                  disabled: true,
                  focusNode: disabledNode,
                  label: const Text('Disabled'),
                ),
                DsCheckbox(
                  value: false,
                  onChanged: (_) {},
                  readOnly: true,
                  focusNode: readOnlyNode,
                  label: const Text('ReadOnly'),
                ),
                DsCheckbox(
                  value: false,
                  onChanged: null,
                  focusNode: nullNode,
                  label: const Text('Null'),
                ),
              ],
            ),
          ),
        );

        // Non-interactive checkboxes are gated out of the Tab order via
        // canRequestFocus, mirroring DsRadio/DsSwitch.
        disabledNode.requestFocus();
        readOnlyNode.requestFocus();
        nullNode.requestFocus();
        await tester.pump();
        expect(disabledNode.hasFocus, isFalse);
        expect(readOnlyNode.hasFocus, isFalse);
        expect(nullNode.hasFocus, isFalse);
      },
    );

    testWidgets('autofocus focuses the control on first build', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(
            value: false,
            onChanged: (_) {},
            autofocus: true,
            focusNode: focusNode,
            label: const Text('Autofocus'),
          ),
        ),
      );
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
    });
  });
}
