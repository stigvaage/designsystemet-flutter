# DsDropdown

Nedtrekksmeny.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsDropdown" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| trigger | Widget | påkrevd | Widgeten som åpner nedtrekksmenyen |
| items | List\<DsDropdownItem\> | påkrevd | Elementene i nedtrekksmenyen |
| size | DsSize? | null | Størrelse på nedtrekksmenyen |

## Eksempel

```dart
DsDropdown(
  trigger: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () {},
    child: Text('Meny'),
  ),
  items: [
    DsDropdownItem(child: Text('Rediger'), onTap: () => rediger()),
    DsDropdownItem(child: Text('Slett'), onTap: () => slett()),
  ],
)
```

## Tilgjengelighet

- Tastaturnavigasjon med piltaster mellom menyalternativer.
- Escape-tasten lukker menyen og returnerer fokus til utløserknappen.
