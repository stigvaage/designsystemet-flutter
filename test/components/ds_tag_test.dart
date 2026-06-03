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
  });
}
