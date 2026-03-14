# DsTooltip

Verktøyshjelp som vises ved hover eller fokus.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsTooltip" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| message | String | påkrevd | Hjelpeteksten som vises |
| child | Widget | påkrevd | Widgeten som utløser verktøyshjelpen |

## Eksempel

```dart
DsTooltip(
  message: 'Klikk for å laste ned rapporten',
  child: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () => lastNed(),
    child: Text('Last ned'),
  ),
)
```

## Tilgjengelighet

- Tilgjengelig for tastaturbrukere via fokus, ikke bare hover.
- Bruker aria-describedby-lignende semantikk slik at skjermlesere leser hjelpeteksten.
