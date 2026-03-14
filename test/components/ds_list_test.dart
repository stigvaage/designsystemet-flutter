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
  group('DsList', () {
    testWidgets('renders unordered list with bullets', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsList(items: [Text('Item A'), Text('Item B')]),
      ));
      expect(find.text('Item A'), findsOneWidget);
      expect(find.text('Item B'), findsOneWidget);
      expect(find.text('•'), findsNWidgets(2));
    });

    testWidgets('renders ordered list with numbers', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsList(items: [Text('First'), Text('Second')], ordered: true),
      ));
      expect(find.text('1.'), findsOneWidget);
      expect(find.text('2.'), findsOneWidget);
    });
  });
}
