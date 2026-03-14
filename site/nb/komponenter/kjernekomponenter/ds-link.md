# DsLink

Lenke med Designsystemet-styling.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsLink" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Lenketeksten. |
| onTap | `VoidCallback?` | påkrevd | Tilbakeringing ved trykk. |
| size | `DsSize?` | `null` | Størrelse på lenken. |
| color | `DsColor?` | `null` | Fargetema. |

## Eksempel

```dart
DsLink(
  text: 'Gå til designsystemet.no',
  onTap: () => åpneLenke('https://designsystemet.no'),
)
```

## Tilgjengelighet

- Har link-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
