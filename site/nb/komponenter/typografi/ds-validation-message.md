# DsValidationMessage

Valideringsmelding for feilvisning under skjemaelementer.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Typografi/DsValidationMessage" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Valideringsmeldingen som vises. |
| size | `DsSize?` | `null` | Størrelse på valideringsmeldingen. |

## Eksempel

```dart
DsValidationMessage(text: 'Feltet er påkrevd')
```

## Tilgjengelighet

- Markert som feilmelding for skjermlesere.
- Kobles til feltet via DsField.
