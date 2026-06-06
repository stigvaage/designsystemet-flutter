# DsAvatarStack

Stablet gruppe av avatarer som viser flere brukere kompakt.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsAvatarStack?
- Når du viser en gruppe deltakere eller brukere, f.eks. på et prosjekt eller i en samtale.
- Når plassen er begrenset og du trenger å vise mange brukere kompakt.
- Når du ønsker å vise antall deltakere med en overflow-indikator for skjulte avatarer.

### Når bør du unngå DsAvatarStack?
- Når du kun viser én bruker. Bruk heller `DsAvatar` alene.
- Når det er viktig å vise detaljert informasjon om hver bruker. Bruk heller en liste med navn og avatarer.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsAvatarStack/Standard" />

```dart
DsAvatarStack(
  maxVisible: 4,
  children: [
    DsAvatar(name: 'Ada Berg'),
    DsAvatar(name: 'Carl Dahl'),
    DsAvatar(name: 'Eva Foss'),
    DsAvatar(name: 'Geir Hansen'),
    DsAvatar(name: 'Ida Johnsen'),
  ],
)
```

### Med overflow-indikator

Når antallet `children` overstiger den effektive grensen (`max` hvis satt, ellers
`maxVisible`), samles de overskytende avatarene i en «+N»-indikator. Ingen avatarer
forsvinner uten at antallet vises.

```dart
DsAvatarStack(
  max: 3,
  children: [
    DsAvatar(name: 'Ada Berg'),
    DsAvatar(name: 'Carl Dahl'),
    DsAvatar(name: 'Eva Foss'),
    DsAvatar(name: 'Geir Hansen'),
    DsAvatar(name: 'Ida Johnsen'),
  ],
)
// Viser 3 avatarer etterfulgt av «+2».
```

### Kompakt visning

```dart
DsAvatarStack(
  maxVisible: 3,
  size: DsSize.sm,
  children: [
    DsAvatar(name: 'Ada Berg'),
    DsAvatar(name: 'Carl Dahl'),
    DsAvatar(name: 'Eva Foss'),
    DsAvatar(name: 'Geir Hansen'),
  ],
)
```

## Retningslinjer
- Sett `maxVisible` (eller `max`) til et rimelig antall basert på tilgjengelig plass, typisk 3-5.
- Bruk konsistent størrelse på alle avatarer i stakken.
- Når antallet `children` overstiger den effektive grensen, viser overflow-indikatoren automatisk antall skjulte avatarer som «+N».

## Tekst
- Overflow-indikatoren bør vise et tall som representerer antall skjulte brukere, f.eks. «+3».
- Vurder å legge til en tooltip som lister navnene på skjulte brukere.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| children | List\<Widget\> | påkrevd | Liste over avatarer som skal vises |
| maxVisible | int | 5 | Standard grense for synlige avatarer når `max` ikke er satt. Overskytende avatarer samles i en «+N»-indikator |
| max | int? | null | Eksplisitt overstyring av maks antall synlige avatarer før «+N»-indikatoren vises. Har forrang foran `maxVisible` |
| overlap | double | 8 | Antall piksler hver avatar overlapper den forrige |
| size | DsSize? | null | Størrelse på avatarene |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Viser antall skjulte avatarer for skjermlesere slik at all informasjon er tilgjengelig.
- Gruppen har semantikk som kommuniserer at den inneholder en samling brukerrepresentasjoner.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | Avatargruppen er ikke interaktiv og mottar ikke fokuserbare hendelser |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsAvatarStack" />
