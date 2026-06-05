import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/theme.dart';
import 'package:designsystemet_flutter/typography.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithTheme(Widget child, {DsThemeData? theme}) {
    return DsTheme(
      data: theme ?? DsThemeDigdir.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  group('DsHeading', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsHeading(text: 'Hello World')),
      );
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('renders with correct heading level style', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsHeading(text: 'Test', level: DsHeadingLevel.xxl)),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, FontWeight.w500);
      expect(text.style?.height, 1.3);
    });

    testWidgets('has header semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsHeading(text: 'Title')));
      final semantics = tester.getSemantics(find.byType(Semantics));
      expect(semantics.flagsCollection.isHeader, isTrue);
    });

    testWidgets('emits the semantic heading level', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsHeading(text: 'Title', semanticLevel: 3)),
      );
      final node = tester.widget<Semantics>(find.byType(Semantics));
      expect(node.properties.headingLevel, 3);
    });

    testWidgets('defaults the semantic heading level to 2', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsHeading(text: 'Title')));
      final node = tester.widget<Semantics>(find.byType(Semantics));
      expect(node.properties.headingLevel, 2);
    });

    testWidgets('inherits color from DsColorScope', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsColorScope(
            color: DsColor.danger,
            child: DsHeading(text: 'Danger'),
          ),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      final theme = DsThemeDigdir.light();
      expect(text.style?.color, theme.colorScheme.danger.textDefault);
    });

    testWidgets('local color overrides scope', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsColorScope(
            color: DsColor.danger,
            child: DsHeading(text: 'Success', color: DsColor.success),
          ),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      final theme = DsThemeDigdir.light();
      expect(text.style?.color, theme.colorScheme.success.textDefault);
    });
  });
}
