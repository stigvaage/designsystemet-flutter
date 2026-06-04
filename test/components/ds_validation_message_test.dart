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
  group('DsValidationMessage', () {
    testWidgets('renders the message text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsValidationMessage(message: 'Påkrevd')),
      );
      expect(find.text('Påkrevd'), findsOneWidget);
    });

    testWidgets('uses danger color for errors, success otherwise', (
      tester,
    ) async {
      final scheme = DsThemeDigdir.light().colorScheme;

      await tester.pumpWidget(
        wrapWithTheme(const DsValidationMessage(message: 'Feil')),
      );
      expect(
        tester.widget<Text>(find.text('Feil')).style?.color,
        scheme.danger.textDefault,
      );

      await tester.pumpWidget(
        wrapWithTheme(const DsValidationMessage(message: 'OK', isError: false)),
      );
      expect(
        tester.widget<Text>(find.text('OK')).style?.color,
        scheme.success.textDefault,
      );
    });
  });
}
