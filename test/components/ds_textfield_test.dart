import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) => Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: 300, child: child),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  group('DsTextfield', () {
    testWidgets('shows the placeholder', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsTextfield(placeholder: 'Navn')),
      );
      expect(find.text('Navn'), findsOneWidget);
    });

    testWidgets('forwards onChanged when text is entered', (tester) async {
      String? value;
      await tester.pumpWidget(
        wrapWithTheme(DsTextfield(onChanged: (v) => value = v)),
      );
      await tester.enterText(find.byType(EditableText), 'hei');
      expect(value, 'hei');
    });
  });
}
