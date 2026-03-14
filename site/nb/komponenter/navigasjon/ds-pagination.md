# DsPagination

Sidenavigasjon.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsPagination" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| currentPage | int | påkrevd | Gjeldende sidenummer |
| totalPages | int | påkrevd | Totalt antall sider |
| onPageChanged | ValueChanged\<int\> | påkrevd | Kalles når bruker navigerer til en annen side |
| size | DsSize? | null | Størrelse på pagineringskomponenten |

## Eksempel

```dart
DsPagination(
  currentPage: 3,
  totalPages: 10,
  onPageChanged: (side) => lastSide(side),
)
```

## Tilgjengelighet

- Navigasjonsknapper er fokuserbare og kan aktiveres med tastatur.
- Gjeldende side er tydelig markert visuelt og for skjermlesere.
