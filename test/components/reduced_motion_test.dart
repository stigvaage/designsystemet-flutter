import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithTheme(Widget child, {bool disableAnimations = false}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: DsTheme(
      data: DsThemeDigdir.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    ),
  );
}

void main() {
  group('Reduced motion', () {
    testWidgets('DsSpinner stops animating when disableAnimations is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSpinner(), disableAnimations: true),
      );
      // Spinner should render but not animate
      expect(find.byType(DsSpinner), findsOneWidget);
    });

    testWidgets('DsSpinner animates normally by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSpinner(), disableAnimations: false),
      );
      expect(find.byType(DsSpinner), findsOneWidget);
    });
  });
}
