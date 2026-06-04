import 'dart:ui' show PointerDeviceKind;

import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithOverlay(Widget child) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]),
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
        wrapWithOverlay(const DsTooltip(message: 'Tip', child: Text('Target'))),
      );
      // Simulate mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(find.text('Target')));
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);

      // Clean up gesture
      await gesture.removePointer();
    });

    testWidgets('exposes the message via Semantics.tooltip', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(const DsTooltip(message: 'Hjelp', child: Text('T'))),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.tooltip == 'Hjelp',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows tooltip on keyboard focus (not only hover)', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithOverlay(
          DsTooltip(
            message: 'Tip',
            child: Focus(focusNode: node, child: const Text('Target')),
          ),
        ),
      );
      expect(find.text('Tip'), findsNothing);
      node.requestFocus();
      await tester.pump(); // apply focus + fire onFocusChange (inserts overlay)
      await tester.pump(); // build the inserted overlay entry
      expect(find.text('Tip'), findsOneWidget);
    });

    testWidgets('stays visible when the pointer exits while still focused', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithOverlay(
          DsTooltip(
            message: 'Tip',
            child: Focus(focusNode: node, child: const Text('Target')),
          ),
        ),
      );

      // Focus first, then hover: both signals are now active.
      node.requestFocus();
      await tester.pump();
      await tester.pump();
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(find.text('Target')));
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);

      // Move the pointer away while focus remains: tooltip must stay visible.
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);

      // Removing focus too hides the tooltip.
      node.unfocus();
      await tester.pump(); // process focus loss → _hide()
      await tester.pump(); // overlay rebuilds without the tooltip
      expect(find.text('Tip'), findsNothing);

      await gesture.removePointer();
    });

    testWidgets('stays visible when focus is lost while still hovered', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrapWithOverlay(
          DsTooltip(
            message: 'Tip',
            child: Focus(focusNode: node, child: const Text('Target')),
          ),
        ),
      );

      // Hover first, then focus: both signals are active.
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(find.text('Target')));
      await tester.pump();
      node.requestFocus();
      await tester.pump();
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);

      // Lose focus while the pointer is still over the trigger.
      node.unfocus();
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);

      // Pointer exit now hides the tooltip.
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();
      expect(find.text('Tip'), findsNothing);

      await gesture.removePointer();
    });

    testWidgets('shows tooltip with a non-default placement', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsTooltip(
            message: 'Tip',
            placement: DsPlacement.bottom,
            child: Text('Target'),
          ),
        ),
      );
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(find.text('Target')));
      await tester.pump();
      expect(find.text('Tip'), findsOneWidget);
      await gesture.removePointer();
    });
  });
}
