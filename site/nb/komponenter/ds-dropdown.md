# DsDropdown

Nedtrekksmeny.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsDropdown?
- Til å tilby en liste med handlinger knyttet til et element eller en kontekst.
- Til verktøylinjer eller navigasjon der plassen er begrenset.
- Til kontekstmenyer med relaterte handlinger.

### Når bør du unngå DsDropdown?
- Til å velge en verdi fra en liste. Bruk `DsSelect` i stedet.
- Når det kun er to handlinger. Vis dem direkte som knapper i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsDropdown/Standard" />

```dart
DsDropdown(
  trigger: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () {},
    child: Text('Meny'),
  ),
  items: [
    DsDropdownItem(child: Text('Rediger'), onTap: () => rediger()),
    DsDropdownItem(child: Text('Slett'), onTap: () => slett()),
  ],
)
```

### Med flere menyalternativer

```dart
DsDropdown(
  trigger: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () {},
    child: Text('Handlinger'),
  ),
  items: [
    DsDropdownItem(child: Text('Kopier'), onTap: () => kopier()),
    DsDropdownItem(child: Text('Flytt'), onTap: () => flytt()),
    DsDropdownItem(child: Text('Arkiver'), onTap: () => arkiver()),
    DsDropdownItem(child: Text('Slett'), onTap: () => slett()),
  ],
)
```

## Retningslinjer
- Sorter menyalternativene i en logisk rekkefølge, med de mest brukte øverst.
- Gruppér relaterte handlinger visuelt.
- Unngå for mange menyalternativer. Vurder å dele opp i undermenyer ved behov.

## Tekst
- Bruk korte, handlingsorienterte etiketter (f.eks. «Rediger», «Slett»).
- Start med verb for å gjøre handlingen tydelig.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| trigger | Widget | påkrevd | Widgeten som åpner nedtrekksmenyen |
| items | List\<DsDropdownItem\> | påkrevd | Elementene i nedtrekksmenyen |
| size | DsSize? | null | Størrelse på nedtrekksmenyen |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Utløserknappen har `haspopup`-semantikk slik at skjermlesere forstår at den åpner en meny.
- Menyalternativene annonseres med sin rolle og posisjon.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Enter` / `Mellomrom` | Åpner menyen fra utløserknappen, eller aktiverer valgt menyalternativ. |
| `Pil ned` | Flytter fokus til neste menyalternativ. |
| `Pil opp` | Flytter fokus til forrige menyalternativ. |
| `Home` | Flytter fokus til det første menyalternativet. |
| `End` | Flytter fokus til det siste menyalternativet. |
| `Escape` | Lukker menyen og returnerer fokus til utløserknappen. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsDropdown" />
