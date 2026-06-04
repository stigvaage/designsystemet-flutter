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
  group('DsSkeleton', () {
    testWidgets('renders with specified dimensions', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSkeleton(width: 200, height: 20)),
      );
      expect(find.byType(DsSkeleton), findsOneWidget);
    });

    testWidgets('renders without width (fills parent)', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(width: 300, child: DsSkeleton(height: 16)),
        ),
      );
      expect(find.byType(DsSkeleton), findsOneWidget);
    });

    testWidgets('animates across the full shimmer period without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsSkeleton(width: 200, height: 20)),
      );
      // Pump through the full 1500ms shimmer period in steps to exercise the
      // sine-based easing across its whole range.
      for (var i = 0; i < 16; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(tester.takeException(), isNull);
      expect(find.byType(DsSkeleton), findsOneWidget);
    });
  });
}
