# Tema

Temasystemet i Designsystemet Flutter styres gjennom `DsThemeData`, som samler alle designtokens i ett sentralt objekt.

## DsThemeData

`DsThemeData` er hovedklassen for tema og inneholder alle designtokens som komponentene bruker:

| Egenskap | Type | Beskrivelse |
|---|---|---|
| `brightness` | `Brightness` | Lyst eller morkt modus |
| `colorScheme` | `DsColorScheme` | Alle fargeskalaer |
| `sizeTokens` | `DsSizeTokens` | Storrelsestokens |
| `typography` | `DsTypography` | Typografidefinisjon |
| `borderRadius` | `DsBorderRadiusTokens` | Avrundingstokens |
| `shadows` | `DsShadowTokens` | Skyggetokens |
| `disabledOpacity` | `double` | Opasitet for deaktiverte elementer (standard `0.3`) |

## Fabrikkmetoder

### Digdir-tema (lyst modus)

```dart
final lystTema = DsThemeData.digdir();
```

### Digdir-tema (morkt modus)

```dart
final morktTema = DsThemeData.digdir(brightness: Brightness.dark);
```

### Egendefinert tema fra JSON

Brukes typisk sammen med tokens generert fra Designsystemet CLI:

```dart
final egendefinertTema = DsThemeData.fromTokens(jsonMap);
```

## DsTheme InheritedWidget

`DsTheme` er en `InheritedWidget` som gjor temadata tilgjengelig nedover i widget-treet. Alle komponenter krever en `DsTheme`-ancestor.

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
      data: DsThemeData.digdir(),
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
    extensions: [DsThemeData.digdir()],
  ),
  home: DsTheme(
    data: DsThemeData.digdir(),
    child: const MinApp(),
  ),
);
```

## copyWith og lerp

`DsThemeData` implementerer bade `copyWith` og `lerp`, som gjor det mulig a overstyre enkelttokens og animere mellom temaer.

### Overstyre enkeltverdier

```dart
final tilpassetTema = DsThemeData.digdir().copyWith(
  disabledOpacity: 0.5,
);
```

### Animere mellom temaer

```dart
final mellomTema = DsThemeData.lerp(lystTema, morktTema, 0.5);
```

Dette er nyttig for a lage jevne overganger mellom lyst og morkt modus med `AnimatedBuilder` eller `TweenAnimationBuilder`.
