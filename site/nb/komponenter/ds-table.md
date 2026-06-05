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

### Med sorterbare kolonner og trykkbare rader

```dart
DsTable(
  columns: [Text('Navn'), Text('Alder')],
  rows: [
    [Text('Alice'), Text('30')],
    [Text('Bob'), Text('25')],
  ],
  sortColumn: 0,
  sortDirection: DsSortDirection.ascending,
  onSort: (kolonneIndeks) => sorter(kolonneIndeks),
  onRowTap: (radIndeks) => velgRad(radIndeks),
)
```

### Med festet overskriftsrad og bunntekst

Festet overskriftsrad krever en avgrenset høyde, for eksempel inne i en
`SizedBox` eller `Expanded`.

```dart
SizedBox(
  height: 240,
  child: DsTable(
    stickyHeader: true,
    caption: Text('Utgifter per måned'),
    columns: [Text('Måned'), Text('Beløp')],
    rows: [
      [Text('Januar'), Text('1 200')],
      [Text('Februar'), Text('980')],
    ],
    footerRows: [
      [Text('Sum'), Text('2 180')],
    ],
  ),
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
| stickyHeader | `bool` | `false` | Fester overskriftsraden ved rulling. Aktiv kun når tabellen har en avgrenset høyde (f.eks. i en `SizedBox`/`Expanded`); ellers vises tabellen uten rulling. |
| border | `bool` | `true` | Tegner den avrundede ytre kantlinjen |
| caption | `Widget?` | `null` | Tabelltekst vist over tabellen og eksponert for skjermlesere |
| footerRows | `List<List<Widget>>?` | `null` | Bunntekstrader med overskriftslignende stil |
| sortColumn | `int?` | `null` | Indeks for kolonnen som er sortert |
| sortDirection | `DsSortDirection?` | `null` | Sorteringsretning for `sortColumn` |
| onSort | `void Function(int)?` | `null` | Gjør kolonneoverskrifter til sorteringsknapper, kalles med kolonneindeks |
| onRowTap | `void Function(int)?` | `null` | Gjør rader trykkbare og aktiverbare med tastatur, kalles med radindeks |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig tabellsemantikk med header-celler slik at skjermlesere kan navigere og forstå datastrukturen.
- Kolonneoverskrifter er markert som header-celler (`th`) for riktig rad/kolonne-annonsering.
- Sorterbare kolonneoverskrifter (`onSort`) eksponeres som knapper med sorteringsretningen som tilstand (speiler `aria-sort`).
- Når `caption` er satt, grupperes tekst og tabell i én semantikknode slik at skjermlesere annonserer dem som én enhet (speiler HTML-elementet `<caption>`).

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til neste fokuserbare element i tabellen (f.eks. sorterbare overskrifter, trykkbare rader, lenker eller knapper i celler). |
| `Pil ned` / `Pil opp` | Navigerer mellom rader når tabellen har fokuserbare celler. |
| `Enter` / `Mellomrom` | Aktiverer den fokuserte sorterbare overskriften (`onSort`) eller den trykkbare raden (`onRowTap`). |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon for interaktive elementer i tabellcellene.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTable" />
