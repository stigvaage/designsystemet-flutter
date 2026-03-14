# DsAlert

Varselboks med alvorlighetsgrader.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsAlert" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i varselboksen. |
| severity | `DsSeverity` | `info` | Alvorlighetsgrad (info, warning, danger, success). |
| title | `Widget?` | `null` | Valgfri tittel. |
| closable | `bool` | `false` | Om varselboksen kan lukkes. |
| onClose | `VoidCallback?` | `null` | Tilbakeringing når varselboksen lukkes. |
| color | `DsColor?` | `null` | Fargetema. |
| size | `DsSize?` | `null` | Størrelse på varselboksen. |

## Eksempel

```dart
DsAlert(
  severity: DsSeverity.warning,
  title: Text('Advarsel'),
  closable: true,
  onClose: () => skjul(),
  child: Text('Vær oppmerksom på dette.'),
)
```

## Tilgjengelighet

- Bruker riktig semantikk for alvorlighetsgrad.
- Lukkeknapp er fokuserbar med tastatur.
