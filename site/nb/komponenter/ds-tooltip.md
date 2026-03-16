# DsTooltip

Verktøyshjelp som vises ved hover eller fokus.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsTooltip?
- Når du trenger å gi tilleggsinformasjon om et element uten å ta opp plass i grensesnittet.
- Når ikoner eller knapper trenger en forklarende tekst for å bli forståelige.
- Når du ønsker å gi kontekst om et element uten at brukeren må klikke.

### Når bør du unngå DsTooltip?
- Når informasjonen er kritisk og alltid bør være synlig. Vis den heller direkte i grensesnittet.
- Når du trenger interaktivt innhold (lenker, knapper). Bruk heller `DsPopover`.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsTooltip/Standard" />

```dart
DsTooltip(
  message: 'Klikk for å laste ned rapporten',
  child: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () => lastNed(),
    child: Text('Last ned'),
  ),
)
```

### Tooltip på ikonknapp

```dart
DsTooltip(
  message: 'Slett element',
  child: DsButton(
    variant: DsButtonVariant.tertiary,
    onPressed: () => slettElement(),
    child: Icon(DsIcons.trash),
  ),
)
```

## Retningslinjer
- Hold hjelpeteksten kort og informativ, helst en enkelt setning.
- Ikke bruk tooltip for å gjenta informasjon som allerede er synlig.
- Plasser tooltip slik at den ikke dekker viktig innhold.

## Tekst
- Bruk kort og beskrivende tekst som gir nyttig tilleggsinformasjon.
- Unngå lengre avsnitt -- tooltip er ment for korte hint.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| message | String | påkrevd | Hjelpeteksten som vises |
| child | Widget | påkrevd | Widgeten som utløser verktøyshjelpen |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Tilgjengelig for tastaturbrukere via fokus, ikke bare hover.
- Bruker aria-describedby-lignende semantikk slik at skjermlesere leser hjelpeteksten.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til elementet som utløser tooltip |
| Escape | Skjuler tooltipet mens fokus beholdes |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTooltip" />
