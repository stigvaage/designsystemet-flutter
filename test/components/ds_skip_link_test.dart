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
  group('DsSkipLink', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsSkipLink(label: 'Skip to content', onActivate: () {})),
      );
      expect(find.byType(DsSkipLink), findsOneWidget);
    });
  });
}
