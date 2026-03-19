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
  group('DsCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsCard(child: Text('Card content'))),
      );
      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('non-elevated shows border, no shadow', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsCard(child: Text('Card'))),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('elevated shows shadow, no border', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsCard(elevated: true, child: Text('Card'))),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('interactive card has button semantics when onTap set', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(DsCard(onTap: () {}, child: const Text('Click'))),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('onTap called when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          DsCard(onTap: () => tapped = true, child: const Text('Tap me')),
        ),
      );
      await tester.tap(find.byType(DsCard));
      expect(tapped, isTrue);
    });

    testWidgets('DsCardHeader applies correct padding', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsCardHeader(child: Text('Header'))),
      );
      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(
        padding.padding,
        const EdgeInsets.fromLTRB(16, 16, 16, 8),
      );
    });

    testWidgets('DsCardFooter applies correct padding', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsCardFooter(child: Text('Footer'))),
      );
      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(
        padding.padding,
        const EdgeInsets.fromLTRB(16, 8, 16, 16),
      );
    });
  });
}
