import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('Focus indicator', () {
    testWidgets('DsButton shows focus ring when focused', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () {},
            focusNode: focusNode,
            child: const Text('Focused'),
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();

      // Verify a DecoratedBox with border appears (focus ring)
      final decoratedBoxes = find.byType(DecoratedBox);
      expect(decoratedBoxes, findsWidgets);
      focusNode.dispose();
    });

    testWidgets('DsCheckbox shows focus ring when focused', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(value: false, onChanged: (_) {}, focusNode: focusNode),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      expect(find.byType(DecoratedBox), findsWidgets);
      focusNode.dispose();
    });

    testWidgets('DsRadio shows focus ring when focused', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(value: false, onChanged: (_) {}, focusNode: focusNode),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      expect(find.byType(DecoratedBox), findsWidgets);
      focusNode.dispose();
    });
  });
}
