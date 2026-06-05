import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:designsystemet_flutter/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsTheme', () {
    testWidgets('of() returns theme data when present', (tester) async {
      late DsThemeData result;
      await tester.pumpWidget(
        DsTheme(
          data: DsThemeDigdir.light(),
          child: Builder(
            builder: (context) {
              result = DsTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(result.brightness, Brightness.light);
    });

    testWidgets('maybeOf() returns null when no DsTheme', (tester) async {
      DsThemeData? result;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            result = DsTheme.maybeOf(context);
            return const SizedBox();
          },
        ),
      );
      expect(result, isNull);
    });

    testWidgets('of() throws descriptive error when missing', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => DsTheme.of(context),
              throwsA(
                isA<FlutterError>().having(
                  (e) => e.message,
                  'message',
                  contains('No DsTheme found'),
                ),
              ),
            );
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('updateShouldNotify rebuilds dependents on data change', (
      tester,
    ) async {
      var buildCount = 0;
      Brightness? seen;
      late StateSetter setData;
      var data = DsThemeDigdir.light();

      // The dependent is a separate widget whose element only rebuilds via the
      // InheritedWidget dependency, not via the StatefulBuilder's setState.
      final dependent = Builder(
        builder: (context) {
          buildCount++;
          seen = DsTheme.of(context).brightness;
          return const SizedBox();
        },
      );

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setData = setState;
            return DsTheme(data: data, child: dependent);
          },
        ),
      );

      expect(buildCount, 1);
      expect(seen, Brightness.light);

      // Swap to a different (dark) theme: dependent must rebuild with new value.
      setData(() => data = DsThemeDigdir.dark());
      await tester.pump();
      expect(buildCount, 2);
      expect(seen, Brightness.dark);

      // Swap to a value-equal theme: updateShouldNotify is false, no rebuild.
      setData(() => data = DsThemeDigdir.dark());
      await tester.pump();
      expect(buildCount, 2);
    });
  });

  group('DsColorScope', () {
    testWidgets('of() defaults to accent when no scope', (tester) async {
      late DsColor result;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            result = DsColorScope.of(context);
            return const SizedBox();
          },
        ),
      );
      expect(result, DsColor.accent);
    });

    testWidgets('of() returns overridden color', (tester) async {
      late DsColor result;
      await tester.pumpWidget(
        DsColorScope(
          color: DsColor.danger,
          child: Builder(
            builder: (context) {
              result = DsColorScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(result, DsColor.danger);
    });
  });

  group('DsSizeScope', () {
    testWidgets('of() defaults to md when no scope', (tester) async {
      late DsSize result;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            result = DsSizeScope.of(context);
            return const SizedBox();
          },
        ),
      );
      expect(result, DsSize.md);
    });

    testWidgets('of() returns overridden size', (tester) async {
      late DsSize result;
      await tester.pumpWidget(
        DsSizeScope(
          size: DsSize.lg,
          child: Builder(
            builder: (context) {
              result = DsSizeScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(result, DsSize.lg);
    });
  });
}
