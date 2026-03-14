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
  group('DsSkeleton', () {
    testWidgets('renders with specified dimensions', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsSkeleton(width: 200, height: 20),
      ));
      expect(find.byType(DsSkeleton), findsOneWidget);
    });

    testWidgets('renders without width (fills parent)', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(width: 300, child: DsSkeleton(height: 16)),
      ));
      expect(find.byType(DsSkeleton), findsOneWidget);
    });
  });
}
