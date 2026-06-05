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
DsValidationMessage(message: 'Feltet er påkrevd')
```

### Alvorlighetsgrad

```dart
DsValidationMessage(
  message: 'E-postadressen er ugyldig',
  severity: DsSeverity.danger,
)

DsValidationMessage(
  message: 'Feltet er gyldig',
  severity: DsSeverity.success,
)
```

## Retningslinjer
- Plasser valideringsmeldingen direkte under det feltet den tilhører.
- Vis meldingen først etter at brukeren har forsøkt å sende inn skjemaet eller forlatt feltet.
- Bruk `severity` for å skille mellom feil (danger), advarsel (warning), informasjon (info) og suksess (success).

## Tekst
- Skriv konkrete og handlingsrettede feilmeldinger, f.eks. «Feltet er påkrevd» eller «E-postadressen er ugyldig».
- Unngå teknisk sjargong — brukeren skal forstå hva som er galt og hva de må gjøre.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| message | `String` | påkrevd | Valideringsmeldingen som vises. |
| severity | `DsSeverity?` | `null` (effektivt `danger`) | Alvorlighetsgrad som styrer farge og ikon (danger/warning/info/success). |
| isError | `bool` | `true` | Eldre API for bakoverkompatibilitet — foretrekk `severity`. `true` tilsvarer `danger`, `false` tilsvarer `success`. Brukes kun når `severity` er `null`. |

## Import

```dart
import 'package:designsystemet_flutter/typography.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Feil- og advarselsmeldinger (`danger`/`warning`) pakkes i et `Semantics`-liveRegion slik at skjermlesere annonserer dem automatisk når de dukker opp.
- Suksess- og informasjonsmeldinger (`success`/`info`) annonseres ikke automatisk, slik at de ikke avbryter skjermleseren.
- Et alvorlighetsikon vises foran teksten i samme farge som meldingen.
- Når komponenten brukes inni `DsField`, kobles meldingen til feltet via feltets semantikk (`hint`).

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
