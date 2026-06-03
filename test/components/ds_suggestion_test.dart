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
  });
}
