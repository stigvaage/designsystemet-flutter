import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('DsSkipLink', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsSkipLink(label: 'Skip to content', onActivate: () {})),
      );
      expect(find.byType(DsSkipLink), findsOneWidget);
    });

    testWidgets('er skjult (offstage) inntil den får fokus', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsSkipLink(label: 'Hopp til innhold', onActivate: () {})),
      );

      // Uten fokus er den visuelle delen skjult bak Offstage.
      expect(tester.widget<Offstage>(find.byType(Offstage)).offstage, isTrue);

      // Gi fokus til DsSkipLink sin egen Focus-node og verifiser at den vises.
      final context = tester.element(find.byType(Offstage));
      Focus.of(context).requestFocus();
      await tester.pumpAndSettle();

      expect(tester.widget<Offstage>(find.byType(Offstage)).offstage, isFalse);
    });

    testWidgets('aktiveres med Enter', (tester) async {
      var activated = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSkipLink(label: 'Hopp til innhold', onActivate: () => activated++),
        ),
      );

      final context = tester.element(find.byType(Offstage));
      Focus.of(context).requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(activated, 1);
    });

    testWidgets('aktiveres med Space', (tester) async {
      var activated = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSkipLink(label: 'Hopp til innhold', onActivate: () => activated++),
        ),
      );

      final context = tester.element(find.byType(Offstage));
      Focus.of(context).requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(activated, 1);
    });

    testWidgets('aktiveres ved trykk når synlig', (tester) async {
      var activated = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSkipLink(label: 'Hopp til innhold', onActivate: () => activated++),
        ),
      );

      // Gi fokus slik at den indre GestureDetector er på skjermen (ikke offstage).
      final context = tester.element(find.byType(Offstage));
      Focus.of(context).requestFocus();
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(DsSkipLink),
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pump();
      expect(activated, 1);
    });

    testWidgets('eksponerer lenkerolle, etikett og en aktiveringshandling', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      var activated = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          DsSkipLink(label: 'Hopp til innhold', onActivate: () => activated++),
        ),
      );

      // Den ytre Semantics-noden annonserer lenke + etikett selv mens den
      // visuelle delen er skjult (offstage).
      final linkSemantics = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.link == true &&
            w.properties.label == 'Hopp til innhold',
      );
      expect(linkSemantics, findsOneWidget);

      // Aktiveringshandlingen finnes på den alltid tilstedeværende noden,
      // slik at skjermlesere kan aktivere lenken mens den er skjult.
      tester.semantics.performAction(
        find.semantics.byLabel('Hopp til innhold'),
        SemanticsAction.tap,
      );
      expect(activated, 1);
      handle.dispose();
    });
  });
}
