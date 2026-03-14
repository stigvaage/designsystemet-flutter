# DsField

Skjemafelt-wrapper som gir etikett, beskrivelse og feilmelding.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsField" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Inndatafeltet som pakkes inn. |
| label | `String?` | `null` | Etikett som vises over feltet. |
| description | `String?` | `null` | Hjelpetekst som vises under etiketten. |
| error | `String?` | `null` | Feilmelding som vises under feltet. |
| size | `DsSize?` | `null` | Størrelse på skjemafeltet. |

## Eksempel

```dart
DsField(
  label: 'E-postadresse',
  description: 'Vi sender bekreftelse til denne adressen.',
  error: epostFeil,
  child: DsTextfield(
    controller: epostController,
    error: epostFeil,
    keyboardType: TextInputType.emailAddress,
  ),
)
```

## Tilgjengelighet

- Kobler etikett og feilmelding til inndatafeltet via semantikk.
