# DsBreadcrumbs

Brødsmulesti.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsBreadcrumbs" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| items | List\<DsBreadcrumbItem\> | påkrevd | Elementene i brødsmulestien |
| size | DsSize? | null | Størrelse på brødsmulestien |

## Eksempel

```dart
DsBreadcrumbs(
  items: [
    DsBreadcrumbItem(label: Text('Hjem'), onTap: () => gåTilHjem()),
    DsBreadcrumbItem(label: Text('Produkter'), onTap: () => gåTilProdukter()),
    DsBreadcrumbItem(label: Text('Detaljer')),
  ],
)
```

## Tilgjengelighet

- Har navigasjons-semantikk (`nav`) slik at skjermlesere identifiserer den som et navigasjonsområde.
- Gjeldende side er markert og mangler lenke for å indikere at det er siste element.
