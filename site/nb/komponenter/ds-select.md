# DsSelect

Velger med nedtrekksliste.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSelect?
- Når brukeren skal velge ett alternativ fra en forhåndsdefinert liste.
- Når listen inneholder mer enn 5 alternativer, slik at radioknapper ville ta for mye plass.
- I skjemaer der valg blant standardiserte verdier er nødvendig (f.eks. fylke, land).

### Når bør du unngå DsSelect?
- Når det er færre enn 4 alternativer. Bruk radioknapper i stedet for bedre oversikt.
- Når brukeren skal kunne skrive inn egne verdier. Bruk et tekstfelt med autofullfør i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsSelect/Standard" />

```dart
DsSelect<String>(
  options: const [
    DsSelectOption(value: 'oslo', label: 'Oslo'),
    DsSelectOption(value: 'vestland', label: 'Vestland'),
    DsSelectOption(value: 'trondelag', label: 'Trøndelag'),
  ],
  value: valgtFylke,
  placeholder: 'Velg fylke',
  onChanged: (verdi) => setState(() => valgtFylke = verdi),
)
```

### Med feilmelding

```dart
DsSelect<String>(
  options: const [
    DsSelectOption(value: 'administrator', label: 'Administrator'),
    DsSelectOption(value: 'bruker', label: 'Bruker'),
    DsSelectOption(value: 'gjest', label: 'Gjest'),
  ],
  value: null,
  placeholder: 'Velg rolle',
  error: 'Du må velge en rolle.',
  onChanged: (verdi) => setState(() => valgtRolle = verdi),
)
```

### Med grupperte alternativer

```dart
DsSelect<String>(
  options: const [],
  groups: const [
    DsSelectOptgroup(
      label: 'Norge',
      options: [
        DsSelectOption(value: 'oslo', label: 'Oslo'),
        DsSelectOption(value: 'bergen', label: 'Bergen'),
      ],
    ),
  ],
  value: valgtBy,
  placeholder: 'Velg by',
  onChanged: (verdi) => setState(() => valgtBy = verdi),
)
```

## Retningslinjer
- Beskriv alltid hva brukeren skal velge, enten via `placeholder` eller en synlig ledetekst over velgeren, og sett `semanticsLabel` slik at skjermlesere annonserer feltet.
- Sorter alternativene i en logisk rekkefølge (f.eks. alfabetisk eller etter relevans).
- `error` markerer feiltilstanden med rød kantlinje, men viser ingen feiltekst. Vis en egen, synlig feilmelding under velgeren når valideringen feiler.

## Tekst
- Plassholderteksten bør være kort og beskrivende (f.eks. «Velg fylke»).
- Alternativtekstene (`label`) bør være fullstendige og entydige.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| options | `List<DsSelectOption<T>>` | påkrevd | Valgalternativene i listen |
| groups | `List<DsSelectOptgroup<T>>?` | `null` | Grupperte alternativer med egen overskrift |
| value | `T?` | `null` | Valgt verdi (`null` viser plassholderen) |
| onChanged | `ValueChanged<T?>?` | `null` | Kalles med valgt verdi når valget endres |
| placeholder | `String?` | `null` | Plassholdertekst når ingen verdi er valgt |
| size | `DsSize?` | `null` | Størrelse på velgeren |
| color | `DsColor?` | `null` | Fargetema |
| error | `String?` | `null` | Når satt, gjør velgerens kantlinje rød (feiltilstand) |
| disabled | `bool` | `false` | Om velgeren er deaktivert (dimmet) |
| readOnly | `bool` | `false` | Om velgeren er skrivebeskyttet (synlig men ikke redigerbar) |
| focusNode | `FocusNode?` | `null` | Egendefinert fokusnode for velgeren |
| semanticsLabel | `String` | `'Velg'` | Tilgjengelighetsetikett som annonseres for velgeren |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Velgeren annonseres som en knapp med `semanticsLabel` som etikett, valgt verdi som verdi, og åpen/lukket-tilstand (`expanded`).
- Nedtrekkslisten har listerolle, og hvert alternativ inngår i en gjensidig utelukkende gruppe slik at skjermlesere forstår at bare ett valg er aktivt om gangen.
- `error` markeres kun visuelt med rød kantlinje. Knytt en egen, synlig feilmelding til velgeren når valideringen feiler.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til velgeren. |
| `Enter` / `Mellomrom` | Åpner nedtrekkslisten. |
| `Pil ned` | Flytter fokus til neste alternativ i listen. |
| `Pil opp` | Flytter fokus til forrige alternativ i listen. |
| `Enter` | Velger det fokuserte alternativet og lukker listen. |
| `Escape` | Lukker nedtrekkslisten uten å endre valg. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSelect" />
