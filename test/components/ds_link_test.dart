import 'dart:ui' show PointerDeviceKind;

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
  group('DsLink', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsLink(text: 'Read more')));
      expect(find.text('Read more'), findsOneWidget);
    });

    testWidgets('onTap called when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(DsLink(text: 'Click', onTap: () => tapped = true)),
      );
      await tester.tap(find.byType(DsLink));
      expect(tapped, isTrue);
    });

    testWidgets('has link semantics when interactive', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsLink(text: 'Link', onTap: () {})),
      );
      final semantics = tester.getSemantics(find.byType(DsLink));
      expect(semantics.flagsCollection.isLink, isTrue);
    });

    testWidgets('is not announced as a link when non-interactive', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsLink(text: 'Link')));
      final semantics = tester.getSemantics(find.byType(DsLink));
      expect(semantics.flagsCollection.isLink, isFalse);
    });

    testWidgets('has underline by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsLink(text: 'Underlined')));
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.decoration, TextDecoration.underline);
    });

    testWidgets('keeps underline on hover and thickens it', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsLink(text: 'Hover me', onTap: () {})),
      );

      Text linkText() => tester.widget<Text>(find.text('Hover me'));

      // Resting: thin underline.
      expect(linkText().style?.decoration, TextDecoration.underline);
      expect(linkText().style?.decorationThickness, 1.0);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(DsLink)));
      await tester.pumpAndSettle();

      // Hover: underline kept, but thicker.
      expect(linkText().style?.decoration, TextDecoration.underline);
      expect(linkText().style?.decorationThickness, 2.0);
    });

    testWidgets('semantic label matches text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsLink(text: 'My link')));
      // Verify via Semantics widget properties (avoids merged label)
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'My link',
        ),
      );
      expect(semanticsWidget.properties.label, 'My link');
    });
  });
}
