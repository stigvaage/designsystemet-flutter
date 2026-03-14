# DsCard

Kort med valgfrie underseksjoner.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsCard" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i kortet. |
| color | `DsColor?` | `null` | Fargetema. |
| elevated | `bool` | `false` | Om kortet har skygge. |
| onTap | `VoidCallback?` | `null` | Tilbakeringing ved trykk (gjør kortet klikkbart). |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

Relaterte komponenter: `DsCardHeader`, `DsCardBlock`, `DsCardFooter`.

## Eksempel

```dart
DsCard(
  elevated: true,
  onTap: () => naviger(),
  child: Column(
    children: [
      DsCardHeader(child: DsHeading(text: 'Tittel', level: DsHeadingLevel.sm)),
      DsCardBlock(child: DsParagraph(text: 'Kortinnhold her.')),
      DsCardFooter(child: DsButton(onPressed: () {}, child: Text('Les mer'))),
    ],
  ),
)
```

## Tilgjengelighet

- Klikkbare kort har button-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
