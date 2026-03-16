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
  size: DsSize.md,
  child: Text('ON'),
)
```

### Avatar med bilde

```dart
DsAvatar(
  size: DsSize.lg,
  child: Image.network('https://example.com/profil.jpg'),
)
```

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
| child | Widget | påkrevd | Innholdet i avataren (bilde eller tekst) |
| size | DsSize? | null | Størrelse på avataren |
| color | DsColor? | null | Bakgrunnsfarge på avataren |

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
