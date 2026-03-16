# DsSpinner

Lastindikator.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSpinner?
- Når innhold lastes asynkront og brukeren trenger tilbakemelding om at noe skjer.
- Til å indikere pågående prosesser, for eksempel lagring eller sending av data.
- Som plassholder mens innhold hentes fra en server.

### Når bør du unngå DsSpinner?
- Når lasting tar svært kort tid (under 300 ms). Da kan indikatoren skape unødig visuell støy.
- Når du kan bruke skjelettkomponenter (skeleton screens) for å gi bedre kontekstuell tilbakemelding.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Kjernekomponenter/DsSpinner/Standard" />

```dart
DsSpinner(size: DsSize.md)
```

### Med farge

```dart
DsSpinner(
  size: DsSize.lg,
  color: DsColor.accent,
)
```

## Retningslinjer
- Bruk en størrelse som passer til konteksten: liten for inline-lasting, medium eller stor for fullside-lasting.
- Vis gjerne en forklarende tekst sammen med spinneren for å forklare hva som lastes.
- Unngå flere spinnere synlige samtidig.

## Tekst
- Legg til en hjelpetekst som «Laster inn...» i nærheten av spinneren der det er hensiktsmessig.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| size | `DsSize?` | `null` | Størrelse på lastindikatoren. |
| color | `DsColor?` | `null` | Fargetema. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har semantikk for lastetilstand slik at skjermlesere annonserer at innhold lastes.
- Respekterer redusert bevegelse (`prefers-reduced-motion`) og tilpasser animasjonen deretter.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsSpinner er ikke et interaktivt element og har ingen tastaturinteraksjon. |

## Fokusindikator
- DsSpinner er ikke fokuserbar da det er et informativt element.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSpinner" />
