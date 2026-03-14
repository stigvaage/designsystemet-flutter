# DsSelect

Velger med nedtrekksliste.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsSelect" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| label | String? | null | Ledetekst for velgeren |
| items | List\<DsSelectItem\> | påkrevd | Valgalternativene i listen |
| value | dynamic | null | Den valgte verdien |
| onChanged | ValueChanged? | påkrevd | Kalles når valgt verdi endres |
| size | DsSize? | null | Størrelse på velgeren |
| error | String? | null | Feilmelding som vises under velgeren |

## Eksempel

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

## Tilgjengelighet

- Har combobox-semantikk slik at skjermlesere forstår komponentens rolle.
- Støtter tastaturnavigasjon med piltaster for å bla gjennom alternativer.
