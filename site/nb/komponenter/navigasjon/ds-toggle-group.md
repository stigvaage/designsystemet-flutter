# DsToggleGroup

Vekslegruppe for å velge mellom alternativer.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsToggleGroup" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| items | List\<DsToggleItem\> | påkrevd | Alternativene i vekslegruppen |
| value | dynamic | påkrevd | Den valgte verdien |
| onChanged | ValueChanged | påkrevd | Kalles når valgt alternativ endres |
| size | DsSize? | null | Størrelse på vekslegruppen |
| color | DsColor? | null | Farge på vekslegruppen |

## Eksempel

```dart
DsToggleGroup(
  items: [
    DsToggleItem(value: 'liste', child: Text('Liste')),
    DsToggleItem(value: 'rutenett', child: Text('Rutenett')),
    DsToggleItem(value: 'kart', child: Text('Kart')),
  ],
  value: visning,
  onChanged: (v) => setState(() => visning = v),
)
```

## Tilgjengelighet

- Implementerer roving focus med piltaster for navigasjon mellom alternativer.
