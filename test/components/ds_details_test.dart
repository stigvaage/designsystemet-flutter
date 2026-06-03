import 'dart:ui' show Tristate;

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
  group('DsDetails', () {
    testWidgets('renders summary', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('Click to expand'),
            child: Text('Hidden content'),
          ),
        ),
      );
      expect(find.text('Click to expand'), findsOneWidget);
    });

    testWidgets('expands on tap', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('has expanded semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('S'),
            initiallyExpanded: true,
            child: Text('C'),
          ),
        ),
      );
      final semantics = tester.getSemantics(find.byType(DsDetails));
      expect(semantics.flagsCollection.isExpanded, isNot(Tristate.none));
    });

    testWidgets('tinted variant fills with surfaceTinted', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(
            summary: Text('Summary'),
            variant: DsDetailsVariant.tinted,
            child: Text('Content'),
          ),
        ),
      );

      final context = tester.element(find.byType(DsDetails));
      final theme = DsTheme.of(context);
      final colorScale = theme.colorScheme.resolve(DsColorScope.of(context));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DsDetails),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, colorScale.surfaceTinted);
    });

    testWidgets('default variant has no fill', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsDetails(summary: Text('Summary'), child: Text('Content')),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DsDetails),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNull);
    });
  });
}
