# DsSuggestion

Forslagskomponent med autofullføringsforslag.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsSuggestion" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| controller | TextEditingController? | null | Kontroller for tekstfeltet |
| suggestions | List\<String\> | påkrevd | Liste over tilgjengelige forslag |
| onSelected | ValueChanged\<String\>? | null | Kalles når et forslag velges |
| size | DsSize? | null | Størrelse på forslagskomponenten |

## Eksempel

```dart
DsSuggestion(
  controller: kommuneController,
  suggestions: ['Oslo', 'Bergen', 'Trondheim', 'Stavanger'],
  onSelected: (kommune) => velgKommune(kommune),
)
```

## Tilgjengelighet

- Har combobox-semantikk med forslagsliste slik at skjermlesere forstår komponentens rolle.
- Støtter tastaturnavigasjon med piltaster for å bla gjennom forslag.
