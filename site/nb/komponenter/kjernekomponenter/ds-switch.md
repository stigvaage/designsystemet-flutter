# DsSwitch

Av/på-bryter.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsSwitch" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| value | `bool` | påkrevd | Om bryteren er på. |
| onChanged | `ValueChanged<bool>?` | påkrevd | Tilbakeringing ved endring. |
| label | `Widget?` | `null` | Etikett som vises ved siden av bryteren. |
| size | `DsSize?` | `null` | Størrelse på bryteren. |
| color | `DsColor?` | `null` | Fargetema. |
| disabled | `bool` | `false` | Om bryteren er deaktivert. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Eksempel

```dart
DsSwitch(
  value: aktiv,
  onChanged: (verdi) => setState(() => aktiv = verdi),
  label: Text('Aktiver varsler'),
)
```

## Tilgjengelighet

- Har switch-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
