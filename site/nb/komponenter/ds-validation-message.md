# DsValidationMessage

Valideringsmelding for feilvisning under skjemaelementer.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsValidationMessage?
- For å vise feilmeldinger direkte under det aktuelle skjemafeltet etter validering.
- I kombinasjon med DsField for å koble feilmeldingen til riktig felt.
- Når brukeren trenger umiddelbar tilbakemelding om hva som er galt med et felt.

### Når bør du unngå DsValidationMessage?
- For å vise en samlet oversikt over alle feil — bruk DsErrorSummary i stedet.
- For generelle varsler eller informasjonsmeldinger som ikke er knyttet til skjemavalidering.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Typografi/DsValidationMessage/Standard" />

```dart
DsValidationMessage(text: 'Feltet er påkrevd')
```

### Med størrelse

```dart
DsValidationMessage(
  text: 'E-postadressen er ugyldig',
  size: DsSize.sm,
)
```

## Retningslinjer
- Plasser valideringsmeldingen direkte under det feltet den tilhører.
- Vis meldingen først etter at brukeren har forsøkt å sende inn skjemaet eller forlatt feltet.
- Bruk samme størrelse som det tilhørende skjemafeltet for visuell konsistens.

## Tekst
- Skriv konkrete og handlingsrettede feilmeldinger, f.eks. «Feltet er påkrevd» eller «E-postadressen er ugyldig».
- Unngå teknisk sjargong — brukeren skal forstå hva som er galt og hva de må gjøre.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Valideringsmeldingen som vises. |
| size | `DsSize?` | `null` | Størrelse på valideringsmeldingen. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Markert som feilmelding for skjermlesere slik at feilmeldingen annonseres automatisk.
- Kobles til feltet via DsField for programmatisk tilknytning.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsValidationMessage er ikke interaktiv — den vises som tekst knyttet til et skjemafelt. |

## Fokusindikator
- Ikke relevant — fokus gis til det tilknyttede skjemaelementet, ikke selve valideringsmeldingen.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsValidationMessage" />
