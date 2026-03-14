# DsList

Liste med Designsystemet-styling.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsList" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| items | `List<Widget>` | påkrevd | Listeelementene som skal vises. |
| ordered | `bool` | `false` | Om listen er nummerert (ordnet). |
| size | `DsSize?` | `null` | Størrelse på listen. |

## Eksempel

```dart
DsList(
  ordered: true,
  items: [
    Text('Fyll ut søknadsskjema'),
    Text('Last opp dokumentasjon'),
    Text('Send inn søknaden'),
  ],
)
```

## Tilgjengelighet

- Bruker riktig list-semantikk (ordnet eller uordnet).
