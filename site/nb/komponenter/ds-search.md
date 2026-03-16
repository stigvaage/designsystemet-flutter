# DsSearch

Søkefelt som lar brukeren søke etter innhold.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSearch?
- Når brukeren trenger å finne spesifikt innhold i en stor informasjonsmengde.
- Når applikasjonen har en global søkefunksjon i toppmeny eller navigasjon.
- Når du ønsker å filtrere en liste eller et datasett basert på brukerens inndata.

### Når bør du unngå DsSearch?
- Når du trenger et vanlig tekstfelt uten søkefunksjonalitet. Bruk heller `DsTextfield`.
- Når du trenger autofullføring med forslag. Bruk heller `DsSuggestion`.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsSearch/Standard" />

```dart
DsSearch(
  placeholder: 'Søk...',
  onSubmitted: (søkeord) => utførSøk(søkeord),
)
```

### Med kontroller og endringshåndtering

```dart
DsSearch(
  controller: søkeController,
  placeholder: 'Søk etter produkter...',
  onChanged: (tekst) => filtrerResultater(tekst),
  onSubmitted: (søkeord) => utførSøk(søkeord),
)
```

## Retningslinjer
- Plasser søkefeltet på et godt synlig sted, gjerne i toppmeny eller header.
- Gi tydelig plassholdertekst som beskriver hva brukeren kan søke etter.
- Vis relevante resultater så raskt som mulig, gjerne med live-filtrering.

## Tekst
- Bruk beskrivende plassholdertekst, f.eks. «Søk etter kommuner...» i stedet for bare «Søk...».
- Hold plassholderteksten kort og presis.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| controller | TextEditingController? | null | Kontroller for tekstfeltet |
| onSubmitted | ValueChanged\<String\>? | null | Kalles når søk sendes inn |
| onChanged | ValueChanged\<String\>? | null | Kalles ved endring i søketeksten |
| placeholder | String? | null | Plassholdertekst i søkefeltet |
| size | DsSize? | null | Størrelse på søkefeltet |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har search-semantikk slik at skjermlesere identifiserer feltet som et søkefelt.
- Plassholdertekst fungerer som tilgjengelig ledetekst for søkefeltet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til søkefeltet |
| Enter | Sender inn søket |
| Escape | Tømmer søkefeltet |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSearch" />
