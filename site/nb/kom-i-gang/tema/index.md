# Tema

Temasystemet i Designsystemet Flutter styres gjennom `DsThemeData`, som samler alle designtokens i ett sentralt objekt.

## DsThemeData

`DsThemeData` er hovedklassen for tema og inneholder alle designtokens som komponentene bruker:

| Egenskap | Type | Beskrivelse |
|---|---|---|
| `brightness` | `Brightness` | Lyst eller mørkt modus |
| `colorScheme` | `DsColorScheme` | Alle fargeskalaer |
| `sizeTokens` | `DsSizeTokens` | Størrelsestokens |
| `typography` | `DsTypography` | Typografidefinisjon |
| `borderRadius` | `DsBorderRadiusTokens` | Avrundingstokens |
| `shadows` | `DsShadowTokens` | Skyggetokens |
| `disabledOpacity` | `double` | Opasitet for deaktiverte elementer (standard `0.3`) |

## Fabrikkmetoder

### Digdir-tema (lyst modus)

```dart
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

final lystTema = DsThemeDigdir.light();
```

### Digdir-tema (mørkt modus)

```dart
final mørktTema = DsThemeDigdir.dark();
```

### Egendefinert tema

Bruk kodegeneratoren til å lage en temafil fra Designsystemet CLI-tokens:

```bash
dart run designsystemet_flutter:generate --tokens-dir ./design-tokens --output lib/generated/
```

## DsTheme InheritedWidget

`DsTheme` er en `InheritedWidget` som gjør temadata tilgjengelig nedover i widget-treet. Alle komponenter krever en `DsTheme`-ancestor.

### Hente tema fra kontekst

```dart
// Kaster feil hvis DsTheme ikke finnes i treet
final tema = DsTheme.of(context);

// Returnerer null hvis DsTheme ikke finnes
final tema = DsTheme.maybeOf(context);
```

### Grunnleggende oppsett

```dart
void main() {
  runApp(
    DsTheme(
      data: DsThemeDigdir.light(),
      child: const MinApp(),
    ),
  );
}
```

## ThemeExtension-integrasjon

`DsThemeData` kan brukes som `ThemeExtension` i en `MaterialApp`, slik at du kan kombinere Designsystemet med Material-komponenter:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [DsThemeDigdir.light()],
  ),
  home: DsTheme(
    data: DsThemeDigdir.light(),
    child: const MinApp(),
  ),
);
```

## copyWith og lerp

`DsThemeData` implementerer både `copyWith` og `lerp`, som gjør det mulig å overstyre enkelttokens og animere mellom temaer.

### Overstyre enkeltverdier

```dart
final tilpassetTema = DsThemeDigdir.light().copyWith(
  disabledOpacity: 0.5,
);
```

### Animere mellom temaer

```dart
final mellomTema = DsThemeData.lerp(lystTema, mørktTema, 0.5);
```

Dette er nyttig for å lage jevne overganger mellom lyst og mørkt modus med `AnimatedBuilder` eller `TweenAnimationBuilder`.
