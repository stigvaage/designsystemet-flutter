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
  group('DsDivider', () {
    testWidgets('renders horizontal divider by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsDivider()));
      expect(find.byType(DsDivider), findsOneWidget);
    });

    testWidgets('renders vertical divider when vertical=true', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(height: 100, child: DsDivider(vertical: true)),
        ),
      );
      expect(find.byType(DsDivider), findsOneWidget);
    });

    testWidgets('uses theme border color', (tester) async {
      final theme = DsThemeDigdir.light();
      final expectedColor = theme.colorScheme
          .resolve(DsColor.accent)
          .borderSubtle;
      await tester.pumpWidget(wrapWithTheme(const DsDivider()));
      // DsDivider renders a single Container with color set
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsDivider),
          matching: find.byType(Container),
        ),
      );
      expect(container.color, expectedColor);
    });

    testWidgets('is excluded from the semantics tree (decorative)', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsDivider()));
      expect(
        find.descendant(
          of: find.byType(DsDivider),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
    });

    // Regression: a vertical divider in an unbounded cross-axis context (a Row
    // without stretch alignment) must not collapse to zero height — otherwise
    // it is invisible. It falls back to a token-derived minimum height.
    testWidgets('vertical divider stays visible in an unbounded Row', (
      tester,
    ) async {
      final theme = DsThemeDigdir.light();
      final expectedMinHeight = theme.sizeTokens.size6;
      await tester.pumpWidget(
        wrapWithTheme(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('a'), DsDivider(vertical: true), Text('b')],
          ),
        ),
      );
      final size = tester.getSize(find.byType(DsDivider));
      expect(size.height, greaterThanOrEqualTo(expectedMinHeight));
      expect(size.height, greaterThan(0));
    });

    testWidgets('vertical divider applies token-derived minHeight by default', (
      tester,
    ) async {
      final theme = DsThemeDigdir.light();
      await tester.pumpWidget(
        wrapWithTheme(
          const Align(
            alignment: Alignment.topLeft,
            child: DsDivider(vertical: true),
          ),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsDivider),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.minHeight, theme.sizeTokens.size6);
    });

    testWidgets('vertical divider honors explicit length as its height', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [DsDivider(vertical: true, length: 64)],
          ),
        ),
      );
      final size = tester.getSize(find.byType(DsDivider));
      expect(size.height, 64);
    });

    testWidgets('vertical divider stretches to a bounded parent height', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: SizedBox(height: 120, child: DsDivider(vertical: true)),
          ),
        ),
      );
      final size = tester.getSize(find.byType(DsDivider));
      expect(size.height, 120);
    });

    testWidgets('horizontal divider honors explicit length as its width', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Align(
            alignment: Alignment.topLeft,
            child: DsDivider(length: 80),
          ),
        ),
      );
      final size = tester.getSize(find.byType(DsDivider));
      expect(size.width, 80);
    });
  });
}
