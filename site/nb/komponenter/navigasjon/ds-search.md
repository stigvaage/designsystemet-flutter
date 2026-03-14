# DsSearch

Søkefelt.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsSearch" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| controller | TextEditingController? | null | Kontroller for tekstfeltet |
| onSubmitted | ValueChanged\<String\>? | null | Kalles når søk sendes inn |
| onChanged | ValueChanged\<String\>? | null | Kalles ved endring i søketeksten |
| placeholder | String? | null | Plassholdertekst i søkefeltet |
| size | DsSize? | null | Størrelse på søkefeltet |

## Eksempel

```dart
DsSearch(
  placeholder: 'Søk...',
  onSubmitted: (søkeord) => utførSøk(søkeord),
)
```

## Tilgjengelighet

- Har search-semantikk slik at skjermlesere identifiserer feltet som et søkefelt.
- Synlig fokusindikator ved tastaturnavigasjon.
