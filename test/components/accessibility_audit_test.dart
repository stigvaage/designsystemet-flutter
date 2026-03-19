import 'dart:ui' show SemanticsFlag;
import 'package:flutter/material.dart';
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
  group('Accessibility audit', () {
    testWidgets('DsButton has button semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsButton(onPressed: () {}, child: const Text('Click'))),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('DsCheckbox has checked semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsCheckbox(value: true, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.isChecked), isTrue);
    });

    testWidgets('DsCheckbox unchecked semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsCheckbox(value: false, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.hasCheckedState), isTrue);
    });

    testWidgets('DsRadio has selected semantics when selected', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsRadio(value: true, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('DsSwitch has toggled semantics', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(DsSwitch(value: true, onChanged: (_) {})),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.isToggled), isTrue);
    });

    testWidgets('DsInput has textField semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsInput()));
      final semantics = tester.getSemantics(find.byType(EditableText));
      expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
    });

    testWidgets('DsHeading has header semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const DsHeading(text: 'Title')));
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.isHeader), isTrue);
    });

    testWidgets('Disabled button has enabled=false', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(onPressed: () {}, disabled: true, child: const Text('No')),
        ),
      );
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.hasFlag(SemanticsFlag.hasEnabledState), isTrue);
    });
  });
}
