# DsErrorSummary

Feilsammendrag for skjemavalidering — viser alle feil samlet.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsErrorSummary" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| errors | `List<DsErrorEntry>` | påkrevd | Liste over feil som skal vises. |
| title | `String?` | `null` | Overskrift for feilsammendraget. |
| size | `DsSize?` | `null` | Størrelse på feilsammendraget. |

## Eksempel

```dart
DsErrorSummary(
  title: 'Rett følgende feil for å gå videre:',
  errors: [
    DsErrorEntry(field: 'Navn', message: 'Navn er påkrevd'),
    DsErrorEntry(field: 'E-post', message: 'Ugyldig e-postadresse'),
  ],
)
```

## Tilgjengelighet

- Bruker alert-semantikk for å varsle om feil.
- Lenker til feilaktige felt.
