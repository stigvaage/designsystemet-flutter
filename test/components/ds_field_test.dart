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
  group('DsField', () {
    testWidgets('renders child input', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsField(child: Text('input placeholder'))),
      );
      expect(find.text('input placeholder'), findsOneWidget);
    });

    testWidgets('renders label when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsField(label: 'Email', child: Text('input'))),
      );
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(
            description: 'Enter your email address',
            child: Text('input'),
          ),
        ),
      );
      expect(find.text('Enter your email address'), findsOneWidget);
    });

    testWidgets('renders validation message when error set', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(error: 'This field is required', child: Text('input')),
        ),
      );
      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('no validation message when error is null', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsField(child: Text('input'))),
      );
      expect(find.byType(DsValidationMessage), findsNothing);
    });

    testWidgets('DsFieldScope propagates error to descendants', (tester) async {
      String? capturedError;
      await tester.pumpWidget(
        wrapWithTheme(
          DsField(
            error: 'Field error',
            child: Builder(
              builder: (context) {
                capturedError = DsFieldScope.of(context)?.error;
                return const Text('input');
              },
            ),
          ),
        ),
      );
      expect(capturedError, 'Field error');
    });

    testWidgets(
      'DsFieldScope propagates label and description to descendants',
      (tester) async {
        String? capturedLabel;
        String? capturedDescription;
        await tester.pumpWidget(
          wrapWithTheme(
            DsField(
              label: 'E-post',
              description: 'Vi sender bekreftelse hit',
              child: Builder(
                builder: (context) {
                  final scope = DsFieldScope.of(context);
                  capturedLabel = scope?.label;
                  capturedDescription = scope?.description;
                  return const Text('input');
                },
              ),
            ),
          ),
        );
        expect(capturedLabel, 'E-post');
        expect(capturedDescription, 'Vi sender bekreftelse hit');
      },
    );

    testWidgets('exposes label as the input semantics name', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsField(label: 'E-post', child: Text('input'))),
      );
      // The label is re-exposed programmatically via Semantics and merged into
      // the input node; the visible DsLabel itself is excluded from semantics.
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'E-post',
        ),
        findsOneWidget,
      );
    });

    testWidgets('exposes description and error as the input semantics hint', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(
            label: 'E-post',
            description: 'Hjelpetekst',
            error: 'Ugyldig e-post',
            child: Text('input'),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.hint == 'Hjelpetekst. Ugyldig e-post',
        ),
        findsOneWidget,
      );
    });

    testWidgets('no semantics hint when neither description nor error set', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsField(label: 'E-post', child: Text('input'))),
      );
      // The label-bearing Semantics node carries no hint.
      final semantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'E-post',
        ),
      );
      expect(semantics.properties.hint, isNull);
    });

    testWidgets('validation message sits in a live region', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(error: 'Påkrevd felt', child: Text('input')),
        ),
      );
      final liveRegion = tester.widget<Semantics>(
        find
            .ancestor(
              of: find.byType(DsValidationMessage),
              matching: find.byWidgetPredicate(
                (w) => w is Semantics && w.properties.liveRegion == true,
              ),
            )
            .first,
      );
      expect(liveRegion.properties.liveRegion, isTrue);
    });

    // Finding #25: description text must scale with `size` instead of being
    // pinned to a single size. Mapping mirrors DsLabel: sm→bodySm (16),
    // md→bodyMd (18), lg→bodyLg (21) at the reference theme scale.
    for (final (size, expectedFontSize) in const [
      (DsSize.sm, 16.0),
      (DsSize.md, 18.0),
      (DsSize.lg, 21.0),
    ]) {
      testWidgets('description scales with size $size', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DsField(
              size: size,
              description: 'Hjelpetekst',
              child: const Text('input'),
            ),
          ),
        );
        final text = tester.widget<Text>(find.text('Hjelpetekst'));
        expect(text.style?.fontSize, expectedFontSize);
      });
    }

    testWidgets('description defaults to md (bodyMd) so it matches the label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(description: 'Hjelpetekst', child: Text('input')),
        ),
      );
      final text = tester.widget<Text>(find.text('Hjelpetekst'));
      expect(text.style?.fontSize, 18.0);
    });

    testWidgets('description inherits size from DsSizeScope', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsSizeScope(
            size: DsSize.sm,
            child: DsField(description: 'Hjelpetekst', child: Text('input')),
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('Hjelpetekst'));
      expect(text.style?.fontSize, 16.0);
    });

    // Finding #25: DsValidationMessage takes no size param and pins itself to
    // bodyMd, so DsField scales it by the ratio of the resolved body size to
    // bodyMd (sm→16/18, md→1.0, lg→21/18) layered on top of any user scaling.
    for (final (size, expectedFactor) in const [
      (DsSize.sm, 16 / 18),
      (DsSize.md, 1.0),
      (DsSize.lg, 21 / 18),
    ]) {
      testWidgets('validation message scaled for size $size', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            DsField(
              size: size,
              error: 'Påkrevd felt',
              child: const Text('input'),
            ),
          ),
        );
        final mq = tester.widget<MediaQuery>(
          find
              .ancestor(
                of: find.byType(DsValidationMessage),
                matching: find.byType(MediaQuery),
              )
              .first,
        );
        // scale(16) / 16 isolates the applied factor independent of font size.
        expect(
          mq.data.textScaler.scale(16) / 16,
          closeTo(expectedFactor, 1e-9),
        );
      });
    }

    testWidgets('validation scaling composes with user text scaling', (
      tester,
    ) async {
      await tester.pumpWidget(
        DsTheme(
          data: DsThemeDigdir.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: DsField(
                size: DsSize.lg,
                error: 'Påkrevd felt',
                child: Text('input'),
              ),
            ),
          ),
        ),
      );
      final mq = tester.widget<MediaQuery>(
        find
            .ancestor(
              of: find.byType(DsValidationMessage),
              matching: find.byType(MediaQuery),
            )
            .first,
      );
      // User 2.0 scaling times the lg field factor (bodyLg/bodyMd = 21/18).
      expect(mq.data.textScaler.scale(16) / 16, closeTo(2.0 * 21 / 18, 1e-9));
    });
  });
}
