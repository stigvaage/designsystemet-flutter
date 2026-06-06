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
    DsDropdownItem(label: 'Rediger', onTap: () => rediger()),
    DsDropdownItem(label: 'Slett', onTap: () => slett()),
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
    DsDropdownItem(label: 'Kopier', onTap: () => kopier()),
    DsDropdownItem(label: 'Flytt', onTap: () => flytt()),
    DsDropdownItem(label: 'Arkiver', onTap: () => arkiver()),
    DsDropdownItem(label: 'Slett', onTap: () => slett()),
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

### DsDropdown

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| trigger | Widget | påkrevd | Widgeten som åpner nedtrekksmenyen |
| items | List\<DsDropdownItem\> | påkrevd | Elementene i nedtrekksmenyen |
| onSelected | ValueChanged\<int\>? | null | Kalles med indeksen til det valgte elementet |
| size | DsSize? | null | Størrelse på menyelementene. Faller tilbake til `DsSizeScope` |
| color | DsColor? | null | Fargerolle for menyflate og tekst. Faller tilbake til `DsColorScope` |
| focusNode | FocusNode? | null | Ekstern fokusnode for utløseren |

### DsDropdownItem

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| label | String | påkrevd | Teksten som vises for elementet |
| enabled | bool | true | Når `false` er elementet nedtonet og kan ikke velges |
| onTap | VoidCallback? | null | Kalles når elementet velges. Kjøres sammen med `onSelected` |
| value | T? | null | En valgfri verdi knyttet til elementet, til konsumentens bruk |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Utløseren har knapperolle med utvidet-tilstand (`expanded`) som speiler om menyen er åpen, slik at skjermlesere forstår at den åpner en meny.
- Menyflaten har rollen `menu`, og hvert menyalternativ har rollen `menuItem` med riktig etikett og aktivert-tilstand.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Enter` / `Mellomrom` | Åpner menyen fra utløserknappen, eller aktiverer valgt menyalternativ. |
| `Pil ned` | Åpner menyen og flytter merkingen til neste menyalternativ. |
| `Pil opp` | Åpner menyen på siste menyalternativ, eller flytter merkingen til forrige. |
| `Escape` | Lukker menyen og returnerer fokus til utløserknappen. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsDropdown" />
