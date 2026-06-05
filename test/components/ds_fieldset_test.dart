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
  group('DsFieldset', () {
    testWidgets('renders legend text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsFieldset(legend: 'Personal Info', children: [Text('Field')]),
        ),
      );
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('Field'), findsOneWidget);
    });

    testWidgets('wraps content in Semantics widget', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsFieldset(legend: 'Group', children: [Text('Child')]),
        ),
      );
      // Verify Semantics widget is present in the tree
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('exposes the legend as a heading', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsFieldset(legend: 'Group', children: [Text('Child')]),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.header == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('announces the legend exactly once', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapWithTheme(
          const DsFieldset(legend: 'Adresse', children: [Text('Felt')]),
        ),
      );

      // Collect every semantics label in the rendered tree and assert the
      // legend string appears once, not duplicated by an outer group label.
      // Walking the accessibility traversal avoids the deprecated
      // pipelineOwner/SemanticsOwner traversal.
      final labels = tester.semantics
          .simulatedAccessibilityTraversal()
          .map((SemanticsNode node) => node.label)
          .where((label) => label.isNotEmpty);
      final legendCount = labels
          .expand((l) => l.split('\n'))
          .where((l) => l == 'Adresse')
          .length;
      expect(legendCount, 1);
      handle.dispose();
    });

    testWidgets('renders the optional description', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsFieldset(
            legend: 'Adresse',
            description: 'Oppgi din folkeregistrerte adresse.',
            children: [Text('Felt')],
          ),
        ),
      );
      expect(find.text('Oppgi din folkeregistrerte adresse.'), findsOneWidget);
    });
  });
}
