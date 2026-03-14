# Avrunding og skygger

Avrunding og skygger er en del av temasystemet og brukes internt av komponentene.

## DsBorderRadiusTokens

Avrundingstokens er tilgjengelige gjennom `DsThemeData.borderRadius` og definerer standardverdier for hjorneavrunding pa komponenter som knapper, kort og skjemafelt.

```dart
final avrunding = DsTheme.of(context).borderRadius;
```

Komponentene bruker disse verdiene automatisk. Du trenger normalt ikke a referere til dem direkte.

## DsShadowTokens

Skyggetokens er tilgjengelige gjennom `DsThemeData.shadows` og definerer skygger for ulike elevasjonsniva.

```dart
final skygger = DsTheme.of(context).shadows;
```

Komponenter som dialoger, popovere og nedtrekkslister bruker skyggetokens automatisk.

## Overstyre i egendefinerte temaer

Bade avrunding og skygger kan overstyres nar du oppretter et egendefinert tema:

```dart
final tema = DsThemeData.digdir().copyWith(
  borderRadius: DsBorderRadiusTokens(...),
  shadows: DsShadowTokens(...),
);
```

Dette er nyttig dersom merkevaren din krever andre visuelle uttrykk enn standardtemaet.
