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
          const DsPopover(
            trigger: Text('Toggle'),
            content: Text('Content'),
          ),
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
  });
}
