# DsTextarea

Tekstområde for flerlinjes inndata.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsTextarea" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| controller | `TextEditingController?` | `null` | Kontroller for tekstområdet. |
| size | `DsSize?` | `null` | Størrelse på tekstområdet. |
| error | `String?` | `null` | Feilmelding som vises under feltet. |
| disabled | `bool` | `false` | Om tekstområdet er deaktivert. |
| readOnly | `bool` | `false` | Om tekstområdet er skrivebeskyttet. |
| maxLength | `int?` | `null` | Maksimalt antall tegn. |
| rows | `int` | `3` | Antall synlige rader. |
| onChanged | `ValueChanged<String>?` | `null` | Tilbakeringing ved tekstendring. |

## Eksempel

```dart
DsTextarea(
  controller: kommentarController,
  rows: 5,
  maxLength: 500,
)
```

## Tilgjengelighet

- Har `textField`-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
