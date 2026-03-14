import 'package:flutter/widgets.dart';
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
  group('Roving focus', () {
    testWidgets('DsTabs changes selection on tap', (tester) async {
      var selectedTab = 0;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return DsTabs(
              tabs: const ['A', 'B', 'C'],
              initialIndex: selectedTab,
              onChanged: (i) => setState(() => selectedTab = i),
              children: const [
                Text('Panel A'),
                Text('Panel B'),
                Text('Panel C'),
              ],
            );
          },
        ),
      ));
      expect(selectedTab, 0);
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selectedTab, 1);
    });

    testWidgets('DsTabs shows correct panel for selected tab', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DsTabs(
          tabs: ['First', 'Second'],
          initialIndex: 0,
          children: [Text('Content 1'), Text('Content 2')],
        ),
      ));
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);
    });

    testWidgets('DsToggleGroup changes selection on tap', (tester) async {
      var selected = 0;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return DsToggleGroup(
              items: const ['X', 'Y', 'Z'],
              selectedIndex: selected,
              onChanged: (i) => setState(() => selected = i),
            );
          },
        ),
      ));
      expect(selected, 0);
      await tester.tap(find.text('Y'));
      await tester.pump();
      expect(selected, 1);
    });
  });
}
