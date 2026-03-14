# DsSpinner

Lastindikator.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsSpinner" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| size | `DsSize?` | `null` | Størrelse på lastindikatoren. |
| color | `DsColor?` | `null` | Fargetema. |

## Eksempel

```dart
DsSpinner(size: DsSize.md)
```

## Tilgjengelighet

- Respekterer redusert bevegelse.
- Har semantikk for lastetilstand.
