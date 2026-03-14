# DsTable

Datatabell.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsTable" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| columns | List\<DsTableColumn\> | påkrevd | Kolonnedefinisjonene med overskrifter |
| rows | List\<DsTableRow\> | påkrevd | Radene med celleinnhold |
| size | DsSize? | null | Størrelse på tabellen |

## Eksempel

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

## Tilgjengelighet

- Bruker riktig tabellsemantikk med header-celler slik at skjermlesere kan navigere og forstå datastrukturen.
