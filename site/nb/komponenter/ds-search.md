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

### Med tøm-knapp

Sett `clearable: true` for å vise en tøm-knapp som suffiks når feltet har
tekst. Tøm-knappen kan nås med Tab og aktiveres med Enter eller Mellomrom.
Når `clearable` er `true` er standard plassholder tom, i tråd med offisiell
anbefaling — oppgi en egen `placeholder` om du vil ha ledetekst.

```dart
DsSearch(
  controller: søkeController,
  clearable: true,
  placeholder: 'Søk etter kommuner...',
  onChanged: (tekst) => filtrerResultater(tekst),
  onClear: () => filtrerResultater(''),
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
| onChanged | ValueChanged\<String\>? | null | Kalles ved endring i søketeksten |
| onSubmitted | ValueChanged\<String\>? | null | Kalles når søk sendes inn |
| onSubmit | ValueChanged\<String\>? | null | Alias for `onSubmitted` (React-navngivning). Kalles etter `onSubmitted` |
| placeholder | String? | null | Plassholdertekst. Standard er «Søk...», men tom når `clearable` er `true` |
| size | DsSize? | null | Størrelse på søkefeltet |
| focusNode | FocusNode? | null | Eksternt fokusobjekt for feltet |
| clearable | bool | false | Viser en tøm-knapp som suffiks når feltet har tekst |
| onClear | VoidCallback? | null | Kalles etter at feltet er tømt via tøm-knappen |
| clearLabel | String | «Tøm» | Tilgjengelig ledetekst for tøm-knappen |
| error | String? | null | Feilmelding som aktiverer feiltilstand |
| disabled | bool | false | Deaktiverer feltet (kan ikke fokuseres eller redigeres) |
| readOnly | bool | false | Gjør innholdet skrivebeskyttet, men fortsatt fokuserbart |
| autofocus | bool | false | Gir feltet fokus automatisk ved første visning |
| keyboardType | TextInputType? | null | Tastaturtype for myktastatur |
| textInputAction | TextInputAction? | null | Handlingen som handlingstasten representerer |
| inputFormatters | List\<TextInputFormatter\>? | null | Inndatafiltere som transformerer eller begrenser teksten |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har search-semantikk slik at skjermlesere identifiserer feltet som et søkefelt.
- Plassholdertekst fungerer som tilgjengelig ledetekst for søkefeltet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til søkefeltet, og videre til tøm-knappen når den vises |
| Enter | Sender inn søket (fra feltet), eller tømmer feltet når tøm-knappen har fokus |
| Mellomrom | Tømmer feltet når tøm-knappen har fokus |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSearch" />
