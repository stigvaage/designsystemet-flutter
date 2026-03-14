# Theme Setup Guide

## 1. Add dependency

Add to your `pubspec.yaml`:

```yaml
dependencies:
  komponentbibliotek_flutter: ^0.0.1
```

## 2. Import

```dart
import 'package:komponentbibliotek_flutter/theme.dart';
import 'package:komponentbibliotek_flutter/components.dart';
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
