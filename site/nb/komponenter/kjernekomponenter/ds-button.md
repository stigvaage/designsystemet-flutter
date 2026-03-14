# DsButton

Knapp med tre varianter og støtte for ikon, lastetilstand og deaktivert tilstand.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsButton" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| onPressed | `VoidCallback?` | påkrevd | Tilbakeringing når knappen trykkes. |
| child | `Widget` | påkrevd | Innholdet i knappen. |
| variant | `DsButtonVariant` | `primary` | Visuell variant av knappen. |
| size | `DsSize?` | `null` | Størrelse på knappen. |
| color | `DsColor?` | `null` | Fargetema for knappen. |
| disabled | `bool` | `false` | Om knappen er deaktivert. |
| loading | `bool` | `false` | Om knappen viser lastetilstand. |
| icon | `Widget?` | `null` | Valgfritt ikon. |
| iconPosition | `DsIconPosition` | `left` | Plassering av ikonet. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Eksempel

```dart
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () => send(),
  icon: Icon(Icons.send),
  child: Text('Send inn'),
)
```

## Tilgjengelighet

- Har `button`-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
- Deaktiverte knapper markeres med `enabled: false`.
