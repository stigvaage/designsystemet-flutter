# DsChip

Kompakt element for filtrering eller valg med veksle-funksjonalitet.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsChip?
- For filtrering av innhold, f.eks. å velge kategorier eller emner.
- For valgbare alternativer som kan kombineres fritt.
- For kompakte, interaktive merkelapper i verktøylinjer eller filterområder.

### Når bør du unngå DsChip?
- For rene visuelle merkelapper uten interaksjon — bruk `DsTag` i stedet.
- For enkeltvalg mellom gjensidig utelukkende alternativer — bruk `DsRadio`.
- For primærhandlinger — bruk `DsButton`.

## Eksempler

### Grunnleggende chip

<WidgetbookEmbed component="Kjernekomponenter/DsChip/Standard" />

```dart
DsChip(
  selected: erValgt,
  onSelected: (valgt) => setState(() => erValgt = valgt),
  child: Text('Flutter'),
)
```

### Filtergruppe

```dart
Wrap(
  spacing: 8,
  children: [
    DsChip(
      selected: filtre.contains('dart'),
      onSelected: (v) => oppdaterFilter('dart', v),
      child: Text('Dart'),
    ),
    DsChip(
      selected: filtre.contains('flutter'),
      onSelected: (v) => oppdaterFilter('flutter', v),
      child: Text('Flutter'),
    ),
    DsChip(
      selected: filtre.contains('web'),
      onSelected: (v) => oppdaterFilter('web', v),
      child: Text('Web'),
    ),
  ],
)
```

## Retningslinjer
- Grupper relaterte chips visuelt med jevn avstand.
- Bruk korte, beskrivende tekster i hver chip.
- Vis tydelig forskjell mellom valgt og ikke-valgt tilstand.

## Tekst
- Bruk korte, konsise tekster som «Dart», «Flutter», «Mobil».
- Unngå setninger eller lengre beskrivelser.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i chip-elementet. |
| selected | `bool` | `false` | Om elementet er valgt. |
| onSelected | `ValueChanged<bool>?` | `null` | Tilbakeringing ved valg/fravalg. |
| size | `DsSize?` | `null` | Størrelse på elementet. |
| color | `DsColor?` | `null` | Fargetema. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har toggle-semantikk med valgt-tilstand som gjenkjennes av skjermlesere.
- Skjermlesere annonserer valgt/ikke valgt tilstand.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Space` | Veksler valgt/ikke valgt |
| `Enter` | Veksler valgt/ikke valgt |
| `Tab` | Flytter fokus til neste element |
| `Shift+Tab` | Flytter fokus til forrige element |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Valgt og ikke-valgt tilstand oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Visuell forskjell mellom tilstander er tydelig uten å kun stole på farge.

</template>
</ComponentTabs>

<ComponentFeedback component="DsChip" />
