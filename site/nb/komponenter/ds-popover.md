# DsPopover

Innholdsboble som vises ved interaksjon med et utløserelement.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsPopover?
- Når du trenger å vise ekstra informasjon eller handlinger knyttet til et element.
- Når innholdet som skal vises er for komplekst for en tooltip (f.eks. inneholder lenker eller knapper).
- Når du ønsker kontekstuell informasjon uten å navigere brukeren bort fra siden.

### Når bør du unngå DsPopover?
- Når innholdet kun er en kort tekst uten interaktive elementer. Bruk heller `DsTooltip`.
- Når innholdet krever en fullstendig dialog med bekreftelse. Bruk heller en modal dialog.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsPopover/Standard" />

```dart
DsPopover(
  trigger: DsButton(
    variant: DsButtonVariant.tertiary,
    onPressed: () {},
    child: Text('Mer info'),
  ),
  content: DsParagraph(text: 'Detaljert informasjon her.'),
)
```

### Popover med interaktivt innhold

```dart
DsPopover(
  trigger: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () {},
    child: Text('Innstillinger'),
  ),
  content: Column(
    children: [
      DsButton(onPressed: () => redigerProfil(), child: Text('Rediger profil')),
      DsButton(onPressed: () => loggUt(), child: Text('Logg ut')),
    ],
  ),
)
```

## Retningslinjer
- Sørg for at popoveren ikke dekker det utløsende elementet.
- Hold innholdet i popoveren kort og fokusert på én oppgave.
- Popoveren bør lukkes automatisk når brukeren klikker utenfor.

## Tekst
- Bruk tydelig og konsist innhold inni popoveren.
- Dersom popoveren inneholder handlinger, bruk beskrivende knappetekster.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| trigger | Widget | påkrevd | Widgeten som åpner popoveren |
| content | Widget | påkrevd | Innholdet i popoveren |
| color | DsColor? | null | Fargetema for popoveren (overstyrer omkringliggende DsColorScope) |
| placement | DsPlacement | DsPlacement.top | Siden av utløseren popoveren forankres til |
| variant | DsPopoverVariant | DsPopoverVariant.default_ | Visuell variant; `tinted` bruker tonet flate |
| autoPlacement | bool | true | Snur popoveren til motsatt side hvis foretrukket plassering mangler plass |
| open | bool? | null | Kontrollert synlighet; foreldreelementet eier åpen-tilstand |
| onOpen | VoidCallback? | null | Kalles når popoveren vil åpnes |
| onClose | VoidCallback? | null | Kalles når popoveren vil lukkes |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Popoveren har en tilknyttet rolle som gjør at skjermlesere forstår at den er relatert til utløserelementet.
- Fokushåndtering sikrer at tastaturbrukere kan navigere innholdet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Enter / Space | Åpner popoveren fra utløserelementet |
| Escape | Lukker popoveren og returnerer fokus til utløserelementet |
| Tab | Navigerer mellom interaktive elementer inne i popoveren |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsPopover" />
