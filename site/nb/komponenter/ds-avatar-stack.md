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
  avatars: [
    DsAvatar(child: Text('AB')),
    DsAvatar(child: Text('CD')),
    DsAvatar(child: Text('EF')),
    DsAvatar(child: Text('GH')),
    DsAvatar(child: Text('IJ')),
  ],
)
```

### Kompakt visning

```dart
DsAvatarStack(
  maxVisible: 3,
  size: DsSize.sm,
  avatars: [
    DsAvatar(child: Text('AB')),
    DsAvatar(child: Text('CD')),
    DsAvatar(child: Text('EF')),
    DsAvatar(child: Text('GH')),
  ],
)
```

## Retningslinjer
- Sett `maxVisible` til et rimelig antall basert på tilgjengelig plass, typisk 3-5.
- Bruk konsistent størrelse på alle avatarer i stakken.
- Overflow-indikatoren viser automatisk antall skjulte avatarer.

## Tekst
- Overflow-indikatoren bør vise et tall som representerer antall skjulte brukere, f.eks. «+3».
- Vurder å legge til en tooltip som lister navnene på skjulte brukere.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| avatars | List\<DsAvatar\> | påkrevd | Liste over avatarer som skal vises |
| maxVisible | int | 3 | Maks antall synlige avatarer |
| size | DsSize? | null | Størrelse på avatarene |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
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
