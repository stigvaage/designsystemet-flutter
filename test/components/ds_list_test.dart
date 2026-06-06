import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsList', () {
    testWidgets('renders unordered list with bullets', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsList(items: [Text('Item A'), Text('Item B')])),
      );
      expect(find.text('Item A'), findsOneWidget);
      expect(find.text('Item B'), findsOneWidget);
      expect(find.text('•'), findsNWidgets(2));
    });

    testWidgets('renders ordered list with numbers', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsList(items: [Text('First'), Text('Second')], ordered: true),
        ),
      );
      expect(find.text('1.'), findsOneWidget);
      expect(find.text('2.'), findsOneWidget);
    });

    testWidgets('exposes list and listItem semantics roles', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsList(items: [Text('Item A'), Text('Item B')])),
      );

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.role == SemanticsRole.list,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.role == SemanticsRole.listItem,
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('excludes decorative markers from semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsList(items: [Text('Item A'), Text('Item B')])),
      );

      expect(find.byType(ExcludeSemantics), findsNWidgets(2));
    });

    testWidgets('keeps multi-digit ordered markers on a single line', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsList(
            ordered: true,
            items: [
              Text('1'),
              Text('2'),
              Text('3'),
              Text('4'),
              Text('5'),
              Text('6'),
              Text('7'),
              Text('8'),
              Text('9'),
              Text('10'),
              Text('11'),
              Text('12'),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('10.'), findsOneWidget);
      expect(find.text('11.'), findsOneWidget);
      expect(find.text('12.'), findsOneWidget);

      final markerText = tester.widget<Text>(find.text('12.'));
      expect(markerText.maxLines, 1);
      expect(markerText.softWrap, isFalse);
    });
  });
}
