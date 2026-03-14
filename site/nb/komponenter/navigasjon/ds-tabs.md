# DsTabs

Fanenavigasjon med tastaturstøtte og roving focus.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsTabs" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| tabs | List\<DsTab\> | påkrevd | Liste over faner med innhold |
| initialIndex | int | 0 | Indeksen til den først valgte fanen |
| onChanged | ValueChanged\<int\>? | null | Kalles når valgt fane endres |
| size | DsSize? | null | Størrelse på fanekomponenten |

## Eksempel

```dart
DsTabs(
  tabs: [
    DsTab(label: Text('Oversikt'), child: OversiktInnhold()),
    DsTab(label: Text('Innstillinger'), child: InnstillingerInnhold()),
  ],
  onChanged: (indeks) => print('Fane $indeks valgt'),
)
```

## Tilgjengelighet

- Implementerer roving focus med piltaster for navigasjon mellom faner.
- Bruker riktig tab-semantikk (`tablist`, `tab`, `tabpanel`) slik at skjermlesere kan identifisere komponentens rolle.
