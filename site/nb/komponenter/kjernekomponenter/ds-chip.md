# DsChip

Kompakt element for filtrering eller valg.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsChip" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i chip-elementet. |
| selected | `bool` | `false` | Om elementet er valgt. |
| onSelected | `ValueChanged<bool>?` | `null` | Tilbakeringing ved valg/fravalg. |
| size | `DsSize?` | `null` | Størrelse på elementet. |
| color | `DsColor?` | `null` | Fargetema. |

## Eksempel

```dart
DsChip(
  selected: erValgt,
  onSelected: (valgt) => setState(() => erValgt = valgt),
  child: Text('Flutter'),
)
```

## Tilgjengelighet

- Har toggle-semantikk med valgt-tilstand.
