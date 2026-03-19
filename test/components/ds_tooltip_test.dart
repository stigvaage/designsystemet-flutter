import 'dart:ui' show PointerDeviceKind;
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
  group('DsTooltip', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsTooltip(message: 'Help text', child: Text('Hover me')),
        ),
      );
      expect(find.text('Hover me'), findsOneWidget);
    });

    testWidgets('tooltip not visible initially', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsTooltip(message: 'Help text', child: Text('Hover me')),
        ),
      );
      expect(find.text('Help text'), findsNothing);
    });

    testWidgets('shows tooltip on mouse hover', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsTooltip(message: 'Tip', child: Text('Target')),
        ),
      );
      // Simulate mouse hover
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(
        location: tester.getCenter(find.text('Target')),
      );
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);

      // Clean up gesture
      await gesture.removePointer();
    });
  });
}
