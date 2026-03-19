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
  group('DsField', () {
    testWidgets('renders child input', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(child: Text('input placeholder')),
        ),
      );
      expect(find.text('input placeholder'), findsOneWidget);
    });

    testWidgets('renders label when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(label: 'Email', child: Text('input')),
        ),
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
          const DsField(
            error: 'This field is required',
            child: Text('input'),
          ),
        ),
      );
      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('no validation message when error is null', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DsField(child: Text('input')),
        ),
      );
      expect(find.byType(DsValidationMessage), findsNothing);
    });

    testWidgets('DsFieldScope propagates error to descendants', (
      tester,
    ) async {
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
  });
}
