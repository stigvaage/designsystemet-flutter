import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => DsTheme(
  data: DsThemeDigdir.light(),
  child: MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 300, child: child)),
    ),
  ),
);

void main() {
  group('DsTextarea', () {
    // Multi-line variant of the single-tap-keyboard regression: a multiline
    // field must also open the soft keyboard on the FIRST tap.
    testWidgets('opens the keyboard on the FIRST tap (multiline)', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(DsTextarea(focusNode: focus, rows: 4, placeholder: 'Skriv')),
      );

      expect(tester.testTextInput.hasAnyClients, isFalse);

      await tester.tap(find.byType(DsTextarea));
      await tester.pump();

      expect(focus.hasFocus, isTrue, reason: 'one tap must focus the field');
      expect(
        tester.testTextInput.hasAnyClients,
        isTrue,
        reason: 'the soft keyboard must open after a single tap',
      );
    });
  });
}
