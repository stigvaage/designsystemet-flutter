# DsPagination

Sidenavigasjon.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsPagination?
- Til å dele opp store datasett eller lange lister over flere sider.
- Når brukeren trenger kontroll over hvilken del av innholdet som vises.
- I tabeller, søkeresultater eller listevisninger med mange elementer.

### Når bør du unngå DsPagination?
- Når det er færre elementer enn en enkelt side. Vis alt innholdet direkte.
- Når uendelig scrolling gir en bedre brukeropplevelse, for eksempel i sosiale feeder.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsPagination/Standard" />

```dart
DsPagination(
  currentPage: 3,
  totalPages: 10,
  onPageChanged: (side) => lastSide(side),
)
```

### Med størrelse

```dart
DsPagination(
  currentPage: 1,
  totalPages: 5,
  size: DsSize.sm,
  onPageChanged: (side) => lastSide(side),
)
```

## Retningslinjer
- Vis tydelig hvilken side brukeren er på.
- Plasser pagineringskomponenten konsekvent, vanligvis under innholdet den kontrollerer.
- Vis totalt antall sider eller resultater når det er hensiktsmessig.

## Tekst
- Knappetekster bør være tydelige: «Forrige» og «Neste» eller pil-ikoner.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| currentPage | int | påkrevd | Gjeldende sidenummer |
| totalPages | int | påkrevd | Totalt antall sider |
| onPageChanged | ValueChanged\<int\> | påkrevd | Kalles når bruker navigerer til en annen side |
| size | DsSize? | null | Størrelse på pagineringskomponenten |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Navigasjonsknapper er fokuserbare og kan aktiveres med tastatur.
- Gjeldende side er tydelig markert visuelt og annonseres med `aria-current` for skjermlesere.
- Komponenten bruker `nav`-semantikk for å indikere navigasjonsområdet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus mellom pagineringsknappene. |
| `Enter` / `Mellomrom` | Aktiverer den fokuserte sideknappen og navigerer til den siden. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsPagination" />
