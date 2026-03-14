# DsLabel

Etikett for skjemaelementer.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Typografi/DsLabel" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Etiketteksten. |
| size | `DsSize?` | `null` | Størrelse på etiketten. |
| color | `DsColor?` | `null` | Fargetema for etiketten. |

## Eksempel

```dart
DsLabel(text: 'Fornavn')
```

## Tilgjengelighet

- Kobles til tilhørende skjemaelement via semantikk.
