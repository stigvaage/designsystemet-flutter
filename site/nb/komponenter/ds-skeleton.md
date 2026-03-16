# DsSkeleton

Plassholder for innhold som lastes.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSkeleton?
- Når innhold hentes asynkront og du vil indikere at noe er på vei.
- For å gi brukeren en visuell indikasjon på sideoppsettet mens data lastes.
- Når du vil unngå sprangvis layoutendring (layout shift) ved lasting.

### Når bør du unngå DsSkeleton?
- Når innholdet lastes svært raskt (under 300 ms) — da kan skjelettet flimre og forstyrre.
- Når du har viktige statusmeldinger — bruk en spinner eller lasteindikator med tekst i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsSkeleton/Standard" />

```dart
Column(
  children: [
    DsSkeleton(width: 200, height: 24),
    SizedBox(height: 8),
    DsSkeleton(width: double.infinity, height: 16),
    SizedBox(height: 4),
    DsSkeleton(width: double.infinity, height: 16),
  ],
)
```

### Sirkulær plassholder

```dart
DsSkeleton(
  width: 48,
  height: 48,
  borderRadius: 24,
)
```

## Retningslinjer
- Etterlign layouten til det virkelige innholdet så nøyaktig som mulig.
- Unngå å bruke for mange skjelettkomponenter samtidig — det kan oppleves like forstyrrende som en tom side.
- Kombiner gjerne flere DsSkeleton-elementer for å representere overskrift, tekst og bilder.

## Tekst
- DsSkeleton har ingen tekstinnhold, men sørg for at området rundt gir kontekst om hva som lastes.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| width | `double?` | `null` | Bredde på plassholderen. |
| height | `double?` | `null` | Høyde på plassholderen. |
| borderRadius | `double?` | `null` | Hjørneradius på plassholderen. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Markert som lasteinnhold slik at skjermlesere kan informere brukeren om at innhold lastes.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Ingen | DsSkeleton er ikke interaktiv og mottar ikke fokus. |

## Fokusindikator
- Ikke relevant — DsSkeleton er en visuell plassholder uten interaksjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.
- Respekterer brukerens preferanse for redusert bevegelse (`prefers-reduced-motion`).

</template>
</ComponentTabs>

<ComponentFeedback component="DsSkeleton" />
