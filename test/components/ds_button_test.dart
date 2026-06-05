import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/components/button/ds_button.dart';
import 'package:designsystemet_flutter/src/components/spinner/ds_spinner.dart';
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

  group('DsButton', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(onPressed: () {}, child: const Text('Click me')),
        ),
      );
      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(onPressed: () => pressed = true, child: const Text('Tap')),
        ),
      );
      await tester.tap(find.byType(DsButton));
      expect(pressed, isTrue);
    });

    testWidgets('Enter activates a focused enabled button', (tester) async {
      var pressed = 0;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () => pressed++,
            focusNode: node,
            autofocus: true,
            child: const Text('Go'),
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(pressed, 1);
    });

    testWidgets('Space activates a focused enabled button', (tester) async {
      var pressed = 0;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () => pressed++,
            focusNode: node,
            autofocus: true,
            child: const Text('Go'),
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(pressed, 1);
    });

    testWidgets('disabled button ignores Enter/Space', (tester) async {
      var pressed = 0;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () => pressed++,
            disabled: true,
            focusNode: node,
            autofocus: true,
            child: const Text('Go'),
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(pressed, 0);
    });

    testWidgets('loading button ignores Enter/Space', (tester) async {
      var pressed = 0;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () => pressed++,
            loading: true,
            focusNode: node,
            autofocus: true,
            child: const Text('Go'),
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(pressed, 0);
    });

    testWidgets('null onPressed is treated as disabled', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsButton(child: Text('No handler'))),
      );
      // Disabled buttons dim to disabledOpacity via an Opacity wrapper.
      expect(find.byType(Opacity), findsOneWidget);
      // Tapping must not throw and there is nothing to call.
      await tester.tap(find.byType(DsButton));
      // The button semantics is marked disabled.
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.enabled == false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('autofocus requests focus on insert', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () {},
            autofocus: true,
            focusNode: focusNode,
            child: const Text('Auto'),
          ),
        ),
      );
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('loading announces "Laster" to assistive tech', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(onPressed: () {}, loading: true, child: const Text('Lagre')),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Laster',
        ),
        findsOneWidget,
      );
    });

    testWidgets('loading spinner uses the foreground/contrast color', (
      tester,
    ) async {
      final theme = DsThemeDigdir.light();
      final fgColor = theme.colorScheme
          .resolve(DsColor.accent)
          .baseContrastDefault;
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(onPressed: () {}, loading: true, child: const Text('Lagre')),
        ),
      );
      final spinner = tester.widget<DsSpinner>(find.byType(DsSpinner));
      // The spinner must paint with the visible contrast color, not the
      // (invisible) baseDefault used as the primary background.
      expect(spinner.paintColor, fgColor);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () => pressed = true,
            disabled: true,
            child: const Text('Disabled'),
          ),
        ),
      );
      await tester.tap(find.byType(DsButton));
      expect(pressed, isFalse);
    });

    testWidgets('disabled renders at 30% opacity', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () {},
            disabled: true,
            child: const Text('Disabled'),
          ),
        ),
      );
      final theme = DsThemeDigdir.light();
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, theme.disabledOpacity);
    });

    testWidgets('loading shows spinner and disables interaction', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () => pressed = true,
            loading: true,
            child: const Text('Loading'),
          ),
        ),
      );
      // Should not find the text (replaced by spinner)
      expect(find.text('Loading'), findsNothing);
      await tester.tap(find.byType(DsButton));
      expect(pressed, isFalse);
    });

    testWidgets('has button semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsButton(onPressed: () {}, child: const Text('Btn'))),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('secondary variant has border', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () {},
            variant: DsButtonVariant.secondary,
            child: const Text('Secondary'),
          ),
        ),
      );
      // The AnimatedContainer should have a border
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNotNull);
    });
  });
}
