# DsRadio

Radioknapp for enkeltvalg i gruppe.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsRadio" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| value | `bool` | påkrevd | Verdien denne radioknappen representerer. |
| groupValue | `bool` | påkrevd | Den valgte verdien i gruppen. |
| onChanged | `ValueChanged<bool>?` | påkrevd | Tilbakeringing ved endring. |
| label | `Widget?` | `null` | Etikett som vises ved siden av knappen. |
| size | `DsSize?` | `null` | Størrelse på radioknappen. |
| color | `DsColor?` | `null` | Fargetema. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Eksempel

```dart
DsRadio(
  value: true,
  groupValue: valgtVerdi == 'alternativ1',
  onChanged: (_) => setState(() => valgtVerdi = 'alternativ1'),
  label: Text('Alternativ 1'),
)
```

## Tilgjengelighet

- Har roving focus med piltaster.
- Synlig fokusindikator ved tastaturnavigasjon.
