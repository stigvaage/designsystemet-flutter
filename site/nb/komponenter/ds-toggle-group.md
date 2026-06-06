# DsToggleGroup

Vekslegruppe for å velge mellom alternativer.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsToggleGroup?
- Når brukeren skal velge mellom et lite antall gjensidig utelukkende alternativer (2-5 valg).
- Når valgene påvirker visningen umiddelbart, f.eks. bytte mellom liste- og rutenettvisning.
- Når du trenger et kompakt alternativ til radioknapper for enkel veksling.

### Når bør du unngå DsToggleGroup?
- Når det er mange alternativer (mer enn 5). Bruk heller en nedtrekksmeny.
- Når valgene ikke er gjensidig utelukkende. Bruk heller avkrysningsbokser.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsToggleGroup/Standard" />

```dart
DsToggleGroup(
  items: const ['Liste', 'Rutenett', 'Kart'],
  selectedIndex: visning,
  onChanged: (i) => setState(() => visning = i),
)
```

### Med egendefinert farge og størrelse

```dart
DsToggleGroup(
  size: DsSize.sm,
  color: DsColor.accent,
  items: const ['Dag', 'Uke', 'Måned'],
  selectedIndex: tidsperiode,
  onChanged: (i) => setState(() => tidsperiode = i),
)
```

## Retningslinjer
- Bruk korte og tydelige etiketter for hvert alternativ.
- Sørg for at det alltid er et valgt alternativ -- gruppen skal ikke ha en tom tilstand.
- Begrens antall alternativer til 2-5 for best brukervennlighet.

## Tekst
- Bruk konsistente og korte etiketter, helst ett til to ord per alternativ.
- Etikettene bør klart beskrive hva hvert alternativ gjør.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| items | List\<String\> | påkrevd | Etikettene til alternativene, i rekkefølge |
| selectedIndex | int | påkrevd | Indeksen til det valgte alternativet |
| onChanged | ValueChanged\<int\> | påkrevd | Kalles med den nye indeksen når valgt alternativ endres. Kalles ikke på nytt for alternativet som allerede er valgt |
| size | DsSize? | null | Størrelse på vekslegruppen |
| color | DsColor? | null | Farge på vekslegruppen |
| variant | DsToggleGroupVariant | primary | Visuell vekt på det valgte alternativet (primary/secondary) |
| focusNode | FocusNode? | null | Valgfri fokusnode for det første alternativet |
| disabled | bool | false | Deaktiverer hele gruppen |
| disabledIndices | Set\<int\>? | null | Indeksene til enkeltalternativer som er deaktivert |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Implementerer roving focus med piltaster for navigasjon mellom alternativer.
- Hvert alternativ har riktig rolle og tilstand som kommuniserer om det er valgt.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til vekslegruppen (det valgte elementet) |
| Pil venstre / Pil opp | Flytter fokus og velger forrige alternativ |
| Pil høyre / Pil ned | Flytter fokus og velger neste alternativ |
| Home | Flytter fokus til og velger det første alternativet |
| End | Flytter fokus til og velger det siste alternativet |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsToggleGroup" />
