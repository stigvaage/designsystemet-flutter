import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

Widget wrapWithOverlay(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (_) => child),
        ],
      ),
    ),
  );
}

void main() {
  group('DsSelect', () {
    testWidgets('renders placeholder when no selection', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect(
            items: ['Apple', 'Banana'],
            placeholder: 'Choose fruit',
          ),
        ),
      );
      expect(find.text('Choose fruit'), findsOneWidget);
    });

    testWidgets('renders selected item text', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect(
            items: ['Apple', 'Banana'],
            selectedIndex: 1,
          ),
        ),
      );
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('disabled renders at reduced opacity', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect(
            items: ['Apple'],
            disabled: true,
          ),
        ),
      );
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      final theme = DsThemeDigdir.light();
      expect(opacity.opacity, theme.disabledOpacity);
    });

    testWidgets('disabled does not open dropdown', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect(
            items: ['Apple', 'Banana'],
            disabled: true,
            placeholder: 'Choose',
          ),
        ),
      );
      // DsDropdown is not rendered when disabled
      expect(find.byType(DsDropdown), findsNothing);
    });

    testWidgets('has button semantics with "Velg" label', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect(items: ['A', 'B']),
        ),
      );
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Velg',
        ),
      );
      expect(semanticsWidget.properties.button, isTrue);
    });

    testWidgets('error state renders with DsSelect', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsSelect(
            items: ['A'],
            error: 'Required',
          ),
        ),
      );
      // DsSelect with error still renders
      expect(find.byType(DsSelect), findsOneWidget);
    });
  });
}
