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
  group('DsAvatar', () {
    testWidgets('renders initials from single name', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Stig')));
      expect(find.text('S'), findsOneWidget);
    });

    testWidgets('renders initials from full name', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Stig Vage')));
      expect(find.text('SV'), findsOneWidget);
    });

    testWidgets('renders "?" when name is null', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar()));
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders "?" without exception when name is empty', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: '')));
      expect(tester.takeException(), isNull);
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders "?" without exception when name is whitespace only', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: '   ')));
      expect(tester.takeException(), isNull);
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders initials ignoring surrounding whitespace', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAvatar(name: '  Stig   Vage  ')),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('SV'), findsOneWidget);
    });

    testWidgets('has image semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Test')));
      final semantics = tester.getSemantics(find.byType(DsAvatar));
      expect(semantics.flagsCollection.isImage, isTrue);
    });

    testWidgets('circle variant uses a circular shape', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsAvatar(name: 'Stig')));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsAvatar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.borderRadius, isNull);
    });

    testWidgets('square variant uses a rounded rectangle shape', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatar(name: 'Stig', variant: DsAvatarVariant.square),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DsAvatar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.rectangle);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('semantic label is name or "Profilbilde" fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsAvatar(name: 'Kari Nordmann')),
      );
      var semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Kari Nordmann',
        ),
      );
      expect(semanticsWidget.properties.label, 'Kari Nordmann');

      await tester.pumpWidget(wrapWithTheme(const DsAvatar()));
      semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Profilbilde',
        ),
      );
      expect(semanticsWidget.properties.label, 'Profilbilde');
    });
  });
}
