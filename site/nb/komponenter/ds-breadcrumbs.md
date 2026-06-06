# DsBreadcrumbs

Brødsmulesti som viser brukerens plassering i navigasjonshierarkiet.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsBreadcrumbs?
- Når applikasjonen har et dypt navigasjonshierarki og brukeren trenger å orientere seg.
- Når brukeren skal kunne navigere raskt tilbake til overordnede sider.
- I kombinasjon med sidetittel for å gi full kontekst om brukerens plassering.

### Når bør du unngå DsBreadcrumbs?
- Når navigasjonshierarkiet er flatt (kun ett nivå). Bruk heller vanlig tilbakeknapp.
- Når innholdet ikke har en logisk hierarkisk struktur.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsBreadcrumbs/Standard" />

```dart
DsBreadcrumbs(
  items: const ['Hjem', 'Produkter', 'Detaljer'],
  onItemTap: (index) {
    if (index == 0) gåTilHjem();
    if (index == 1) gåTilProdukter();
  },
)
```

Det siste elementet representerer automatisk gjeldende side og trenger derfor
ingen egen håndtering.

### Med egendefinert farge

```dart
DsBreadcrumbs(
  items: const ['Hjem', 'Innstillinger'],
  color: DsColor.brand1,
  onItemTap: (index) {
    if (index == 0) gåTilHjem();
  },
)
```

## Retningslinjer
- Siste element i brødsmulestien skal representere gjeldende side.
- Hold etikettene korte og konsise, bruk samme tittel som siden de peker til.
- Inkluder alltid startsiden (f.eks. «Hjem») som første element.

## Tekst
- Bruk korte og beskrivende etiketter som samsvarer med sidens tittel.
- Unngå forkortelser med mindre de er godt kjente.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| items | List\<String\> | påkrevd | Etikettene i brødsmulestien (siste element er gjeldende side) |
| onItemTap | ValueChanged\<int\>? | null | Kalles med indeksen når en lenke aktiveres |
| color | DsColor? | null | Fargetema; arver fra DsColorScope hvis utelatt |
| ariaLabel | String | 'Du er her:' | Tilgjengelig etikett for navigasjonslandemerket |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har navigasjons-semantikk (`nav`) slik at skjermlesere identifiserer den som et navigasjonsområde.
- Gjeldende side er kodet som en lenke med `aria-current="page"` (siste element), slik at den fortsatt er fokuserbar selv om den vises uten understreking.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til neste lenkeelement i brødsmulestien |
| Shift + Tab | Flytter fokus til forrige lenkeelement |
| Enter | Aktiverer den fokuserte lenken og navigerer til tilhørende side |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsBreadcrumbs" />
