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
  group('DsAvatar', () {
    testWidgets('renders initials from single name', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Jordan')));
      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('renders initials from full name', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAvatar(name: 'Jordan Vik')),
      );
      expect(find.text('JV'), findsOneWidget);
    });

    testWidgets('renders "?" when name is null', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar()));
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders "?" without exception when name is empty', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: '')));
      expect(tester.takeException(), isNull);
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders "?" without exception when name is whitespace only', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: '   ')));
      expect(tester.takeException(), isNull);
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders initials ignoring surrounding whitespace', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAvatar(name: '  Jordan   Vik  ')),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('JV'), findsOneWidget);
    });

    testWidgets('has image semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Test')));
      final semantics = tester.getSemantics(find.byType(DsAvatar));
      expect(semantics.flagsCollection.isImage, isTrue);
    });

    testWidgets('circle variant uses a circular shape', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Jordan')));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsAvatar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.borderRadius, isNull);
    });

    testWidgets('square variant uses a rounded rectangle shape', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatar(name: 'Jordan', variant: DsAvatarVariant.square),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsAvatar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.rectangle);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets(
      'square variant radius equals the theme borderRadius.sm token',
      (tester) async {
        final theme = DsThemeDigdir.light();
        await tester.pumpWidget(
          DsTheme(
            data: theme,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: DsAvatar(name: 'Jordan', variant: DsAvatarVariant.square),
            ),
          ),
        );
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DsAvatar),
            matching: find.byType(Container),
          ),
        );
        final decoration = container.decoration! as BoxDecoration;
        // Token-driven: the rounded square uses borderRadius.sm, never a
        // hardcoded literal.
        expect(
          decoration.borderRadius,
          BorderRadius.circular(theme.borderRadius.sm),
        );
      },
    );

    testWidgets(
      'filled appearance: solid baseDefault fill behind the initials text',
      (tester) async {
        final theme = DsThemeDigdir.light();
        final expectedFill = theme.colorScheme
            .resolve(DsColor.accent)
            .baseDefault;
        await tester.pumpWidget(
          DsTheme(
            data: theme,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: DsColorScope(
                color: DsColor.accent,
                child: DsAvatar(name: 'Jordan Vik'),
              ),
            ),
          ),
        );

        // The avatar paints a solid filled chip using the resolved colour
        // scale's baseDefault token.
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DsAvatar),
            matching: find.byType(Container),
          ),
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, expectedFill);
        expect(decoration.shape, BoxShape.circle);

        // Initials render on top of the fill.
        expect(find.text('JV'), findsOneWidget);
      },
    );

    testWidgets(
      'no border in normal (non-high-contrast) mode — purely a filled chip',
      (tester) async {
        await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Jordan')));
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(DsAvatar),
            matching: find.byType(Container),
          ),
        );
        // foregroundDecoration carries the high-contrast border; it stays null
        // in normal mode so the avatar is a plain solid fill.
        expect(container.foregroundDecoration, isNull);
      },
    );

    testWidgets('semantic label is name or "Profilbilde" fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAvatar(name: 'Kari Nordmann')),
      );
      var semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Kari Nordmann',
        ),
      );
      expect(semanticsWidget.properties.label, 'Kari Nordmann');

      await tester.pumpWidget(wrapWithTheme(const DsAvatar()));
      semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Profilbilde',
        ),
      );
      expect(semanticsWidget.properties.label, 'Profilbilde');
    });

    testWidgets('semanticLabel overrides the name-based default', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatar(
            name: 'Jordan Vik',
            semanticLabel: 'Designsystemet-logo',
          ),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Designsystemet-logo' &&
              w.properties.image == true,
        ),
      );
      expect(semanticsWidget.properties.label, 'Designsystemet-logo');
    });

    testWidgets('semanticLabel overrides the "Profilbilde" fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAvatar(semanticLabel: 'Designsystemet-logo')),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Designsystemet-logo',
        ),
      );
      expect(semanticsWidget.properties.label, 'Designsystemet-logo');
    });
  });
}
