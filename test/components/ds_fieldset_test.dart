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
  group('DsFieldset', () {
    testWidgets('renders legend text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsFieldset(legend: 'Personal Info', children: [Text('Field')]),
      ));
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('Field'), findsOneWidget);
    });

    testWidgets('wraps content in Semantics widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsFieldset(legend: 'Group', children: [Text('Child')]),
      ));
      // Verify Semantics widget is present in the tree
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}
