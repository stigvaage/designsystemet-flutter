# DsTable

Datatabell.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsTable?
- Til å presentere strukturerte data i rader og kolonner.
- Når brukeren trenger å sammenligne verdier på tvers av elementer.
- Til å vise lister med flere attributter per element (f.eks. navn, status, dato).

### Når bør du unngå DsTable?
- Til layoutformål. Bruk grid eller flex-layout i stedet.
- Når dataene er enkle nok til å vises som en liste.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsTable/Standard" />

```dart
DsTable(
  columns: [Text('Navn'), Text('Status')],
  rows: [
    [Text('Prosjekt A'), DsTag(child: Text('Aktiv'), color: DsColor.success)],
    [Text('Prosjekt B'), DsTag(child: Text('Fullført'), color: DsColor.info)],
  ],
)
```

### Med sebrastriper og musepeker-utheving

```dart
DsTable(
  zebra: true,
  hover: true,
  columns: [Text('ID'), Text('Beskrivelse'), Text('Dato')],
  rows: [
    [Text('001'), Text('Første oppgave'), Text('2026-01-15')],
    [Text('002'), Text('Andre oppgave'), Text('2026-02-20')],
    [Text('003'), Text('Tredje oppgave'), Text('2026-03-10')],
  ],
)
```

## Retningslinjer
- Bruk tydelige kolonneoverskrifter som beskriver innholdet i kolonnen.
- Juster tekst til venstre og tall til høyre for bedre lesbarhet.
- Hold tabellen enkel. Unngå for mange kolonner som gjør det vanskelig å lese.

## Tekst
- Kolonneoverskrifter bør være korte og beskrivende.
- Bruk konsekvent formatering av data i hver kolonne.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| columns | `List<Widget>` | påkrevd | Kolonneoverskrifter som widgets |
| rows | `List<List<Widget>>` | påkrevd | Radene med celleinnhold som widgets |
| size | `DsSize?` | `null` | Størrelse på tabellen |
| color | `DsColor?` | `null` | Fargetema |
| zebra | `bool` | `false` | Vekslende bakgrunnsfarge på annenhver rad |
| hover | `bool` | `false` | Utheving av rad ved musepeker |
| stickyHeader | `bool` | `false` | Om overskriftsraden skal festes ved rulling (ikke implementert ennå) |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig tabellsemantikk med header-celler slik at skjermlesere kan navigere og forstå datastrukturen.
- Kolonneoverskrifter er markert som header-celler (`th`) for riktig rad/kolonne-annonsering.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til neste fokuserbare element i tabellen (f.eks. lenker eller knapper i celler). |
| `Pil ned` / `Pil opp` | Navigerer mellom rader når tabellen har fokuserbare celler. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon for interaktive elementer i tabellcellene.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTable" />
