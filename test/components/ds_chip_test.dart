import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsChip', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsChip(child: Text('Flutter'))),
      );
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('selected chip uses base color background', (tester) async {
      final theme = DsThemeDigdir.light();
      final colorScale = theme.colorScheme.resolve(DsColor.accent);
      await tester.pumpWidget(
        wrapWithTheme(const DsChip(selected: true, child: Text('Active'))),
      );
      // The outer Container should have baseDefault background
      final containers = tester.widgetList<Container>(find.byType(Container));
      final chipContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == colorScale.baseDefault,
      );
      expect(chipContainer, isNotNull);
    });

    testWidgets('onTap called when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(onTap: () => tapped = true, child: const Text('Tap')),
        ),
      );
      await tester.tap(find.byType(DsChip));
      expect(tapped, isTrue);
    });

    testWidgets('removable shows X icon with "Fjern" label', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(removable: true, onRemove: () {}, child: const Text('Tag')),
        ),
      );
      expect(find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fjern',
        ), findsOneWidget);
    });

    testWidgets('onRemove called when remove icon tapped', (tester) async {
      var removed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(
            removable: true,
            onRemove: () => removed = true,
            child: const Text('Tag'),
          ),
        ),
      );
      await tester.tap(find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Fjern',
        ));
      expect(removed, isTrue);
    });

    testWidgets('has button semantics when onTap set', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsChip(onTap: () {}, child: const Text('Click')),
        ),
      );
      final semantics = tester.getSemantics(find.byType(DsChip));
      expect(semantics.flagsCollection.isButton, isTrue);
    });
  });
}
