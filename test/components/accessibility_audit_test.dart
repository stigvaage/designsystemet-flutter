import 'dart:ui' show CheckedState, Tristate;
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
  group('Accessibility audit', () {
    testWidgets('DsButton has button semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsButton(onPressed: () {}, child: const Text('Click'))),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('DsCheckbox has checked semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsCheckbox(value: true, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isChecked, CheckedState.isTrue);
    });

    testWidgets('DsCheckbox unchecked semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsCheckbox(value: false, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isChecked, isNot(CheckedState.none));
    });

    testWidgets('DsRadio has selected semantics when selected', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsRadio(value: true, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
    });

    testWidgets('DsSwitch has toggled semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsSwitch(value: true, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isToggled, Tristate.isTrue);
    });

    testWidgets('DsInput has textField semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsInput()));
      final semantics = tester.getSemantics(find.byType(EditableText));
      expect(semantics.flagsCollection.isTextField, isTrue);
    });

    testWidgets('DsHeading has header semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsHeading(text: 'Title')));
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isHeader, isTrue);
    });

    testWidgets('Disabled button has enabled=false', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(onPressed: () {}, disabled: true, child: const Text('No')),
        ),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.flagsCollection.isEnabled, isNot(Tristate.none));
    });
  });
}
