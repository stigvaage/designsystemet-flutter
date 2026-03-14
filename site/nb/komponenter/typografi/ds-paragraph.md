# DsParagraph

Brødtekst med varianter.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Typografi/DsParagraph" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Avsnittsteksten. |
| bodySize | `DsBodySize` | `md` | Størrelse på brødteksten. |
| variant | `DsBodyVariant` | `standard` | Visuell variant av brødteksten. |
| size | `DsSize?` | `null` | Overordnet størrelse. |
| color | `DsColor?` | `null` | Fargetema for teksten. |

## Eksempel

```dart
DsParagraph(
  text: 'Dette er en avsnittstekst med standard linjehøyde.',
  bodySize: DsBodySize.md,
  variant: DsBodyVariant.standard,
)
```

## Tilgjengelighet

- Bruker riktig paragraph-semantikk.
