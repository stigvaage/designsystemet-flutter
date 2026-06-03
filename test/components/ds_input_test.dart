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
  group('DsInput single-tap keyboard', () {
    // Regression for the double-tap-to-open-keyboard bug: a single tap must
    // both focus the field AND open the platform input connection (keyboard).
    testWidgets('opens the keyboard on the FIRST tap', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(DsInput(focusNode: focus, size: DsSize.md, placeholder: 'Skriv')),
      );

      expect(tester.testTextInput.hasAnyClients, isFalse);

      await tester.tap(find.byType(DsInput));
      await tester.pump();

      expect(focus.hasFocus, isTrue, reason: 'one tap must focus the field');
      expect(
        tester.testTextInput.hasAnyClients,
        isTrue,
        reason: 'the soft keyboard must open after a single tap',
      );
    });

    // A tap inside the content padding (near the field edge) used to land on
    // the external Padding — OUTSIDE the TextField hit area — so it only
    // requested focus without opening the keyboard. It must now open it.
    testWidgets('a tap near the field edge still opens the keyboard', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(DsInput(focusNode: focus, size: DsSize.md)),
      );

      // Tap inside the content padding (past the 3px focus-ring gutter, within
      // the field's contentPadding) — where the old EXTERNAL Padding put the
      // tap outside the TextField hit area and only requested focus.
      final rect = tester.getRect(find.byType(DsInput));
      await tester.tapAt(Offset(rect.left + 8, rect.center.dy));
      await tester.pump();

      expect(tester.testTextInput.hasAnyClients, isTrue);
    });

    testWidgets('tapping the prefix focuses the field', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(
          DsInput(
            focusNode: focus,
            size: DsSize.md,
            prefix: const Icon(Icons.search),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(focus.hasFocus, isTrue);
    });

    testWidgets('tapping the suffix focuses the field', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(
          DsInput(
            focusNode: focus,
            size: DsSize.md,
            suffix: const Icon(Icons.clear),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(focus.hasFocus, isTrue);
    });

    testWidgets('disabled field does not focus or open the keyboard', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(DsInput(focusNode: focus, size: DsSize.md, disabled: true)),
      );

      await tester.tap(find.byType(DsInput), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(focus.hasFocus, isFalse);
      expect(tester.testTextInput.hasAnyClients, isFalse);
    });
  });
}
