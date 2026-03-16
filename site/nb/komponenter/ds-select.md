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
DsSelect(
  label: 'Velg fylke',
  items: [
    DsSelectItem(value: 'oslo', label: 'Oslo'),
    DsSelectItem(value: 'bergen', label: 'Vestland'),
    DsSelectItem(value: 'trondheim', label: 'Trøndelag'),
  ],
  value: valgtFylke,
  onChanged: (verdi) => setState(() => valgtFylke = verdi),
)
```

### Med feilmelding

```dart
DsSelect(
  label: 'Velg rolle',
  items: [
    DsSelectItem(value: 'admin', label: 'Administrator'),
    DsSelectItem(value: 'bruker', label: 'Bruker'),
    DsSelectItem(value: 'gjest', label: 'Gjest'),
  ],
  value: null,
  error: 'Du må velge en rolle.',
  onChanged: (verdi) => setState(() => valgtRolle = verdi),
)
```

## Retningslinjer
- Bruk alltid en ledetekst (`label`) for å forklare hva brukeren skal velge.
- Sorter alternativene i en logisk rekkefølge (f.eks. alfabetisk eller etter relevans).
- Vis en tydelig feilmelding under velgeren når valideringen feiler.

## Tekst
- Ledeteksten bør være kort og beskrivende (f.eks. «Velg fylke»).
- Alternativtekstene bør være fullstendige og entydige.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| label | String? | null | Ledetekst for velgeren |
| items | List\<DsSelectItem\> | påkrevd | Valgalternativene i listen |
| value | dynamic | null | Den valgte verdien |
| onChanged | ValueChanged? | påkrevd | Kalles når valgt verdi endres |
| size | DsSize? | null | Størrelse på velgeren |
| error | String? | null | Feilmelding som vises under velgeren |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har combobox-semantikk slik at skjermlesere forstår komponentens rolle.
- Ledeteksten er programmatisk knyttet til velgeren.
- Feilmeldinger annonseres til skjermlesere.

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
