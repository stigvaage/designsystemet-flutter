# DsSuggestion

Forslagskomponent med autofullføringsforslag.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSuggestion?
- Når brukeren skal velge fra en lang liste med kjente verdier, f.eks. kommuner eller land.
- Når du ønsker å hjelpe brukeren med å fylle ut et felt raskere via autofullføring.
- Når du kombinerer fritekstinndata med forhåndsdefinerte valg.

### Når bør du unngå DsSuggestion?
- Når valgmulighetene er få (under 5). Bruk heller radioknapper eller en nedtrekksmeny.
- Når brukeren ikke skal kunne skrive fri tekst, men kun velge fra listen. Bruk heller en nedtrekksmeny.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsSuggestion/Standard" />

```dart
DsSuggestion(
  controller: kommuneController,
  suggestions: ['Oslo', 'Bergen', 'Trondheim', 'Stavanger'],
  onSelected: (kommune) => velgKommune(kommune),
)
```

### Med egendefinert størrelse

```dart
DsSuggestion(
  size: DsSize.lg,
  suggestions: ['Norge', 'Sverige', 'Danmark', 'Finland', 'Island'],
  onSelected: (land) => velgLand(land),
)
```

## Retningslinjer
- Sørg for at forslagslisten er sortert logisk, f.eks. alfabetisk eller etter relevans.
- Vis maksimalt 5-10 forslag om gangen for å unngå overveldende lister.
- Gi tydelig visuell tilbakemelding når et forslag er valgt.

## Tekst
- Forslagene bør være konsistente i format og lengde.
- Bruk fullstendige navn fremfor forkortelser i forslagslisten.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| controller | TextEditingController? | null | Kontroller for tekstfeltet |
| suggestions | List\<String\> | påkrevd | Liste over tilgjengelige forslag |
| onSelected | ValueChanged\<String\>? | null | Kalles når et forslag velges |
| size | DsSize? | null | Størrelse på forslagskomponenten |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har combobox-semantikk med forslagsliste slik at skjermlesere forstår komponentens rolle.
- Annonserer antall tilgjengelige forslag når listen oppdateres.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til forslagsfeltet |
| Pil ned | Åpner forslagslisten eller flytter til neste forslag |
| Pil opp | Flytter til forrige forslag i listen |
| Enter | Velger det markerte forslaget |
| Escape | Lukker forslagslisten uten å velge |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSuggestion" />
