# DsSkeleton

Plassholder for innhold som lastes.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Skjema og verktøy/DsSkeleton" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| width | `double?` | `null` | Bredde på plassholderen. |
| height | `double?` | `null` | Høyde på plassholderen. |
| borderRadius | `double?` | `null` | Hjørneradius på plassholderen. |

## Eksempel

```dart
Column(
  children: [
    DsSkeleton(width: 200, height: 24),
    SizedBox(height: 8),
    DsSkeleton(width: double.infinity, height: 16),
    SizedBox(height: 4),
    DsSkeleton(width: double.infinity, height: 16),
  ],
)
```

## Tilgjengelighet

- Respekterer redusert bevegelse.
- Markert som lasteinnhold.
