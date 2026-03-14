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
  group('DsErrorSummary', () {
    testWidgets('renders error list', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsErrorSummary(errors: ['Error 1', 'Error 2']),
      ));
      expect(find.textContaining('Error 1'), findsOneWidget);
      expect(find.textContaining('Error 2'), findsOneWidget);
    });

    testWidgets('renders custom title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsErrorSummary(errors: ['E1'], title: 'Fix these'),
      ));
      expect(find.text('Fix these'), findsOneWidget);
    });

    testWidgets('calls onErrorTap when error tapped', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(wrapWithTheme(
        DsErrorSummary(
          errors: const ['Error A', 'Error B'],
          onErrorTap: (i) => tappedIndex = i,
        ),
      ));
      await tester.tap(find.textContaining('Error B'));
      expect(tappedIndex, 1);
    });
  });
}
