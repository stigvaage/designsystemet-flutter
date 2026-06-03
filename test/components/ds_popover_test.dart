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
  group('DsPopover', () {
    testWidgets('renders trigger widget', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsPopover(
            trigger: Text('Toggle'),
            content: Text('Popover content'),
          ),
        ),
      );
      expect(find.text('Toggle'), findsOneWidget);
    });

    testWidgets('opens popover content on trigger tap', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsPopover(
            trigger: Text('Toggle'),
            content: Text('Popover content'),
          ),
        ),
      );
      expect(find.text('Popover content'), findsNothing);
      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(find.text('Popover content'), findsOneWidget);
    });

    testWidgets('toggles closed on second trigger tap', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsPopover(trigger: Text('Toggle'), content: Text('Content')),
        ),
      );
      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(find.text('Content'), findsOneWidget);

      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(find.text('Content'), findsNothing);
    });

    testWidgets('popover is within overlay', (tester) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsPopover(
            trigger: Text('Toggle'),
            content: Text('Overlay content'),
          ),
        ),
      );
      await tester.tap(find.text('Toggle'));
      await tester.pump();
      // Content is rendered inside the overlay
      expect(find.text('Overlay content'), findsOneWidget);
    });

    testWidgets('fires onOpen and onClose on trigger taps', (tester) async {
      var opened = 0;
      var closed = 0;
      await tester.pumpWidget(
        wrapWithOverlay(
          DsPopover(
            trigger: const Text('Toggle'),
            content: const Text('Content'),
            onOpen: () => opened++,
            onClose: () => closed++,
          ),
        ),
      );
      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(opened, 1);
      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(closed, 1);
    });

    testWidgets('controlled open:true shows content without a tap', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsPopover(
            open: true,
            trigger: Text('Toggle'),
            content: Text('Controlled content'),
          ),
        ),
      );
      await tester.pump(); // run the post-frame show
      expect(find.text('Controlled content'), findsOneWidget);
    });

    testWidgets('tinted variant fills with the tinted surface', (tester) async {
      final tinted = DsThemeDigdir.light().colorScheme
          .resolve(DsColor.accent)
          .surfaceTinted;
      await tester.pumpWidget(
        wrapWithOverlay(
          const DsPopover(
            variant: DsPopoverVariant.tinted,
            trigger: Text('Toggle'),
            content: Text('Content'),
          ),
        ),
      );
      await tester.tap(find.text('Toggle'));
      await tester.pump();
      final hasTintedFill = tester
          .widgetList<Container>(find.byType(Container))
          .any((c) {
            final d = c.decoration;
            return d is BoxDecoration && d.color == tinted;
          });
      expect(hasTintedFill, isTrue);
    });
  });
}
