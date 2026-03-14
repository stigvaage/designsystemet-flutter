# DsDetails

Sammenleggbar detaljseksjon.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsDetails" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| summary | `Widget` | påkrevd | Innholdet som alltid vises (klikkbar overskrift). |
| child | `Widget` | påkrevd | Innholdet som vises når seksjonen er åpen. |
| initiallyOpen | `bool` | `false` | Om seksjonen er åpen ved oppstart. |

## Eksempel

```dart
DsDetails(
  summary: Text('Tekniske detaljer'),
  initiallyOpen: false,
  child: DsParagraph(text: 'Her er de tekniske detaljene.'),
)
```

## Tilgjengelighet

- Har expanded/collapsed-semantikk.
- Tastaturstøtte.
