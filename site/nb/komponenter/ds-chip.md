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

## Navngitte konstruktører

`DsChip` speiler delene fra React-utgaven av Designsystemet og tilbyr fire navngitte konstruktører:

- `DsChip.button` — klikkbar handlingschip (`Chip.Button`). Kaller `onTap`.
- `DsChip.removable` — chip med fjern-ikon (`Chip.Removable`). Krever `onRemove`.
- `DsChip.checkbox` — vekslbar flervalgschip (`Chip.Checkbox`). Krever `selected` og `onChanged` av typen `ValueChanged<bool>`.
- `DsChip.radio` — enkeltvalgschip (`Chip.Radio`). Krever `selected` og `onChanged` av typen `VoidCallback`.

Standardkonstruktøren `DsChip(...)` lager en generisk chip og styres med `onTap`.

## Eksempler

### Grunnleggende chip

<WidgetbookEmbed component="Kjernekomponenter/DsChip/Standard" />

```dart
DsChip.checkbox(
  selected: erValgt,
  onChanged: (valgt) => setState(() => erValgt = valgt),
  child: Text('Flutter'),
)
```

### Filtergruppe

```dart
Wrap(
  spacing: 8,
  children: [
    DsChip.checkbox(
      selected: filtre.contains('dart'),
      onChanged: (v) => oppdaterFilter('dart', v),
      child: Text('Dart'),
    ),
    DsChip.checkbox(
      selected: filtre.contains('flutter'),
      onChanged: (v) => oppdaterFilter('flutter', v),
      child: Text('Flutter'),
    ),
    DsChip.checkbox(
      selected: filtre.contains('web'),
      onChanged: (v) => oppdaterFilter('web', v),
      child: Text('Web'),
    ),
  ],
)
```

### Fjernbar chip

```dart
DsChip.removable(
  onRemove: () => fjernEmne('flutter'),
  child: Text('Flutter'),
)
```

### Enkeltvalg (radio)

```dart
DsChip.radio(
  selected: valgtSpråk == 'nynorsk',
  onChanged: () => setState(() => valgtSpråk = 'nynorsk'),
  child: Text('Nynorsk'),
)
```

### Handlingschip

```dart
DsChip.button(
  onTap: () => utførHandling(),
  child: Text('Legg til'),
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
| selected | `bool` | `false` | Om elementet er valgt/aktivt. |
| onTap | `VoidCallback?` | `null` | Kalles når selve chipen aktiveres (trykk, Enter eller Space). |
| onRemove | `VoidCallback?` | `null` | Kalles når fjern-ikonet aktiveres (eller Delete trykkes). |
| removable | `bool` | `false` | Om chipen viser et fjern-ikon. Krever `onRemove`. |
| disabled | `bool` | `false` | Om chipen er deaktivert (nedtonet, ingen interaksjon). |
| size | `DsSize?` | `null` | Størrelse på elementet. |
| color | `DsColor?` | `null` | Fargetema. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for chip-kroppen. |

For de navngitte konstruktørene `DsChip.checkbox` og `DsChip.radio` styres valget i stedet med `onChanged` (`ValueChanged<bool>` for checkbox, `VoidCallback` for radio).

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
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
