# DsInput

Generisk inndatafelt (lavnivå-komponent).

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsInput" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| controller | `TextEditingController?` | `null` | Kontroller for inndatafeltet. |
| size | `DsSize?` | `null` | Størrelse på inndatafeltet. |
| error | `String?` | `null` | Feilmelding som aktiverer feiltilstand. |
| disabled | `bool` | `false` | Om inndatafeltet er deaktivert. |
| onChanged | `ValueChanged<String>?` | `null` | Tilbakeringing ved endring av verdi. |

## Eksempel

```dart
DsInput(
  controller: navnController,
  onChanged: (verdi) => print(verdi),
)
```

## Tilgjengelighet

- Har textField-semantikk.
