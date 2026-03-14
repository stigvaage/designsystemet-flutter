import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komponentbibliotek_flutter/theme.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

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
              throwsA(isA<FlutterError>().having(
                (e) => e.message,
                'message',
                contains('No DsTheme found'),
              )),
            );
            return const SizedBox();
          },
        ),
      );
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
