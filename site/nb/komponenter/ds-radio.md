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
  value: valgtVerdi == 'alternativ1',
  onChanged: (_) => setState(() => valgtVerdi = 'alternativ1'),
  label: const Text('Alternativ 1'),
)
```

`value` er en `bool` som angir om denne radioknappen er valgt. Du styrer
gruppen ved å sammenligne en delt tilstand mot hvert alternativ. `onChanged`
kalles kun når knappen blir valgt (aldri med `false`), så bruk `(_) => ...`.

### Radiogruppe

```dart
Column(
  children: [
    DsRadio(
      value: valgt == 'a',
      onChanged: (_) => setState(() => valgt = 'a'),
      label: const Text('Alternativ A'),
    ),
    DsRadio(
      value: valgt == 'b',
      onChanged: (_) => setState(() => valgt = 'b'),
      label: const Text('Alternativ B'),
    ),
    DsRadio(
      value: valgt == 'c',
      onChanged: (_) => setState(() => valgt = 'c'),
      label: const Text('Alternativ C'),
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
| value | `bool` | påkrevd | Om denne radioknappen er valgt i gruppen. |
| onChanged | `ValueChanged<bool>?` | påkrevd | Kalles når knappen blir valgt. Aldri kalt med `false` (valg er idempotent). `null` gjør kontrollen ikke-interaktiv. |
| label | `Widget?` | `null` | Etikett som vises ved siden av knappen. |
| description | `Widget?` | `null` | Hjelpetekst som vises under etiketten. |
| size | `DsSize?` | `null` | Størrelse på radioknappen. Faller tilbake til `DsSizeScope`. |
| color | `DsColor?` | `null` | Fargetema for valgt tilstand. Faller tilbake til `DsColorScope`. |
| error | `String?` | `null` | Feilmelding som vises under kontrollen. |
| disabled | `bool` | `false` | Om knappen er deaktivert og dempet. |
| readOnly | `bool` | `false` | Om knappen er skrivebeskyttet (full opasitet, ingen interaksjon). |
| autofocus | `bool` | `false` | Om knappen ber om fokus når den bygges. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |
| variant | `DsSelectionVariant` | `DsSelectionVariant.default_` | Visuell variant. `outline` legger kontrollen i en kantlinjeboks. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
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
