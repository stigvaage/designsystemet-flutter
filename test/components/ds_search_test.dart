import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => DsTheme(
  data: DsThemeDigdir.light(),
  child: MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 300, child: child)),
    ),
  ),
);

Finder _clearIcon() =>
    find.byWidgetPredicate((w) => w is Icon && w.icon == DsIcons.x);

void main() {
  group('DsSearch', () {
    testWidgets('shows the search prefix icon', (tester) async {
      await tester.pumpWidget(_host(const DsSearch()));
      expect(
        find.byWidgetPredicate((w) => w is Icon && w.icon == DsIcons.search),
        findsOneWidget,
      );
    });

    testWidgets('no clear button by default even with text', (tester) async {
      final controller = TextEditingController(text: 'hello');
      addTearDown(controller.dispose);
      await tester.pumpWidget(_host(DsSearch(controller: controller)));
      await tester.pump();
      expect(_clearIcon(), findsNothing);
    });

    testWidgets(
      'clearable: clear button appears after typing, clears and fires onClear',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        var cleared = false;
        String? lastChange;

        await tester.pumpWidget(
          _host(
            DsSearch(
              controller: controller,
              clearable: true,
              onChanged: (v) => lastChange = v,
              onClear: () => cleared = true,
            ),
          ),
        );

        // Empty field -> no clear button.
        expect(_clearIcon(), findsNothing);

        // Type text -> clear button appears.
        await tester.enterText(find.byType(DsSearch), 'flutter');
        await tester.pump();
        expect(controller.text, 'flutter');
        expect(_clearIcon(), findsOneWidget);

        // Tap clear -> field emptied, onChanged('') and onClear fired.
        await tester.tap(_clearIcon());
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(lastChange, '');
        expect(cleared, isTrue);
        expect(_clearIcon(), findsNothing);
      },
    );

    testWidgets(
      'clearable: clear button works after switching from external to internal '
      'controller',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        // Start with an external controller.
        await tester.pumpWidget(
          _host(DsSearch(controller: controller, clearable: true)),
        );
        await tester.pump();

        // Rebuild without the external controller so the widget falls back to
        // its lazily-created internal controller. The listener must follow to
        // the internal controller, otherwise the clear button never appears.
        await tester.pumpWidget(_host(const DsSearch(clearable: true)));
        await tester.pump();

        // No text yet -> no clear button.
        expect(_clearIcon(), findsNothing);

        // Typing into the internal controller must surface the clear button.
        await tester.enterText(find.byType(DsSearch), 'flutter');
        await tester.pump();
        expect(_clearIcon(), findsOneWidget);

        // Tapping it must empty the field and hide the button again.
        await tester.tap(_clearIcon());
        await tester.pump();
        expect(_clearIcon(), findsNothing);
      },
    );

    testWidgets('default placeholder is Norwegian «Søk...»', (tester) async {
      await tester.pumpWidget(_host(const DsSearch()));
      expect(find.text('Søk...'), findsOneWidget);
    });

    testWidgets('placeholder can be overridden', (tester) async {
      await tester.pumpWidget(_host(const DsSearch(placeholder: 'Finn noe')));
      expect(find.text('Finn noe'), findsOneWidget);
      expect(find.text('Søk...'), findsNothing);
    });

    testWidgets('clear button label defaults to «Tøm»', (tester) async {
      final controller = TextEditingController(text: 'hello');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(DsSearch(controller: controller, clearable: true)),
      );
      await tester.pump();
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Tøm',
        ),
        findsOneWidget,
      );
    });

    testWidgets('clearLabel can be overridden', (tester) async {
      final controller = TextEditingController(text: 'hello');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          DsSearch(
            controller: controller,
            clearable: true,
            clearLabel: 'Nullstill',
          ),
        ),
      );
      await tester.pump();
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Nullstill',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Tøm',
        ),
        findsNothing,
      );
    });

    testWidgets('onSubmit alias fires alongside onSubmitted', (tester) async {
      String? submitted;
      String? submit;
      await tester.pumpWidget(
        _host(
          DsSearch(
            onSubmitted: (v) => submitted = v,
            onSubmit: (v) => submit = v,
          ),
        ),
      );

      await tester.enterText(find.byType(DsSearch), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submitted, 'query');
      expect(submit, 'query');
    });
  });
}
