# DsSkipLink

Hopp-til-innhold-lenke for tastaturnavigasjon og tilgjengelighet.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSkipLink?
- Plasser den øverst på hver side slik at tastaturbrukere kan hoppe direkte til hovedinnholdet.
- Når siden har en kompleks navigasjonsstruktur som er tidkrevende å tabulere gjennom.
- For å oppfylle WCAG 2.1 suksesskriterium 2.4.1 (Hopp over blokker).

### Når bør du unngå DsSkipLink?
- Når siden har svært lite navigasjon og innholdet er umiddelbart tilgjengelig.
- Ikke bruk den som en generell intern lenke — den er spesifikt designet for å hoppe over gjentakende innhold.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsSkipLink/Standard" />

```dart
final hovedinnholdFokus = FocusNode();

DsSkipLink(
  label: 'Hopp til hovedinnhold',
  onActivate: () => hovedinnholdFokus.requestFocus(),
)
```

### Hopp ved å rulle til målelementet

```dart
final hovedinnholdKey = GlobalKey();

DsSkipLink(
  label: 'Hopp til søkeresultater',
  onActivate: () => Scrollable.ensureVisible(
    hovedinnholdKey.currentContext!,
  ),
)
```

## Retningslinjer
- Plasser DsSkipLink som det første fokuserbare elementet i widgettreet.
- La `onActivate` flytte fokus til (eller rulle til) et element som finnes og kan motta fokus.
- Ha kun én DsSkipLink per side for å unngå forvirring.

## Tekst
- Bruk klart og konsist språk, f.eks. «Hopp til hovedinnhold».
- Unngå tekniske termer — brukeren skal umiddelbart forstå hva lenken gjør.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| label | `String` | påkrevd | Teksten som vises i lenken. |
| onActivate | `VoidCallback` | påkrevd | Kalles ved aktivering (Enter, Space eller trykk); flytter vanligvis fokus til hovedinnholdet. |
| color | `DsColor?` | `null` | Overstyrer fargen fra omkringliggende `DsColorScope`. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Synlig kun ved fokusering, slik at den ikke forstyrrer det visuelle oppsettet for musebrukere.
- Lar tastaturbrukere hoppe over gjentakende navigasjon og gå direkte til hovedinnholdet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Gir fokus til skip-lenken (første fokuserbare element). |
| Enter | Aktiverer lenken ved å kalle `onActivate`. |
| Space | Aktiverer lenken ved å kalle `onActivate`. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSkipLink" />
