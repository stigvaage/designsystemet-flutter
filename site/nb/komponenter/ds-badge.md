# DsBadge

Merke for telling eller statusindikasjon.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsBadge?
- Til å vise antall uleste varsler, meldinger eller oppgaver.
- Til å indikere status på et element, for eksempel aktiv, inaktiv eller feil.
- Til å fremheve ny eller oppdatert informasjon i grensesnittet.

### Når bør du unngå DsBadge?
- Til lengre tekst eller beskrivelser. Bruk `DsTag` i stedet.
- Som en frittstående handlingsknapp. Bruk `DsButton` i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Kjernekomponenter/DsBadge/Standard" />

```dart
DsBadge(
  count: 5,
  color: DsColor.danger,
  child: Icon(Icons.notifications),
)
```

### Med plassering og maksverdi

```dart
DsBadge(
  count: 150,
  maxCount: 99,
  placement: DsBadgePlacement.topLeft,
  child: Icon(Icons.mail),
)
```

### Tonet variant

```dart
DsBadge(
  count: 3,
  variant: DsBadgeVariant.tinted,
  color: DsColor.info,
  child: Icon(Icons.notifications),
)
```

## Retningslinjer
- Hold innholdet i merket kort, helst et tall eller et enkelt ord.
- Bruk farger som samsvarer med betydningen: `danger` for feil, `info` for informasjon, `success` for suksess.
- Plasser merket konsekvent i forhold til foreldreelementet i hele applikasjonen.

## Tekst
- Bruk tall for tellinger (f.eks. «3», «99+»).
- Bruk korte statusord der det er nødvendig (f.eks. «Ny»).

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Foreldreelementet merket plasseres over. |
| count | `int?` | `null` | Tallet som vises i merket. Merket skjules når `null`. |
| maxCount | `int` | `99` | Maksverdi før «N+»-format brukes (f.eks. «99+»). |
| variant | `DsBadgeVariant` | `base` | Visuell variant: `base` (solid bakgrunn) eller `tinted` (tonet bakgrunn). |
| color | `DsColor?` | `null` | Fargetema. Standard er `danger`. |
| size | `DsSize?` | `null` | Størrelse på merket. |
| overlap | `bool` | `false` | Om merket overlapper kanten av foreldreelementet. |
| placement | `DsBadgePlacement` | `topRight` | Plassering av merket relativt til foreldreelementet. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Innholdet er tilgjengelig for skjermlesere.
- Merket annonseres som en del av foreldreelementet slik at konteksten bevares.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsBadge er ikke et interaktivt element og har ingen tastaturinteraksjon. |

## Fokusindikator
- DsBadge er ikke fokuserbar da det er et dekorativt/informativt element.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsBadge" />
