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
  items: [
    DsBreadcrumbItem(label: Text('Hjem'), onTap: () => gåTilHjem()),
    DsBreadcrumbItem(label: Text('Produkter'), onTap: () => gåTilProdukter()),
    DsBreadcrumbItem(label: Text('Detaljer')),
  ],
)
```

### Med egendefinert størrelse

```dart
DsBreadcrumbs(
  size: DsSize.sm,
  items: [
    DsBreadcrumbItem(label: Text('Hjem'), onTap: () => gåTilHjem()),
    DsBreadcrumbItem(label: Text('Innstillinger')),
  ],
)
```

## Retningslinjer
- Siste element i brødsmulestien skal representere gjeldende side og skal ikke ha lenke.
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
| items | List\<DsBreadcrumbItem\> | påkrevd | Elementene i brødsmulestien |
| size | DsSize? | null | Størrelse på brødsmulestien |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har navigasjons-semantikk (`nav`) slik at skjermlesere identifiserer den som et navigasjonsområde.
- Gjeldende side er markert og mangler lenke for å indikere at det er siste element.

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
