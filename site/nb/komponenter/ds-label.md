# DsLabel

Etikett for skjemaelementer.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsLabel?
- For å merke skjemaelementer slik at brukeren vet hva som forventes i hvert felt.
- I kombinasjon med DsInput, DsSelect og andre skjemakomponenter.
- Når du bygger egendefinerte skjemafelt og trenger en tilgjengelig etikett.

### Når bør du unngå DsLabel?
- For overskrifter — bruk DsHeading i stedet.
- For hjelpetekst eller beskrivelser under et felt — bruk DsParagraph eller en dedikert hjelpetekst-komponent.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Typografi/DsLabel/Standard" />

```dart
DsLabel(text: 'Fornavn')
```

### Med farge og størrelse

```dart
DsLabel(
  text: 'E-postadresse',
  size: DsSize.lg,
  color: DsColor.accent,
)
```

## Retningslinjer
- Plasser etiketten visuelt over eller ved siden av det tilhørende skjemafeltet.
- Bruk alltid en etikett for hvert skjemaelement — aldri stol kun på plassholdertekst.
- Hold etiketteksten kort og presis.

## Tekst
- Bruk substantiv eller kort frase, f.eks. «Fornavn», «E-postadresse».
- Unngå kolon etter etiketten — designsystemet håndterer visuell separasjon.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Etiketteksten. |
| size | `DsSize?` | `null` | Størrelse på etiketten. |
| color | `DsColor?` | `null` | Fargetema for etiketten. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Kobles til tilhørende skjemaelement via semantikk slik at skjermlesere leser etiketten når feltet får fokus.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsLabel er ikke direkte interaktiv — fokus flyttes til det tilhørende skjemaelementet. |

## Fokusindikator
- Ikke relevant — fokus gis til det tilknyttede skjemaelementet, ikke selve etiketten.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsLabel" />
