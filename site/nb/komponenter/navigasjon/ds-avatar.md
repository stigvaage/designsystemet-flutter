# DsAvatar

Avatarbilde eller initialer.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsAvatar" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| child | Widget | påkrevd | Innholdet i avataren (bilde eller tekst) |
| size | DsSize? | null | Størrelse på avataren |
| color | DsColor? | null | Bakgrunnsfarge på avataren |

## Eksempel

```dart
DsAvatar(
  size: DsSize.md,
  child: Text('ON'),
)
```

## Tilgjengelighet

- Dekorativt element med riktig semantikk slik at skjermlesere håndterer det korrekt.
