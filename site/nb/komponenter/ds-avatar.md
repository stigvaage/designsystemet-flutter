# DsAvatar

Avatarbilde eller initialer som representerer en bruker eller entitet.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsAvatar?
- Når du trenger å visuelt representere en bruker, f.eks. i en brukerprofil eller kommentarfelt.
- Når du viser en deltakerliste og trenger kompakte brukeridentifikasjoner.
- Når du ønsker å vise initialer som plassholder for brukere uten profilbilde.

### Når bør du unngå DsAvatar?
- Når du trenger å vise et vanlig bilde som ikke representerer en person. Bruk heller en standard `Image`-widget.
- Når du viser mange avatarer sammen. Bruk heller `DsAvatarStack`.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsAvatar/Standard" />

```dart
DsAvatar(
  name: 'Ola Nordmann',
  size: DsSize.md,
)
```

### Avatar med bilde

```dart
DsAvatar(
  name: 'Ola Nordmann',
  imageUrl: 'https://example.com/profil.jpg',
  size: DsSize.lg,
)
```

Bildet lastes asynkront. Initialer vises som plassholder under lasting og som fallback ved feil.

## Retningslinjer
- Bruk initialer med to bokstaver (fornavn + etternavn) som fallback når bilde mangler.
- Velg en passende størrelse basert på konteksten -- bruk `sm` i lister og `lg` i profiler.
- Bruk konsistente farger for å skille brukere visuelt.

## Tekst
- Initialer bør bruke store bokstaver og bestå av to tegn.
- Sørg for at initialene er gjenkjennbare for brukeren de representerer.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| name | `String?` | `null` | Navn som brukes til initialer og semantisk etikett |
| imageUrl | `String?` | `null` | URL til profilbilde. Viser initialer som fallback ved feil eller under lasting. |
| size | `DsSize?` | `null` | Størrelse på avataren (`sm` = 32, `md` = 40, `lg` = 48) |
| color | `DsColor?` | `null` | Fargetema for bakgrunn og ramme |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Dekorativt element med riktig semantikk slik at skjermlesere håndterer det korrekt.
- Avatarer med initialer gir tekstlig informasjon som kan leses av skjermlesere.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | Avataren er ikke interaktiv og mottar ikke fokuserbare hendelser |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsAvatar" />
