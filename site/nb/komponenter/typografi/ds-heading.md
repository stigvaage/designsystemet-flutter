# DsHeading

Overskrift med 7 nivåer.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Typografi/DsHeading" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Overskriftsteksten. |
| level | `DsHeadingLevel` | `md` | Nivå på overskriften. |
| size | `DsSize?` | `null` | Størrelse på overskriften. |
| color | `DsColor?` | `null` | Fargetema for overskriften. |

## Eksempel

```dart
DsHeading(text: 'Velkommen til tjenesten', level: DsHeadingLevel.xl)
```

## Tilgjengelighet

- Bruker riktig heading-semantikk for skjermlesere.
