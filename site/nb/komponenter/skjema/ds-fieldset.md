# DsFieldset

Gruppering av relaterte skjemaelementer med legend.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsFieldset" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| legend | `String` | påkrevd | Overskrift for gruppen av skjemaelementer. |
| children | `List<Widget>` | påkrevd | Skjemaelementene som grupperes. |
| size | `DsSize?` | `null` | Størrelse på feltsettet. |

## Eksempel

```dart
DsFieldset(
  legend: 'Adresse',
  children: [
    DsField(label: 'Gate', child: DsTextfield(controller: gateController)),
    DsField(label: 'Postnummer', child: DsTextfield(controller: postnummerController)),
    DsField(label: 'Sted', child: DsTextfield(controller: stedController)),
  ],
)
```

## Tilgjengelighet

- Har fieldset/legend-semantikk for gruppering.
