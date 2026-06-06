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

Hvert valg oppgis som en `DsSuggestionOption<T>` med en `value` (verdien som rapporteres tilbake) og en `label` (teksten som vises i listen). `onSelectedChanged` kalles med hele den valgte listen hver gang utvalget endres.

```dart
DsSuggestion<String>(
  options: const [
    DsSuggestionOption(value: 'oslo', label: 'Oslo'),
    DsSuggestionOption(value: 'bergen', label: 'Bergen'),
    DsSuggestionOption(value: 'trondheim', label: 'Trondheim'),
    DsSuggestionOption(value: 'stavanger', label: 'Stavanger'),
  ],
  onSelectedChanged: (valgte) => velgKommune(valgte),
)
```

### Flervalg med fjernbare brikker

Med `multiple: true` kan brukeren velge flere verdier, som vises som fjernbare brikker over feltet.

```dart
DsSuggestion<String>(
  multiple: true,
  options: const [
    DsSuggestionOption(value: 'norge', label: 'Norge'),
    DsSuggestionOption(value: 'sverige', label: 'Sverige'),
    DsSuggestionOption(value: 'danmark', label: 'Danmark'),
    DsSuggestionOption(value: 'finland', label: 'Finland'),
    DsSuggestionOption(value: 'island', label: 'Island'),
  ],
  onSelectedChanged: (valgte) => velgLand(valgte),
)
```

### Med mulighet for å opprette nye verdier

Med `creatable: true` (krever `onCreate`) får brukeren en «opprett»-rad når søket ikke har et eksakt treff. Bruk `createLabel` for å overstyre teksten på raden (standard er `Opprett "<søk>"`).

```dart
DsSuggestion<String>(
  creatable: true,
  onCreate: (sok) => sok,
  createLabel: (sok) => 'Legg til «$sok»',
  options: const [
    DsSuggestionOption(value: 'oslo', label: 'Oslo'),
    DsSuggestionOption(value: 'bergen', label: 'Bergen'),
  ],
  onSelectedChanged: (valgte) => velgKommune(valgte),
)
```

### Med egendefinert størrelse og tom-tilstand

```dart
DsSuggestion<String>(
  size: DsSize.lg,
  emptyText: 'Fant ingen kommuner',
  options: const [
    DsSuggestionOption(value: 'norge', label: 'Norge'),
    DsSuggestionOption(value: 'sverige', label: 'Sverige'),
  ],
  onSelectedChanged: (valgte) => velgLand(valgte),
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
| options | List\<DsSuggestionOption\<T>> | påkrevd | Liste over tilgjengelige valg |
| onSelectedChanged | ValueChanged\<List\<T>>? | null | Kalles med hele utvalget hver gang det endres |
| selected | List\<T>? | null | Kontrollert utvalg. Når null styrer komponenten sin egen tilstand |
| multiple | bool | false | Tillater å velge flere valg (vises som fjernbare brikker) |
| filter | bool | true | Filtrerer valgene etter søketeksten (uten å skille mellom store/små bokstaver) |
| creatable | bool | false | Viser en «opprett»-rad når søket ikke har et eksakt treff |
| onCreate | T Function(String)? | null | Bygger en ny verdi fra søketeksten. Påkrevd når `creatable` er true |
| createLabel | String Function(String)? | null | Overstyrer teksten på «opprett»-raden (standard: `Opprett "<søk>"`) |
| placeholder | String? | null | Plassholdertekst i tekstfeltet når ingenting er skrevet |
| emptyText | String | 'Ingen treff' | Tekst som vises når ingen valg matcher og ingenting kan opprettes |
| size | DsSize? | null | Størrelse på feltet; faller tilbake til omsluttende `DsSize` når null |
| color | DsColor? | null | Fargevariant på feltet; faller tilbake til omsluttende `DsColor` når null |
| focusNode | FocusNode? | null | Ekstern fokusnode for tekstfeltet. Når null oppretter og eier komponenten sin egen |

`DsSuggestionOption<T>` har `value` (verdien som rapporteres gjennom `onSelectedChanged`) og `label` (teksten som vises i listen).

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har combobox-semantikk: feltet annonseres som et redigerbart tekstfelt, og «utvidet»-tilstanden settes når forslagslisten er åpen.
- Forslagslisten grupperes som én beholder slik at valgene annonseres som en liste.
- Tom-tilstanden («Ingen treff») annonseres som et live-område når den vises.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til forslagsfeltet. Når fokus forlater feltet, lukkes forslagslisten |
| Pil ned | Åpner forslagslisten eller flytter til neste forslag |
| Pil opp | Flytter til forrige forslag i listen |
| Enter | Velger det markerte forslaget |
| Escape | Lukker forslagslisten uten å velge |
| Backspace | Fjerner den sist valgte brikken når feltet er tomt (kun ved flervalg) |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Redusert bevegelse
- Rulling av det markerte forslaget inn i synsfeltet respekterer systeminnstillingen for redusert bevegelse (`MediaQuery.disableAnimations`).

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSuggestion" />
