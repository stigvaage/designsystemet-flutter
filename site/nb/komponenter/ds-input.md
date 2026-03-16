# DsInput

Generisk inndatafelt (lavnivå-komponent).

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsInput?
- Når brukeren skal oppgi tekst, tall eller annen kort fritekst i et skjema.
- Når du bygger egendefinerte skjemakomponenter og trenger et lavnivå inndatafelt.
- I kombinasjon med DsLabel og DsValidationMessage for å lage fullstendige skjemafelt.

### Når bør du unngå DsInput?
- Når brukeren skal velge mellom forhåndsdefinerte alternativer — bruk DsSelect eller radioknapper i stedet.
- Når brukeren skal skrive lengre tekst — vurder et flerlinjet tekstfelt i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsInput/Standard" />

```dart
DsInput(
  controller: navnController,
  onChanged: (verdi) => print(verdi),
)
```

### Med feiltilstand

```dart
DsInput(
  controller: epostController,
  error: 'Ugyldig e-postadresse',
  onChanged: (verdi) => valider(verdi),
)
```

## Retningslinjer
- Bruk alltid en tilhørende DsLabel slik at brukeren vet hva feltet forventer.
- Vis tydelige feilmeldinger med `error`-egenskapen når validering feiler.
- Velg passende størrelse med `size` for å opprettholde konsistens i skjemaet.

## Tekst
- Hold plassholdertekst kort og beskrivende, f.eks. «Skriv inn navn».
- Unngå å bruke plassholdertekst som erstatning for en etikett.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| controller | `TextEditingController?` | `null` | Kontroller for inndatafeltet. |
| size | `DsSize?` | `null` | Størrelse på inndatafeltet. |
| error | `String?` | `null` | Feilmelding som aktiverer feiltilstand. |
| disabled | `bool` | `false` | Om inndatafeltet er deaktivert. |
| onChanged | `ValueChanged<String>?` | `null` | Tilbakeringing ved endring av verdi. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har textField-semantikk slik at skjermlesere annonserer feltet korrekt.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til inndatafeltet. |
| Shift + Tab | Flytter fokus til forrige element. |
| Bokstaver / tall | Skriver inn tekst i feltet. |
| Backspace | Sletter tegnet foran markøren. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsInput" />
