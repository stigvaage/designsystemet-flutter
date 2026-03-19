import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsLink', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsLink(text: 'Read more')),
      );
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

    testWidgets('has link semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsLink(text: 'Link')),
      );
      final semantics = tester.getSemantics(find.byType(DsLink));
      expect(semantics.flagsCollection.isLink, isTrue);
    });

    testWidgets('has underline by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsLink(text: 'Underlined')),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.decoration, TextDecoration.underline);
    });

    testWidgets('semantic label matches text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsLink(text: 'My link')),
      );
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
