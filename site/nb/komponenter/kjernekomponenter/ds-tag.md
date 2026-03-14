# DsTag

Etikett for kategorisering.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsTag" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i etiketten. |
| size | `DsSize?` | `null` | Størrelse på etiketten. |
| color | `DsColor?` | `null` | Fargetema. |

## Eksempel

```dart
DsTag(
  color: DsColor.success,
  size: DsSize.sm,
  child: Text('Godkjent'),
)
```

## Tilgjengelighet

- Bruker riktig tekst-semantikk.
