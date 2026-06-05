import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/src/utils/ds_focus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithTheme(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('Focus indicator', () {
    // The visible focus ring (WCAG 2.4.7) is a [DsColorScale.borderStrong]
    // border of [DsFocus.ringWidth] (3 px). All three controls default to the
    // [DsColor.accent] scale, so we match against that scale's borderStrong.
    final colorScale = DsThemeDigdir.light().colorScheme.resolve(
      DsColor.accent,
    );

    bool hasFocusRing(WidgetTester tester) {
      return tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((
        d,
      ) {
        final decoration = d.decoration;
        if (decoration is! BoxDecoration) return false;
        final border = decoration.border;
        return border is Border &&
            border.top.color == colorScale.borderStrong &&
            border.top.width == DsFocus.ringWidth;
      });
    }

    testWidgets('DsButton shows focus ring only when focused', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        wrapWithTheme(
          DsButton(
            onPressed: () {},
            focusNode: focusNode,
            child: const Text('Focused'),
          ),
        ),
      );

      // No visible ring before focus (a transparent ring is reserved instead).
      expect(hasFocusRing(tester), isFalse);

      focusNode.requestFocus();
      // One pump applies the focus; a second pump flushes the
      // onFocusChange->setState rebuild that repaints the (now visible) ring.
      await tester.pump();
      await tester.pump();

      // The borderStrong ring appears once focused.
      expect(hasFocusRing(tester), isTrue);
      focusNode.dispose();
    });

    testWidgets('DsCheckbox shows focus ring only when focused', (
      tester,
    ) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        wrapWithTheme(
          DsCheckbox(value: false, onChanged: (_) {}, focusNode: focusNode),
        ),
      );

      expect(hasFocusRing(tester), isFalse);

      focusNode.requestFocus();
      // One pump applies the focus; a second pump flushes the
      // onFocusChange->setState rebuild that repaints the (now visible) ring.
      await tester.pump();
      await tester.pump();

      expect(hasFocusRing(tester), isTrue);
      focusNode.dispose();
    });

    testWidgets('DsRadio shows focus ring only when focused', (tester) async {
      final focusNode = FocusNode();
      await tester.pumpWidget(
        wrapWithTheme(
          DsRadio(value: false, onChanged: (_) {}, focusNode: focusNode),
        ),
      );

      expect(hasFocusRing(tester), isFalse);

      focusNode.requestFocus();
      // One pump applies the focus; a second pump flushes the
      // onFocusChange->setState rebuild that repaints the (now visible) ring.
      await tester.pump();
      await tester.pump();

      expect(hasFocusRing(tester), isTrue);
      focusNode.dispose();
    });
  });
}
