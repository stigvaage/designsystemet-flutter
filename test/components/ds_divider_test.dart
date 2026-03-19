import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsDivider', () {
    testWidgets('renders horizontal divider by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsDivider()),
      );
      expect(find.byType(DsDivider), findsOneWidget);
    });

    testWidgets('renders vertical divider when vertical=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 100,
            child: DsDivider(vertical: true),
          ),
        ),
      );
      expect(find.byType(DsDivider), findsOneWidget);
    });

    testWidgets('uses theme border color', (tester) async {
      final theme = DsThemeDigdir.light();
      final expectedColor =
          theme.colorScheme.resolve(DsColor.accent).borderSubtle;
      await tester.pumpWidget(
        wrapWithTheme(const DsDivider()),
      );
      // DsDivider renders a single Container with color set
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsDivider),
          matching: find.byType(Container),
        ),
      );
      expect(container.color, expectedColor);
    });
  });
}
