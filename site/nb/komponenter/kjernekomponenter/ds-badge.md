# DsBadge

Merke for telling eller statusindikasjon.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsBadge" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i merket. |
| color | `DsColor?` | `null` | Fargetema. |
| size | `DsSize?` | `null` | Størrelse på merket. |
| placement | `DsBadgePlacement` | `topRight` | Plassering av merket relativt til foreldreelementet. |

## Eksempel

```dart
DsBadge(
  color: DsColor.danger,
  child: Text('5'),
)
```

## Tilgjengelighet

- Innholdet er tilgjengelig for skjermlesere.
