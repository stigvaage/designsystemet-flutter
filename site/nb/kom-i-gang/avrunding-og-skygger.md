# Avrunding og skygger

Avrunding og skygger er en del av temasystemet og brukes internt av komponentene.

## DsBorderRadiusTokens

Avrundingstokens er tilgjengelige gjennom `DsThemeData.borderRadius` og definerer standardverdier for hjørneavrunding på komponenter som knapper, kort og skjemafelt.

```dart
final avrunding = DsTheme.of(context).borderRadius;
```

Komponentene bruker disse verdiene automatisk. Du trenger normalt ikke å referere til dem direkte.

## DsShadowTokens

Skyggetokens er tilgjengelige gjennom `DsThemeData.shadows` og definerer skygger for ulike elevasjonsnivå.

```dart
final skygger = DsTheme.of(context).shadows;
```

Komponenter som dialoger, popovere og nedtrekkslister bruker skyggetokens automatisk.

## Overstyre i egendefinerte temaer

Både avrunding og skygger kan overstyres når du oppretter et egendefinert tema:

```dart
final tema = DsThemeDigdir.light().copyWith(
  borderRadius: DsBorderRadiusTokens(...),
  shadows: DsShadowTokens(...),
);
```

Dette er nyttig dersom merkevaren din krever andre visuelle uttrykk enn standardtemaet.
