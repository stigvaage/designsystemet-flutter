# DsParagraph

Brødtekst med varianter.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsParagraph?
- For all brødtekst og løpende tekst i grensesnittet.
- Når du trenger konsistent typografi med riktig linjehøyde og skriftstørrelse.
- For beskrivelser, instruksjoner og informasjonstekst.

### Når bør du unngå DsParagraph?
- For overskrifter — bruk DsHeading i stedet.
- For etiketter på skjemaelementer — bruk DsLabel i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Typografi/DsParagraph/Standard" />

```dart
DsParagraph(
  text: 'Dette er en avsnittstekst med standard linjehøyde.',
  bodySize: DsBodySize.md,
  variant: DsBodyVariant.standard,
)
```

### Liten variant

```dart
DsParagraph(
  text: 'Denne teksten er mindre og passer godt til hjelpetekst.',
  bodySize: DsBodySize.sm,
)
```

## Retningslinjer
- Bruk `bodySize` for å differensiere mellom primærtekst og sekundærtekst.
- Velg `variant` basert på kontekst — `standard` for vanlig tekst, andre varianter for spesialformål.
- Sørg for tilstrekkelig kontrast mellom tekst og bakgrunn.

## Tekst
- Skriv klart og konsist — unngå lange og kompliserte setninger.
- Bruk avsnitt for å dele opp lengre tekster og gjøre dem lettere å lese.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Avsnittsteksten. |
| bodySize | `DsBodySize` | `md` | Størrelse på brødteksten. |
| variant | `DsBodyVariant` | `standard` | Visuell variant av brødteksten. |
| size | `DsSize?` | `null` | Overordnet størrelse. |
| color | `DsColor?` | `null` | Fargetema for teksten. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig paragraph-semantikk slik at skjermlesere behandler teksten som et avsnitt.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsParagraph er ikke interaktiv og mottar ikke fokus. |

## Fokusindikator
- Ikke relevant — DsParagraph er et rent tekstelement uten interaksjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsParagraph" />
