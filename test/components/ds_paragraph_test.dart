import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';
import 'package:komponentbibliotek_flutter/typography.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return DsTheme(
      data: DsThemeDigdir.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: child,
      ),
    );
  }

  group('DsParagraph', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsParagraph(text: 'Body text'),
      ));
      expect(find.text('Body text'), findsOneWidget);
    });

    testWidgets('default body style has weight 400 and line-height 1.5', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsParagraph(text: 'Test'),
      ));
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, FontWeight.w400);
      expect(text.style?.height, 1.5);
    });

    testWidgets('short variant has line-height 1.3', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsParagraph(text: 'Short', variant: DsBodyVariant.short),
      ));
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.height, 1.3);
    });

    testWidgets('long variant has line-height 1.7', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsParagraph(text: 'Long', variant: DsBodyVariant.long),
      ));
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.height, 1.7);
    });

    testWidgets('uses correct color from scope', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DsColorScope(
          color: DsColor.neutral,
          child: const DsParagraph(text: 'Neutral'),
        ),
      ));
      final text = tester.widget<Text>(find.byType(Text));
      final theme = DsThemeDigdir.light();
      expect(text.style?.color, theme.colorScheme.neutral.textDefault);
    });
  });
}
