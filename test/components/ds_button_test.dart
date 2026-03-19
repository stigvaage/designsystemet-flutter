import 'dart:ui' show SemanticsFlag;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';
import 'package:komponentbibliotek_flutter/src/components/button/ds_button.dart';

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
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.3);
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
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
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
