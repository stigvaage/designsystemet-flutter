import 'dart:ui' show SemanticsFlag;
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
  group('DsDetails', () {
    testWidgets('renders summary', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsDetails(
          summary: Text('Click to expand'),
          child: Text('Hidden content'),
        ),
      ));
      expect(find.text('Click to expand'), findsOneWidget);
    });

    testWidgets('expands on tap', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsDetails(
          summary: Text('Summary'),
          child: Text('Content'),
        ),
      ));
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('has expanded semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsDetails(
          summary: Text('S'),
          child: Text('C'),
          initiallyExpanded: true,
        ),
      ));
      final semantics = tester.getSemantics(find.byType(Semantics));
      expect(semantics.hasFlag(SemanticsFlag.hasExpandedState), isTrue);
    });
  });
}
