# DsRadio

Radioknapp for enkeltvalg i en gruppe med gjensidig utelukkende alternativer.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsRadio?
- Når brukeren skal velge nøyaktig ett alternativ fra en gruppe.
- Når alle alternativer bør være synlige samtidig.
- For korte lister med 2-7 alternativer.

### Når bør du unngå DsRadio?
- For flervalg — bruk `DsCheckbox` i stedet.
- For lange lister med mange alternativer — bruk en nedtrekksliste.
- For enkel av/på-funksjonalitet — bruk `DsSwitch`.

## Eksempler

### Grunnleggende radioknapp

<WidgetbookEmbed component="Kjernekomponenter/DsRadio/Standard" />

```dart
DsRadio(
  value: true,
  groupValue: valgtVerdi == 'alternativ1',
  onChanged: (_) => setState(() => valgtVerdi = 'alternativ1'),
  label: Text('Alternativ 1'),
)
```

### Radiogruppe

```dart
Column(
  children: [
    DsRadio(
      value: true,
      groupValue: valgt == 'a',
      onChanged: (_) => setState(() => valgt = 'a'),
      label: Text('Alternativ A'),
    ),
    DsRadio(
      value: true,
      groupValue: valgt == 'b',
      onChanged: (_) => setState(() => valgt = 'b'),
      label: Text('Alternativ B'),
    ),
    DsRadio(
      value: true,
      groupValue: valgt == 'c',
      onChanged: (_) => setState(() => valgt = 'c'),
      label: Text('Alternativ C'),
    ),
  ],
)
```

## Retningslinjer
- Grupper alltid radioknapper visuelt og semantisk.
- Ha alltid ett alternativ forhåndsvalgt der det gir mening.
- Unngå radioknapper for boolske valg — bruk `DsSwitch` eller `DsCheckbox` i stedet.

## Tekst
- Etiketter bør være korte og tydelige.
- Bruk parallell setningsstruktur for alle alternativer i en gruppe.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| value | `bool` | påkrevd | Verdien denne radioknappen representerer. |
| groupValue | `bool` | påkrevd | Den valgte verdien i gruppen. |
| onChanged | `ValueChanged<bool>?` | påkrevd | Tilbakeringing ved endring. |
| label | `Widget?` | `null` | Etikett som vises ved siden av knappen. |
| size | `DsSize?` | `null` | Størrelse på radioknappen. |
| color | `DsColor?` | `null` | Fargetema. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har `radio`-semantikk som gjenkjennes av skjermlesere.
- Skjermlesere annonserer valgt/ikke valgt tilstand.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `ArrowDown` / `ArrowRight` | Flytter fokus og valg til neste radioknapp i gruppen |
| `ArrowUp` / `ArrowLeft` | Flytter fokus og valg til forrige radioknapp i gruppen |
| `Tab` | Flytter fokus ut av radiogruppen til neste element |
| `Shift+Tab` | Flytter fokus til forrige element utenfor gruppen |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.
- Bruker roving focus — kun den valgte radioknappen er i Tab-rekkefølgen.

## Fargekontrast
- Valgt og ikke-valgt tilstand oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).

</template>
</ComponentTabs>

<ComponentFeedback component="DsRadio" />
