# Theme Setup Guide

## 1. Add dependency

Add to your `pubspec.yaml`:

```yaml
dependencies:
  designsystemet_flutter: ^0.3.0
```

## 2. Import

```dart
import 'package:designsystemet_flutter/theme.dart';
import 'package:designsystemet_flutter/components.dart';
```

## 3. Wrap your app with DsTheme

```dart
void main() {
  runApp(
    DsTheme(
      data: DsThemeDigdir.light(),
      child: MyApp(),
    ),
  );
}
```

For dark mode, use `DsThemeDigdir.dark()`.

## 4. Use color and size scoping

```dart
DsColorScope(
  color: DsColor.info,
  child: DsAlert(
    child: Text('Info message'),
  ),
)

DsSizeScope(
  size: DsSize.sm,
  child: DsButton(
    onPressed: () {},
    child: Text('Small button'),
  ),
)
```

## 5. Access tokens

```dart
final theme = DsTheme.of(context);
final colorScale = theme.colorScheme.resolve(DsColor.accent);
final typography = theme.typography;
final sizes = theme.sizeTokens;
final borderRadius = theme.borderRadius;
```

## 6. Default accent color (dark blue #003087)

The built-in `DsThemeDigdir` theme uses the dark blue **#003087** as the
`accent` base color (`accent.baseDefault`). The full 16-step accent scale
(background → surface → border → text → base/contrast) is derived from this base
and meets WCAG 2.1 AA contrast.

To generate a custom theme from a different brand color, author DTCG token JSON
(e.g. via the official `@digdir/designsystemet` CLI or
`https://theme.designsystemet.no`), then run the bundled Dart generator:

```bash
dart run designsystemet_flutter:generate \
  --tokens-dir design-tokens \
  --output lib/generated
```

This emits a `DsThemeData` (light + dark) you can pass to `DsTheme(data: ...)`.
