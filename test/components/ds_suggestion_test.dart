import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) {
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

const _fruits = [
  DsSuggestionOption(value: 'a', label: 'Apple'),
  DsSuggestionOption(value: 'b', label: 'Banana'),
  DsSuggestionOption(value: 'c', label: 'Cherry'),
];

void main() {
  group('DsSuggestion', () {
    testWidgets('filters options by query and selects one (single)', (
      tester,
    ) async {
      final changes = <List<String>>[];
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            onSelectedChanged: changes.add,
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'ban');
      await tester.pump();
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);

      await tester.tap(find.text('Banana'));
      await tester.pump();
      expect(changes.last, ['b']);
    });

    testWidgets('shows the empty state when nothing matches', (tester) async {
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            emptyText: 'Ingen treff',
            onSelectedChanged: (_) {},
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'zzz');
      await tester.pump();
      expect(find.text('Ingen treff'), findsOneWidget);
    });

    testWidgets('multiple selection toggles and renders chips', (tester) async {
      final changes = <List<String>>[];
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            multiple: true,
            onSelectedChanged: changes.add,
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();
      await tester.tap(find.text('Apple'));
      await tester.pump();
      await tester.tap(find.text('Cherry'));
      await tester.pump();
      expect(changes.last, ['a', 'c']);
      expect(find.text('Apple'), findsWidgets);
      expect(find.text('Cherry'), findsWidgets);
    });

    testWidgets('creatable adds a new option from the query', (tester) async {
      final changes = <List<String>>[];
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            creatable: true,
            onCreate: (q) => q,
            onSelectedChanged: changes.add,
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'Mango');
      await tester.pump();
      expect(find.text('Opprett "Mango"'), findsOneWidget);
      await tester.tap(find.text('Opprett "Mango"'));
      await tester.pump();
      expect(changes.last, ['Mango']);
    });

    testWidgets('createLabel overrides the create row label and semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            creatable: true,
            onCreate: (q) => q,
            createLabel: (q) => 'Legg til $q',
            onSelectedChanged: (_) {},
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'Mango');
      await tester.pump();
      // The custom label replaces the Norwegian default everywhere.
      expect(find.text('Legg til Mango'), findsOneWidget);
      expect(find.text('Opprett "Mango"'), findsNothing);
      final createSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.button == true &&
            w.properties.label == 'Legg til Mango',
      );
      expect(createSemantics, findsOneWidget);
    });

    testWidgets('accepts an external focusNode that drives focus/open', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            focusNode: node,
            onSelectedChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Apple'), findsNothing);

      // Requesting focus on the supplied node must open the overlay (the
      // widget listens to the external node just like its own). One pump grants
      // focus and runs the listener's _open(); a second renders the freshly
      // inserted overlay entry.
      node.requestFocus();
      await tester.pump();
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('disposing does not dispose an external focusNode', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            focusNode: node,
            onSelectedChanged: (_) {},
          ),
        ),
      );
      // Replace the widget so DsSuggestion is disposed; the external node must
      // survive (a later use would throw if it had been disposed).
      await tester.pumpWidget(host(const SizedBox.shrink()));
      // Still usable — accessing/using a disposed FocusNode would throw.
      expect(node.hasFocus, isFalse);
      node.requestFocus();
    });

    testWidgets('opens above the field when the keyboard inset crowds below', (
      tester,
    ) async {
      // Place the field near the bottom and simulate a soft keyboard via
      // viewInsets.bottom. The list must still render (flipped up / clamped)
      // rather than being pushed off-screen behind the keyboard (#23).
      await tester.pumpWidget(
        DsTheme(
          data: DsThemeDigdir.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(400, 800),
                viewInsets: EdgeInsets.only(bottom: 500),
              ),
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (_) => Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: 300,
                        child: DsSuggestion<String>(
                          options: _fruits,
                          onSelectedChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      // The list is shown.
      expect(find.text('Apple'), findsOneWidget);
      // And its top is above the field's top (it flipped upward), so it is not
      // hidden behind the keyboard inset.
      final listTop = tester.getTopLeft(find.text('Apple')).dy;
      final fieldTop = tester.getTopLeft(find.byType(EditableText)).dy;
      expect(listTop, lessThan(fieldTop));
    });

    testWidgets('arrow navigation scrolls the highlighted option into view', (
      tester,
    ) async {
      // A long option list in a short overlay forces scrolling; navigating to
      // a far-down option must bring it into the viewport (#21).
      final many = [
        for (var i = 0; i < 40; i++)
          DsSuggestionOption(value: 'v$i', label: 'Option $i'),
      ];
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: many,
            filter: false,
            onSelectedChanged: (_) {},
          ),
        ),
      );
      await tester.showKeyboard(find.byType(EditableText));
      await tester.pump();

      // SingleChildScrollView builds every row (it is not lazy), so assert by
      // paint position relative to the scroll viewport rather than presence.
      final scrollView = find.ancestor(
        of: find.text('Option 0'),
        matching: find.byType(SingleChildScrollView),
      );
      Rect viewportRect() => tester.getRect(scrollView);
      // Option 30 starts below the visible viewport (clipped off the bottom).
      expect(
        tester.getRect(find.text('Option 30')).top,
        greaterThan(viewportRect().bottom),
      );

      // Walk the highlight down to option 30.
      for (var i = 0; i <= 30; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      }
      await tester.pumpAndSettle();

      // ensureVisible scrolled it into the viewport's vertical bounds.
      final vp = viewportRect();
      final row = tester.getRect(find.text('Option 30'));
      expect(row.top, greaterThanOrEqualTo(vp.top - 1));
      expect(row.bottom, lessThanOrEqualTo(vp.bottom + 1));
    });

    testWidgets('Enter selects the single filtered match', (tester) async {
      final changes = <List<String>>[];
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            onSelectedChanged: changes.add,
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'app');
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(changes.last, ['a']);
    });

    testWidgets('Escape closes the overlay', (tester) async {
      await tester.pumpWidget(
        host(DsSuggestion<String>(options: _fruits, onSelectedChanged: (_) {})),
      );
      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('ArrowUp re-opens the overlay when it is closed', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(DsSuggestion<String>(options: _fruits, onSelectedChanged: (_) {})),
      );
      // Focusing opens the list; close it with Escape so we can prove ArrowUp
      // re-opens it (regression: ArrowUp previously never called _open()).
      await tester.showKeyboard(find.byType(EditableText));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
    });

    testWidgets('tapping inside the field does not close the open list', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(DsSuggestion<String>(options: _fruits, onSelectedChanged: (_) {})),
      );
      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);

      // A tap on the field (to move the caret) must keep the list open.
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('the field exposes textField + expanded semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(DsSuggestion<String>(options: _fruits, onSelectedChanged: (_) {})),
      );
      final fieldSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.textField == true &&
            w.properties.expanded != null,
      );
      expect(
        tester.widget<Semantics>(fieldSemantics).properties.expanded,
        isFalse,
      );

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      expect(
        tester.widget<Semantics>(fieldSemantics).properties.expanded,
        isTrue,
      );
    });

    testWidgets('the empty state is announced as a live region', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            emptyText: 'Ingen treff',
            onSelectedChanged: (_) {},
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'zzz');
      await tester.pump();
      final liveRegion = find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.liveRegion == true,
      );
      expect(liveRegion, findsOneWidget);
    });

    testWidgets(
      'controlled multiple removes distinct chips on repeated backspace',
      (tester) async {
        // The parent re-renders with the committed list each change, but we
        // also assert the intermediate commits target distinct values rather
        // than re-reading a stale last value.
        final changes = <List<String>>[];
        var current = <String>['a', 'b', 'c'];

        Widget build() => host(
          StatefulBuilder(
            builder: (context, setState) => DsSuggestion<String>(
              options: _fruits,
              multiple: true,
              selected: current,
              onSelectedChanged: (next) {
                changes.add(next);
                setState(() => current = next);
              },
            ),
          ),
        );

        await tester.pumpWidget(build());
        await tester.showKeyboard(find.byType(EditableText));

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();
        expect(changes.last, ['a', 'b']);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();
        expect(changes.last, ['a']);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();
        expect(changes.last, <String>[]);
      },
    );

    testWidgets('theme swap while the list is open re-captures the theme', (
      tester,
    ) async {
      // Toggling the theme while open must rebuild the overlay with the new
      // theme (didChangeDependencies re-capture) instead of a frozen one.
      var light = true;
      late void Function(void Function()) outerSetState;
      await tester.pumpWidget(
        DsTheme(
          data: DsThemeDigdir.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (_) => StatefulBuilder(
                      builder: (context, setState) {
                        outerSetState = setState;
                        return DsTheme(
                          data: light
                              ? DsThemeDigdir.light()
                              : DsThemeDigdir.dark(),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: 300,
                              child: DsSuggestion<String>(
                                options: _fruits,
                                onSelectedChanged: (_) {},
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);

      // Swap the theme while the overlay is open; it must still build.
      outerSetState(() => light = false);
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets(
      'expanded becomes true when the list re-opens via ArrowDown after Escape',
      (tester) async {
        // Regression: opening through a non-onChanged path (ArrowDown/ArrowUp,
        // focus, onTap) reaches _open() without its own setState, so the host
        // Semantics(expanded:) used to stay false (collapsed) while the list
        // was visible. _open()/_close() now setState the host.
        await tester.pumpWidget(
          host(
            DsSuggestion<String>(options: _fruits, onSelectedChanged: (_) {}),
          ),
        );
        final fieldSemantics = find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.textField == true &&
              w.properties.expanded != null,
        );

        // Open via focus, then close with Escape: expanded must be false.
        await tester.showKeyboard(find.byType(EditableText));
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        expect(find.text('Apple'), findsNothing);
        expect(
          tester.widget<Semantics>(fieldSemantics).properties.expanded,
          isFalse,
        );

        // Re-open via ArrowDown: the host must rebuild so expanded is true
        // while the list is showing.
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(find.text('Apple'), findsOneWidget);
        expect(
          tester.widget<Semantics>(fieldSemantics).properties.expanded,
          isTrue,
        );
      },
    );

    testWidgets('removing a chip while the list is open keeps the list open', (
      tester,
    ) async {
      // Regression: the outside-tap barrier only excluded the input rect, so a
      // pointer-down on a chip's remove button (which sits above the input)
      // counted as "outside" and closed the list. The barrier now excludes the
      // whole field cluster (chips + input).
      final changes = <List<String>>[];
      await tester.pumpWidget(
        host(
          DsSuggestion<String>(
            options: _fruits,
            multiple: true,
            selected: const ['a', 'b'],
            onSelectedChanged: changes.add,
          ),
        ),
      );

      // Open the list.
      await tester.enterText(find.byType(EditableText), 'c');
      await tester.pump();
      expect(find.text('Cherry'), findsOneWidget);

      // Remove the first chip (Apple) via its remove button. The remove button
      // is the GestureDetector under the chip's "Fjern" remove-icon Semantics.
      final removeButtons = find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fjern',
        ),
        matching: find.byType(GestureDetector),
      );
      await tester.tap(removeButtons.first);
      await tester.pump();

      // The chip was removed...
      expect(changes.last, ['b']);
      // ...and the list stayed open (was not closed by the outside-tap barrier).
      expect(find.text('Cherry'), findsOneWidget);
    });
  });
}
