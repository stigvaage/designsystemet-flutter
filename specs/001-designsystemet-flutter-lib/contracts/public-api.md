# Public API Contract: komponentbibliotek_flutter

**Feature**: 001-designsystemet-flutter-lib
**Date**: 2026-03-14

## Library Entry Points

### Main barrel export (`komponentbibliotek_flutter.dart`)

Exports all public symbols. Consumers use:
```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
```

### Separated entry points (for tree-shaking)

| Entry point | Contents |
|-------------|----------|
| `package:komponentbibliotek_flutter/theme.dart` | DsTheme, DsThemeData, DsColorScheme, DsColorScale, DsSizeTokens, DsTypography, DsBorderRadiusTokens, DsShadowTokens, DsColorScope, DsSizeScope, enums |
| `package:komponentbibliotek_flutter/components.dart` | All 40 component widgets |
| `package:komponentbibliotek_flutter/typography.dart` | DsHeading, DsParagraph, DsLabel, DsValidationMessage |

## Theme API Contract

### DsTheme (InheritedWidget)

```dart
class DsTheme extends InheritedWidget {
  const DsTheme({required this.data, required super.child});
  final DsThemeData data;

  /// Returns the nearest DsThemeData, or throws a descriptive error.
  static DsThemeData of(BuildContext context);

  /// Returns the nearest DsThemeData, or null.
  static DsThemeData? maybeOf(BuildContext context);
}
```

### DsThemeData

```dart
class DsThemeData extends ThemeExtension<DsThemeData> {
  const DsThemeData({
    required this.brightness,
    required this.colorScheme,
    required this.sizeTokens,
    required this.typography,
    required this.borderRadius,
    required this.shadows,
    this.disabledOpacity = 0.3,
  });

  factory DsThemeData.digdir({Brightness brightness = Brightness.light});
  factory DsThemeData.fromTokens(Map<String, dynamic> json);

  final Brightness brightness;
  final DsColorScheme colorScheme;
  final DsSizeTokens sizeTokens;
  final DsTypography typography;
  final DsBorderRadiusTokens borderRadius;
  final DsShadowTokens shadows;
  final double disabledOpacity;

  // ThemeExtension overrides
  @override DsThemeData copyWith({...});
  @override DsThemeData lerp(DsThemeData? other, double t);
}
```

### DsColorScope

```dart
class DsColorScope extends InheritedWidget {
  const DsColorScope({required this.color, required super.child});
  final DsColor color;

  /// Returns the active DsColor, defaulting to DsColor.accent.
  static DsColor of(BuildContext context);
}
```

### DsSizeScope

```dart
class DsSizeScope extends InheritedWidget {
  const DsSizeScope({required this.size, required super.child});
  final DsSize size;

  /// Returns the active DsSize, defaulting to DsSize.md.
  static DsSize of(BuildContext context);
}
```

## Component API Contracts

### Common pattern (all 40 components)

Every visible component follows:
- Accepts optional `DsSize? size` (null = inherit from DsSizeScope)
- Accepts optional `DsColor? color` (null = inherit from DsColorScope)
- Supports `Key? key` for widget identity
- Is a `StatelessWidget` or `StatefulWidget` (not an abstract class)

### DsButton

```dart
class DsButton extends StatelessWidget {
  const DsButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = DsButtonVariant.primary,
    this.size,
    this.color,
    this.disabled = false,
    this.loading = false,
    this.icon,
    this.iconPosition = DsIconPosition.left,
    this.focusNode,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final DsButtonVariant variant;
  final DsSize? size;
  final DsColor? color;
  final bool disabled;
  final bool loading;
  final Widget? icon;
  final DsIconPosition iconPosition;
  final FocusNode? focusNode;
}
```

### DsAlert

```dart
class DsAlert extends StatelessWidget {
  const DsAlert({
    super.key,
    required this.child,
    this.severity = DsSeverity.info,
    this.title,
    this.closable = false,
    this.onClose,
    this.color,
    this.size,
  });

  final Widget child;
  final DsSeverity severity;
  final Widget? title;
  final bool closable;
  final VoidCallback? onClose;
  final DsColor? color;
  final DsSize? size;
}
```

### DsCard

```dart
class DsCard extends StatelessWidget {
  const DsCard({
    super.key,
    required this.child,
    this.color,
    this.elevated = false,
    this.onTap,
    this.focusNode,
  });

  final Widget child;
  final DsColor? color;
  final bool elevated;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
}

class DsCardHeader extends StatelessWidget { ... }
class DsCardBlock extends StatelessWidget { ... }
class DsCardFooter extends StatelessWidget { ... }
```

### DsTextfield

```dart
class DsTextfield extends StatelessWidget {
  const DsTextfield({
    super.key,
    this.controller,
    this.size,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final DsSize? size;
  final String? error;
  final bool disabled;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final bool autofocus;
}
```

### DsField

```dart
class DsField extends StatelessWidget {
  const DsField({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.error,
    this.size,
  });

  final Widget child;
  final String? label;
  final String? description;
  final String? error;
  final DsSize? size;
}
```

### DsCheckbox

```dart
class DsCheckbox extends StatelessWidget {
  const DsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.size,
    this.color,
    this.error,
    this.indeterminate = false,
    this.readOnly = false,
    this.focusNode,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final DsSize? size;
  final DsColor? color;
  final String? error;
  final bool indeterminate;
  final bool readOnly;
  final FocusNode? focusNode;
}
```

### DsHeading

```dart
class DsHeading extends StatelessWidget {
  const DsHeading({
    super.key,
    required this.text,
    this.level = DsHeadingLevel.md,
    this.size,
    this.color,
  });

  final String text;
  final DsHeadingLevel level;
  final DsSize? size;
  final DsColor? color;
}
```

### DsParagraph

```dart
class DsParagraph extends StatelessWidget {
  const DsParagraph({
    super.key,
    required this.text,
    this.bodySize = DsBodySize.md,
    this.variant = DsBodyVariant.standard,
    this.size,
    this.color,
  });

  final String text;
  final DsBodySize bodySize;
  final DsBodyVariant variant;
  final DsSize? size;
  final DsColor? color;
}
```

## Code Generator CLI Contract

### Usage

```bash
dart run komponentbibliotek_flutter:generate \
  --tokens-dir <path-to-design-tokens> \
  --output <output-directory>
```

### Input

Directory of W3C-format JSON token files produced by:
```bash
npx @digdir/designsystemet tokens create --config designsystemet.config.json
```

### Output

One Dart file per theme, named `ds_theme_<theme_name>.dart`, containing:
```dart
class DsTheme<ThemeName> {
  static DsThemeData light() => DsThemeData(...);
  static DsThemeData dark() => DsThemeData(...);
}
```

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Invalid arguments |
| 2 | Token directory not found or empty |
| 3 | Token JSON parse error |
