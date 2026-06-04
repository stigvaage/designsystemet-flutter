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
  group('DsTabs', () {
    testWidgets('renders all tab labels and the initial panel', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsTabs(
            tabs: ['One', 'Two'],
            children: [Text('Panel one'), Text('Panel two')],
          ),
        ),
      );
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Panel one'), findsOneWidget);
    });

    testWidgets('tapping a tab calls onChanged with its index', (tester) async {
      int? changed;
      await tester.pumpWidget(
        wrapWithTheme(
          DsTabs(
            tabs: const ['One', 'Two'],
            children: const [Text('Panel one'), Text('Panel two')],
            onChanged: (i) => changed = i,
          ),
        ),
      );
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(changed, 1);
    });
  });
}
