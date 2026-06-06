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
  group('DsValidationMessage', () {
    testWidgets('renders the message text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsValidationMessage(message: 'Påkrevd')),
      );
      expect(find.text('Påkrevd'), findsOneWidget);
    });

    testWidgets('uses danger color for errors, success otherwise', (
      tester,
    ) async {
      final scheme = DsThemeDigdir.light().colorScheme;

      await tester.pumpWidget(
        wrapWithTheme(const DsValidationMessage(message: 'Feil')),
      );
      // Offisiell .ds-validation-message bruker *-text-subtle, ikke text-default.
      expect(
        tester.widget<Text>(find.text('Feil')).style?.color,
        scheme.danger.textSubtle,
      );

      await tester.pumpWidget(
        wrapWithTheme(
          const DsValidationMessage(
            message: 'OK',
            severity: DsSeverity.success,
          ),
        ),
      );
      expect(
        tester.widget<Text>(find.text('OK')).style?.color,
        scheme.success.textSubtle,
      );
    });

    testWidgets('maps each severity to its color and icon', (tester) async {
      final scheme = DsThemeDigdir.light().colorScheme;

      for (final (severity, color) in <(DsSeverity, DsColorScale)>[
        (DsSeverity.danger, scheme.danger),
        (DsSeverity.warning, scheme.warning),
        (DsSeverity.info, scheme.info),
        (DsSeverity.success, scheme.success),
      ]) {
        await tester.pumpWidget(
          wrapWithTheme(
            DsValidationMessage(message: 'Melding', severity: severity),
          ),
        );
        expect(
          tester.widget<Text>(find.text('Melding')).style?.color,
          color.textSubtle,
        );
        // Hver variant rendrer et ikon foran teksten.
        expect(find.byType(Icon), findsOneWidget);
      }
    });

    testWidgets('wraps errors and warnings in a live region', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const DsValidationMessage(message: 'Feil')),
      );
      final hasLiveRegion = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.liveRegion == true);
      expect(hasLiveRegion, isTrue);
    });

    testWidgets('does not announce success messages', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsValidationMessage(
            message: 'OK',
            severity: DsSeverity.success,
          ),
        ),
      );
      final hasLiveRegion = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.liveRegion == true);
      expect(hasLiveRegion, isFalse);
    });
  });
}
