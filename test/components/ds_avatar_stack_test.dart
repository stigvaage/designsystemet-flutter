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
  group('DsAvatarStack', () {
    testWidgets('renders all children when under maxVisible', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            maxVisible: 5,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
            ],
          ),
        ),
      );
      expect(find.byType(DsAvatar), findsNWidgets(3));
    });

    testWidgets('limits to maxVisible children', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            maxVisible: 2,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
              DsAvatar(name: 'D'),
            ],
          ),
        ),
      );
      expect(find.byType(DsAvatar), findsNWidgets(2));
    });

    testWidgets('positions children with overlap offset (md)', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            overlap: 8,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
            ],
          ),
        ),
      );
      final positioned = tester
          .widgetList<Positioned>(find.byType(Positioned))
          .toList();
      // Default size md => dimension 40, step = 40 - overlap (8) = 32.
      expect(positioned[0].left, 0);
      expect(positioned[1].left, 32);
      expect(positioned[2].left, 64);
    });

    testWidgets('size sm wires both height and step', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            size: DsSize.sm,
            overlap: 8,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
            ],
          ),
        ),
      );
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(DsAvatarStack),
          matching: find.byType(SizedBox),
        ),
      );
      expect(box.height, 32);
      final positioned = tester
          .widgetList<Positioned>(find.byType(Positioned))
          .toList();
      // dimension 32, step = 32 - 8 = 24.
      expect(positioned[0].left, 0);
      expect(positioned[1].left, 24);
    });

    testWidgets('size lg wires both height and step', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            size: DsSize.lg,
            overlap: 8,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
            ],
          ),
        ),
      );
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(DsAvatarStack),
          matching: find.byType(SizedBox),
        ),
      );
      expect(box.height, 48);
      final positioned = tester
          .widgetList<Positioned>(find.byType(Positioned))
          .toList();
      // dimension 48, step = 48 - 8 = 40.
      expect(positioned[0].left, 0);
      expect(positioned[1].left, 40);
    });

    testWidgets('collapses overflow into +N indicator when max exceeded', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            max: 2,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
              DsAvatar(name: 'D'),
              DsAvatar(name: 'E'),
            ],
          ),
        ),
      );
      // Only [max] avatars shown.
      expect(find.byType(DsAvatar), findsNWidgets(2));
      // Overflow chip counts the 3 hidden avatars.
      expect(find.text('+3'), findsOneWidget);
    });

    testWidgets('no overflow indicator when total <= max', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            max: 5,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
            ],
          ),
        ),
      );
      expect(find.byType(DsAvatar), findsNWidgets(3));
      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('overflow indicator positioned after visible avatars', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            max: 2,
            overlap: 8,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
            ],
          ),
        ),
      );
      final positioned = tester
          .widgetList<Positioned>(find.byType(Positioned))
          .toList();
      // 2 avatars + 1 overflow chip = 3 positioned items.
      expect(positioned.length, 3);
      // md dimension 40, step 32: chip sits at index 2 => 2 * 32 = 64.
      expect(positioned.last.left, 64);
    });

    testWidgets(
      'collapses overflow into +N indicator when maxVisible exceeded',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const DsAvatarStack(
              maxVisible: 3,
              children: [
                DsAvatar(name: 'A'),
                DsAvatar(name: 'B'),
                DsAvatar(name: 'C'),
                DsAvatar(name: 'D'),
                DsAvatar(name: 'E'),
              ],
            ),
          ),
        );
        // maxVisible is the effective limit when max is unset.
        expect(find.byType(DsAvatar), findsNWidgets(3));
        expect(find.text('+2'), findsOneWidget);
      },
    );

    testWidgets('max takes precedence over maxVisible for the overflow cut', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            maxVisible: 5,
            max: 2,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
              DsAvatar(name: 'D'),
            ],
          ),
        ),
      );
      // Even though maxVisible would allow all 4, max=2 wins.
      expect(find.byType(DsAvatar), findsNWidgets(2));
      expect(find.text('+2'), findsOneWidget);
    });

    testWidgets('overflow indicator exposes a Norwegian «+N flere» label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            max: 2,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
              DsAvatar(name: 'D'),
              DsAvatar(name: 'E'),
            ],
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == '+3 flere',
        ),
        findsOneWidget,
      );
    });

    testWidgets('exposes a Norwegian group summary («N brukere»)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
            ],
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == '3 brukere',
        ),
        findsOneWidget,
      );
    });

    testWidgets('group summary counts all children including overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsAvatarStack(
            max: 2,
            children: [
              DsAvatar(name: 'A'),
              DsAvatar(name: 'B'),
              DsAvatar(name: 'C'),
              DsAvatar(name: 'D'),
            ],
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == '4 brukere',
        ),
        findsOneWidget,
      );
    });
  });
}
