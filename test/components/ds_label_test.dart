import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/theme.dart';
import 'package:designsystemet_flutter/typography.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return DsTheme(
      data: DsThemeDigdir.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  group('DsLabel', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsLabel(text: 'Email')));
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('has medium weight by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsLabel(text: 'Test')));
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, FontWeight.w500);
    });

    testWidgets('uses correct color from theme', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsLabel(text: 'Label')));
      final text = tester.widget<Text>(find.byType(Text));
      final theme = DsThemeDigdir.light();
      expect(text.style?.color, theme.colorScheme.accent.textDefault);
    });

    testWidgets('weight maps DsFontWeight to FontWeight', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsLabel(text: 'Bold', weight: DsFontWeight.semibold),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('lg size resolves to official 21px font size', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsLabel(text: 'Large', size: DsSize.lg)),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, closeTo(21, 0.001));
    });
  });
}
