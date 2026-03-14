# DsSkipLink

Hopp-til-innhold-lenke for tastaturnavigasjon og tilgjengelighet.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsSkipLink" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| label | `String` | påkrevd | Teksten som vises i lenken. |
| targetId | `String` | påkrevd | ID-en til målelementet det hoppes til. |

## Eksempel

```dart
DsSkipLink(
  label: 'Hopp til hovedinnhold',
  targetId: 'hovedinnhold',
)
```

## Tilgjengelighet

- Synlig kun ved fokusering.
- Lar tastaturbrukere hoppe over navigasjon.
