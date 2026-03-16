# DsHeading

Overskrift med 7 nivåer.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsHeading?
- For alle overskrifter i grensesnittet, fra sidetitler til seksjonsoverskrifter.
- Når du trenger konsistent typografi som følger designsystemets skala.
- For å skape visuelt hierarki som reflekterer innholdsstrukturen.

### Når bør du unngå DsHeading?
- For brødtekst eller beskrivelser — bruk DsParagraph i stedet.
- For korte merkelapper på skjemaelementer — bruk DsLabel i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Typografi/DsHeading/Standard" />

```dart
DsHeading(text: 'Velkommen til tjenesten', level: DsHeadingLevel.xl)
```

### Mindre overskrift med farge

```dart
DsHeading(
  text: 'Seksjonstittel',
  level: DsHeadingLevel.sm,
  color: DsColor.accent,
)
```

## Retningslinjer
- Bruk overskriftsnivåer i logisk rekkefølge — ikke hopp over nivåer.
- Bruk `level` for semantisk nivå og `size` kun for visuell justering der det er nødvendig.
- Ha kun én xl-overskrift (sidetittel) per side.

## Tekst
- Hold overskrifter korte og beskrivende.
- Unngå å avslutte overskrifter med punktum.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Overskriftsteksten. |
| level | `DsHeadingLevel` | `md` | Nivå på overskriften. |
| size | `DsSize?` | `null` | Størrelse på overskriften. |
| color | `DsColor?` | `null` | Fargetema for overskriften. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig heading-semantikk slik at skjermlesere annonserer overskriftsnivået.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| H (i skjermleser) | Navigerer til neste overskrift. |
| Shift + H (i skjermleser) | Navigerer til forrige overskrift. |
| 1-6 (i skjermleser) | Navigerer til overskrift med angitt nivå. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsHeading" />
