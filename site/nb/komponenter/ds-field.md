# DsField

Skjemafelt-wrapper som gir etikett, beskrivelse og feilmelding til et inndatafelt.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsField?
- Når du pakker inn et inndatafelt og trenger etikett, hjelpetekst eller feilmelding.
- Når du bygger skjemaer og ønsker konsistent layout og tilgjengelighetsstøtte for alle felt.
- Når du trenger automatisk kobling mellom etikett og inndatafelt for skjermlesere.

### Når bør du unngå DsField?
- Når du grupperer flere relaterte felt sammen. Bruk heller `DsFieldset` rundt gruppen.
- Når inndatafeltet ikke trenger etikett eller feilmelding, f.eks. et frittstående søkefelt.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsField/Standard" />

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

### Felt uten feilmelding

```dart
DsField(
  label: 'Fullt navn',
  description: 'Fornavn og etternavn.',
  child: DsTextfield(
    controller: navnController,
  ),
)
```

## Retningslinjer
- Bruk alltid en tydelig etikett som beskriver hva feltet forventer.
- Legg til beskrivelse for å gi ekstra kontekst der det er nødvendig.
- Vis feilmeldinger direkte under feltet, og gjør dem spesifikke og handlingsrettede.

## Tekst
- Etiketter bør være korte og beskrivende, f.eks. «E-postadresse» i stedet for «Skriv inn din e-post».
- Feilmeldinger bør forklare hva som er galt og hva brukeren kan gjøre, f.eks. «Ugyldig e-postadresse. Sjekk at du har skrevet riktig.»

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Inndatafeltet som pakkes inn. |
| label | `String?` | `null` | Etikett som vises over feltet. |
| description | `String?` | `null` | Hjelpetekst som vises under etiketten. |
| error | `String?` | `null` | Feilmelding som vises under feltet. |
| size | `DsSize?` | `null` | Størrelse på skjemafeltet. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Etiketten eksponeres programmatisk som inndatafeltets tilgjengelige navn, slik at skjermlesere leser den opp når feltet får fokus.
- Beskrivelse og feilmelding eksponeres som feltets hint, slik at de leses opp sammen med feltet.
- Feilmeldingen vises i en live-region, slik at skjermlesere annonserer den automatisk når feltet går fra gyldig til ugyldig.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til inndatafeltet inne i DsField |
| Shift + Tab | Flytter fokus tilbake til forrige fokuserbare element |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsField" />
