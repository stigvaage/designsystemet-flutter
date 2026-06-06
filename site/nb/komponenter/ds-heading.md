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
DsHeading(
  text: 'Velkommen til tjenesten',
  level: DsHeadingLevel.xl,
  semanticLevel: 1,
)
```

### Mindre overskrift med farge

```dart
DsHeading(
  text: 'Seksjonstittel',
  level: DsHeadingLevel.sm,
  semanticLevel: 2,
  color: DsColor.accent,
)
```

## Størrelser

Skriftstørrelsene følger offisiell Designsystemet v1.15.0 (px ved referansestørrelse). Alle nivåer har vekt 500 (medium) og linjehøyde 1.3.

| Nivå | Enum | Størrelse |
| --- | --- | --- |
| Ekstra ekstra stor | `DsHeadingLevel.xxl` | 60px |
| Ekstra stor | `DsHeadingLevel.xl` | 48px |
| Stor | `DsHeadingLevel.lg` | 36px |
| Medium | `DsHeadingLevel.md` | 30px |
| Liten | `DsHeadingLevel.sm` | 24px |
| Ekstra liten | `DsHeadingLevel.xs` | 21px |
| Ekstra ekstra liten | `DsHeadingLevel.xxs` | 18px |

## Retningslinjer
- Bruk overskriftsnivåer i logisk rekkefølge — ikke hopp over nivåer.
- Bruk `semanticLevel` (1–6) for det semantiske overskriftsnivået og `level` for den visuelle størrelsen. De settes uavhengig av hverandre.
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
| level | `DsHeadingLevel` | `md` | Visuell størrelse på overskriften (tilsvarer `data-size`). |
| semanticLevel | `int` | `2` | Semantisk overskriftsnivå (1–6) som annonseres til skjermlesere. |
| color | `DsColor?` | `null` | Fargetema for overskriften. |
| textAlign | `TextAlign?` | `null` | Justering av overskriftsteksten. |
| maxLines | `int?` | `null` | Maksimalt antall linjer før avkutting. |
| overflow | `TextOverflow?` | `null` | Hvordan overflødig tekst håndteres. |

## Import

```dart
import 'package:designsystemet_flutter/typography.dart';
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
