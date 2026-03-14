# Quickstart: komponentbibliotek_flutter

**Feature**: 001-designsystemet-flutter-lib
**Date**: 2026-03-14

## 1. Add the dependency

```yaml
# pubspec.yaml
dependencies:
  komponentbibliotek_flutter: ^1.0.0
```

```bash
flutter pub get
```

## 2. Wrap your app with DsTheme

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    DsTheme(
      data: DsThemeData.digdir(), // Built-in Digdir theme, light mode
      child: const MyApp(),
    ),
  );
}
```

For dark mode:
```dart
DsTheme(
  data: DsThemeData.digdir(brightness: Brightness.dark),
  child: const MyApp(),
)
```

## 3. Use components

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DsHeading(text: 'Welcome', level: DsHeadingLevel.lg),
        DsParagraph(text: 'This is a Designsystemet Flutter app.'),
        DsButton(
          variant: DsButtonVariant.primary,
          onPressed: () => print('Pressed!'),
          child: Text('Click me'),
        ),
      ],
    );
  }
}
```

## 4. Use color and size scoping

```dart
// Override color scale for a subtree
DsColorScope(
  color: DsColor.danger,
  child: DsAlert(
    severity: DsSeverity.danger,
    title: Text('Error'),
    child: Text('Something went wrong.'),
  ),
)

// Override size for a subtree
DsSizeScope(
  size: DsSize.lg,
  child: Column(
    children: [
      DsTextfield(controller: nameController),
      DsButton(
        onPressed: submit,
        child: Text('Submit'),
      ),
    ],
  ),
)
```

## 5. Build a form

```dart
DsField(
  label: 'Email',
  description: 'We will not share your email.',
  error: emailError, // null when valid, error message when invalid
  child: DsTextfield(
    controller: emailController,
    error: emailError,
    keyboardType: TextInputType.emailAddress,
  ),
)
```

## 6. Use a custom theme (from Designsystemet CLI)

```bash
# Step 1: Generate tokens
npx @digdir/designsystemet tokens create --config designsystemet.config.json

# Step 2: Generate Dart theme
dart run komponentbibliotek_flutter:generate \
  --tokens-dir ./design-tokens \
  --output lib/generated/
```

```dart
import 'package:my_app/generated/ds_theme_my_theme.dart';

DsTheme(
  data: DsThemeMyTheme.light(),
  child: const MyApp(),
)
```

## 7. Material integration (optional)

If your app already uses `MaterialApp`, integrate via `ThemeExtension`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [DsThemeData.digdir()],
  ),
  home: const MyApp(),
)

// Access in widgets:
final dsTheme = Theme.of(context).extension<DsThemeData>()!;
```

Note: Components still require a `DsTheme` ancestor for the `DsTheme.of(context)` API. Use both `DsTheme` and the extension for maximum compatibility.

## Verification

After setup, this minimal test confirms the library is working:

```dart
// In a widget test
testWidgets('DsButton renders with theme', (tester) async {
  await tester.pumpWidget(
    DsTheme(
      data: DsThemeData.digdir(),
      child: DsButton(
        onPressed: () {},
        child: Text('Test'),
      ),
    ),
  );
  expect(find.text('Test'), findsOneWidget);
});
```
