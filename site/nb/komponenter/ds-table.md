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
  columns: [
    DsTableColumn(header: Text('Navn')),
    DsTableColumn(header: Text('Status')),
  ],
  rows: [
    DsTableRow(cells: [Text('Prosjekt A'), DsTag(child: Text('Aktiv'), color: DsColor.success)]),
    DsTableRow(cells: [Text('Prosjekt B'), DsTag(child: Text('Fullført'), color: DsColor.info)]),
  ],
)
```

### Med størrelse

```dart
DsTable(
  size: DsSize.sm,
  columns: [
    DsTableColumn(header: Text('ID')),
    DsTableColumn(header: Text('Beskrivelse')),
    DsTableColumn(header: Text('Dato')),
  ],
  rows: [
    DsTableRow(cells: [Text('001'), Text('Første oppgave'), Text('2026-01-15')]),
    DsTableRow(cells: [Text('002'), Text('Andre oppgave'), Text('2026-02-20')]),
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
| columns | List\<DsTableColumn\> | påkrevd | Kolonnedefinisjonene med overskrifter |
| rows | List\<DsTableRow\> | påkrevd | Radene med celleinnhold |
| size | DsSize? | null | Størrelse på tabellen |

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
