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
  color: DsColor.danger,
  child: Text('5'),
)
```

### Med plassering

```dart
DsBadge(
  color: DsColor.info,
  placement: DsBadgePlacement.topLeft,
  child: Text('Ny'),
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
| child | `Widget` | påkrevd | Innholdet i merket. |
| color | `DsColor?` | `null` | Fargetema. |
| size | `DsSize?` | `null` | Størrelse på merket. |
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
