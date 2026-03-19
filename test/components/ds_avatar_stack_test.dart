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

    testWidgets('positions children with overlap offset', (tester) async {
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
      final positioned = tester.widgetList<Positioned>(
        find.byType(Positioned),
      ).toList();
      // Each child is at i * (48 - overlap) = i * 40
      expect(positioned[0].left, 0);
      expect(positioned[1].left, 40);
      expect(positioned[2].left, 80);
    });
  });
}
