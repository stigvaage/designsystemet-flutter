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
  });
}
