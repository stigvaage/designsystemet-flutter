import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';
import 'package:komponentbibliotek_flutter/typography.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

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
  });
}
