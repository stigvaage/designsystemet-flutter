# DsDivider

Skillelinje.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsDivider?
- Til å visuelt separere innholdsseksjoner på en side.
- Til å skape tydeligere hierarki mellom grupper av relatert innhold.
- I lister eller kort for å skille elementer fra hverandre.

### Når bør du unngå DsDivider?
- Når tilstrekkelig avstand (whitespace) allerede skaper tydelig visuell separasjon.
- Som dekorasjon uten funksjonell hensikt. For mange skillelinjer skaper visuell støy.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Kjernekomponenter/DsDivider/Standard" />

```dart
DsDivider()
```

### Med farge

```dart
DsDivider(color: DsColor.neutral)
```

## Retningslinjer
- Bruk skillelinjer sparsomt. Foretrekk whitespace der det er mulig.
- Sørg for at skillelinjen strekker seg over hele bredden av innholdsområdet den separerer.
- Bruk konsekvent farge og tykkelse gjennom hele applikasjonen.

## Tekst
- DsDivider har ingen tekstinnhold.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| color | `DsColor?` | `null` | Fargetema. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har separator-semantikk slik at skjermlesere forstår at elementet fungerer som en visuell skillelinje mellom innholdsseksjoner.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsDivider er ikke et interaktivt element og har ingen tastaturinteraksjon. |

## Fokusindikator
- DsDivider er ikke fokuserbar da det er et dekorativt element.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsDivider" />
