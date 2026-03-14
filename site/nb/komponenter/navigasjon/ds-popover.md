# DsPopover

Innholdsboble som vises ved interaksjon.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsPopover" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| trigger | Widget | påkrevd | Widgeten som åpner popoveren |
| child | Widget | påkrevd | Innholdet i popoveren |
| size | DsSize? | null | Størrelse på popoveren |

## Eksempel

```dart
DsPopover(
  trigger: DsButton(
    variant: DsButtonVariant.tertiary,
    onPressed: () {},
    child: Text('Mer info'),
  ),
  child: DsParagraph(text: 'Detaljert informasjon her.'),
)
```

## Tilgjengelighet

- Escape-tasten lukker popoveren og returnerer fokus til utløserelementet.
- Fokushåndtering sikrer at tastaturbrukere kan navigere innholdet.
