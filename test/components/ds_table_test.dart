import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {double? height}) {
  return DsTheme(
    data: DsThemeDigdir.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 400, height: height, child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('DsTable', () {
    testWidgets('renders header and body cells', (tester) async {
      await tester.pumpWidget(
        host(
          const DsTable(
            columns: [Text('Name'), Text('Age')],
            rows: [
              [Text('Alice'), Text('30')],
              [Text('Bob'), Text('25')],
            ],
          ),
        ),
      );
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('onRowTap fires with the tapped row index', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        host(
          DsTable(
            columns: const [Text('Name')],
            rows: const [
              [Text('Alice')],
              [Text('Bob')],
            ],
            onRowTap: (i) => tapped = i,
          ),
        ),
      );
      await tester.tap(find.text('Bob'));
      expect(tapped, 1);
    });

    testWidgets('sortable header fires onSort and shows the direction icon', (
      tester,
    ) async {
      int? sorted;
      await tester.pumpWidget(
        host(
          DsTable(
            columns: const [Text('Name'), Text('Age')],
            rows: const [
              [Text('A'), Text('1')],
            ],
            sortColumn: 0,
            sortDirection: DsSortDirection.ascending,
            onSort: (i) => sorted = i,
          ),
        ),
      );
      // Active ascending column shows the chevron-up indicator.
      expect(find.byIcon(DsIcons.chevronUp), findsOneWidget);
      await tester.tap(find.text('Age'));
      expect(sorted, 1);
    });

    testWidgets('sortable header is keyboard-focusable and activates with '
        'Enter', (tester) async {
      int? sorted;
      await tester.pumpWidget(
        host(
          DsTable(
            columns: const [Text('Name'), Text('Age')],
            rows: const [
              [Text('A'), Text('1')],
            ],
            onSort: (i) => sorted = i,
          ),
        ),
      );

      // Focus the sortable header (its enclosing Focus node) and activate it
      // with Enter — proves WCAG 2.1.1 keyboard operability.
      Focus.of(tester.element(find.text('Name'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(sorted, 0);
    });

    testWidgets('sortable header activates with Space when focused', (
      tester,
    ) async {
      int? sorted;
      await tester.pumpWidget(
        host(
          DsTable(
            columns: const [Text('Name'), Text('Age')],
            rows: const [
              [Text('A'), Text('1')],
            ],
            onSort: (i) => sorted = i,
          ),
        ),
      );

      Focus.of(tester.element(find.text('Age'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(sorted, 1);
    });

    testWidgets('non-sortable header cells expose header semantics', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          const DsTable(
            columns: [Text('Name'), Text('Age')],
            rows: [
              [Text('Alice'), Text('30')],
            ],
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('Name')).flagsCollection.isHeader,
        isTrue,
      );
      expect(
        tester.getSemantics(find.text('Age')).flagsCollection.isHeader,
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('renders caption and footer rows', (tester) async {
      await tester.pumpWidget(
        host(
          const DsTable(
            columns: [Text('Name'), Text('Amount')],
            rows: [
              [Text('Alice'), Text('30')],
            ],
            caption: Text('Brukere'),
            footerRows: [
              [Text('Sum'), Text('30')],
            ],
          ),
        ),
      );
      expect(find.text('Brukere'), findsOneWidget);
      expect(find.text('Sum'), findsOneWidget);
    });

    testWidgets('stickyHeader uses a CustomScrollView when height is bounded', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const DsTable(
            columns: [Text('Name')],
            rows: [
              [Text('a')],
              [Text('b')],
            ],
            stickyHeader: true,
          ),
          height: 120,
        ),
      );
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('stickyHeader degrades to a column inside an unbounded '
        'scrollable', (tester) async {
      await tester.pumpWidget(
        DsTheme(
          data: DsThemeDigdir.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: DsTable(
                    columns: [Text('Name')],
                    rows: [
                      [Text('a')],
                    ],
                    stickyHeader: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      // Unbounded vertical constraints → falls back to a non-scrolling column.
      expect(find.byType(CustomScrollView), findsNothing);
      expect(find.text('a'), findsOneWidget);
    });
  });
}
