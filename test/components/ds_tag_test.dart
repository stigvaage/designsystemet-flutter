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
  group('DsTag', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsTag(child: Text('Status'))),
      );
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('has tinted background', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(wrapWithTheme(const DsTag(child: Text('Tag'))));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, colorScale.surfaceTinted);
    });

    testWidgets('has subtle border', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(wrapWithTheme(const DsTag(child: Text('Tag'))));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, colorScale.borderSubtle);
    });

    testWidgets('outline variant renders with transparent fill and default '
        'border', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTag(
            variant: DsSelectionVariant.outline,
            child: Text('Outline'),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Outline'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0x00000000));
      final border = decoration.border as Border;
      expect(border.top.color, colorScale.borderDefault);
    });

    group('størrelsesramp', () {
      const expected = <DsSize, ({EdgeInsets padding, double fontSize})>{
        DsSize.sm: (
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          fontSize: 12.0,
        ),
        DsSize.md: (
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          fontSize: 14.0,
        ),
        DsSize.lg: (
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          fontSize: 16.0,
        ),
      };

      for (final entry in expected.entries) {
        final size = entry.key;
        final spec = entry.value;
        testWidgets('$size gir riktig padding og skriftstørrelse', (
          tester,
        ) async {
          await tester.pumpWidget(
            wrapWithTheme(DsTag(size: size, child: const Text('Tag'))),
          );

          final container = tester.widget<Container>(find.byType(Container));
          expect(container.padding, spec.padding);

          final textStyle = tester.widget<DefaultTextStyle>(
            find.descendant(
              of: find.byType(DsTag),
              matching: find.byType(DefaultTextStyle),
            ),
          );
          expect(textStyle.style.fontSize, spec.fontSize);
        });
      }

      testWidgets('størrelsene gir ulik padding og skriftstørrelse', (
        tester,
      ) async {
        final paddings = <EdgeInsetsGeometry?>{};
        final fontSizes = <double?>{};

        for (final size in DsSize.values) {
          await tester.pumpWidget(
            wrapWithTheme(DsTag(size: size, child: const Text('Tag'))),
          );
          paddings.add(
            tester.widget<Container>(find.byType(Container)).padding,
          );
          fontSizes.add(
            tester
                .widget<DefaultTextStyle>(
                  find.descendant(
                    of: find.byType(DsTag),
                    matching: find.byType(DefaultTextStyle),
                  ),
                )
                .style
                .fontSize,
          );
        }

        expect(paddings.length, DsSize.values.length);
        expect(fontSizes.length, DsSize.values.length);
      });
    });

    testWidgets('color overstyrer fargeskalaen for fyll, kantlinje og tekst', (
      tester,
    ) async {
      final theme = DsThemeDigdir.light();
      final neutralScale = theme.colorScheme.resolve(DsColor.neutral);
      final accentScale = theme.colorScheme.resolve(DsColor.accent);

      await tester.pumpWidget(
        wrapWithTheme(const DsTag(color: DsColor.neutral, child: Text('Tag'))),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, neutralScale.surfaceTinted);
      final border = decoration.border as Border;
      expect(border.top.color, neutralScale.borderSubtle);

      final textStyle = tester.widget<DefaultTextStyle>(
        find.descendant(
          of: find.byType(DsTag),
          matching: find.byType(DefaultTextStyle),
        ),
      );
      expect(textStyle.style.color, neutralScale.textDefault);

      // Overstyringen skal gi en annen fargeskala enn standard (accent).
      expect(neutralScale.surfaceTinted, isNot(accentScale.surfaceTinted));
    });
  });
}
