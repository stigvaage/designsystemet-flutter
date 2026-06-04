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

  group('DsInput disabled treatment', () {
    // Finding #29: the canonical disabled treatment is IgnorePointer + Opacity.
    // A disabled field must dim (Opacity) and swallow pointer input
    // (IgnorePointer) — verify both wrappers are present, and absent otherwise.
    // Flutter's own text-field internals add IgnorePointer widgets of their
    // own (and they may be inactive), so we cannot assert on the raw widget
    // count. Instead assert the meaningful state: when disabled, DsInput's own
    // wrapper actively ignores pointers (ignoring == true) AND dims the field
    // (an Opacity with opacity < 1.0). When enabled, neither is present.
    testWidgets('wraps in IgnorePointer + Opacity when disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const DsInput(size: DsSize.md, disabled: true)),
      );

      expect(
        find.descendant(
          of: find.byType(DsInput),
          matching: find.byWidgetPredicate(
            (w) => w is IgnorePointer && w.ignoring,
          ),
        ),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.descendant(
          of: find.byType(DsInput),
          matching: find.byWidgetPredicate(
            (w) => w is Opacity && w.opacity < 1.0,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('no IgnorePointer/Opacity when enabled', (tester) async {
      await tester.pumpWidget(_host(const DsInput(size: DsSize.md)));

      expect(
        find.descendant(
          of: find.byType(DsInput),
          matching: find.byWidgetPredicate(
            (w) => w is IgnorePointer && w.ignoring,
          ),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(DsInput),
          matching: find.byWidgetPredicate(
            (w) => w is Opacity && w.opacity < 1.0,
          ),
        ),
        findsNothing,
      );
    });
  });

  group('DsInput focus ring (reserveRing)', () {
    // DsFocus.reserveRing always reserves the 3px ring gap, so focusing must
    // NOT shift the field's layout (no jump) — only the ring decoration swaps.
    testWidgets('focusing does not shift the field layout', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(DsInput(focusNode: focus, size: DsSize.md)),
      );

      final before = tester.getRect(find.byType(TextField));

      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(focus.hasFocus, isTrue);

      final after = tester.getRect(find.byType(TextField));
      expect(after, before, reason: 'focus ring must not move the field');
    });
  });

  group('DsInput controller swap', () {
    // Regression: didUpdateWidget used to reconcile only focusNode changes, so
    // swapping the controller (external <-> internal) lost the typed text or
    // changed the visible value abruptly.
    testWidgets('null -> external preserves the internally typed text', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const DsInput(size: DsSize.md)));

      // Type into the field while it manages its own (internal) controller.
      await tester.enterText(find.byType(EditableText), 'hei');
      await tester.pump();
      expect(find.text('hei'), findsOneWidget);

      // Parent now hands us an EMPTY external controller. The previously typed
      // value must carry over instead of being wiped.
      final external = TextEditingController();
      addTearDown(external.dispose);
      await tester.pumpWidget(
        _host(DsInput(controller: external, size: DsSize.md)),
      );
      await tester.pump();

      expect(external.text, 'hei');
      expect(find.text('hei'), findsOneWidget);
    });

    testWidgets('null -> non-empty external does not clobber parent value', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const DsInput(size: DsSize.md)));

      await tester.enterText(find.byType(EditableText), 'internal');
      await tester.pump();

      // The incoming external controller already carries the parent's value;
      // it must win over the internal text.
      final external = TextEditingController(text: 'fromParent');
      addTearDown(external.dispose);
      await tester.pumpWidget(
        _host(DsInput(controller: external, size: DsSize.md)),
      );
      await tester.pump();

      expect(external.text, 'fromParent');
      expect(find.text('fromParent'), findsOneWidget);
    });

    testWidgets('external -> null keeps the externally set value visible', (
      tester,
    ) async {
      final external = TextEditingController(text: 'kept');
      addTearDown(external.dispose);
      await tester.pumpWidget(
        _host(DsInput(controller: external, size: DsSize.md)),
      );
      expect(find.text('kept'), findsOneWidget);

      // Parent removes the controller; the field falls back to its own
      // controller but must keep showing the value the user last saw.
      await tester.pumpWidget(_host(const DsInput(size: DsSize.md)));
      await tester.pump();

      expect(find.text('kept'), findsOneWidget);
    });

    testWidgets(
      'swapping between two external controllers shows the new value',
      (tester) async {
        final first = TextEditingController(text: 'first');
        final second = TextEditingController(text: 'second');
        addTearDown(first.dispose);
        addTearDown(second.dispose);

        await tester.pumpWidget(
          _host(DsInput(controller: first, size: DsSize.md)),
        );
        expect(find.text('first'), findsOneWidget);

        await tester.pumpWidget(
          _host(DsInput(controller: second, size: DsSize.md)),
        );
        await tester.pump();

        // The new external controller's value is shown verbatim; the old one is
        // left untouched (parent still owns it).
        expect(find.text('second'), findsOneWidget);
        expect(first.text, 'first');
      },
    );
  });
}
