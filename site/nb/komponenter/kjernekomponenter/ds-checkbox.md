# DsCheckbox

Avkrysningsboks med støtte for ubestemt tilstand.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsCheckbox" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| value | `bool` | påkrevd | Om boksen er avkrysset. |
| onChanged | `ValueChanged<bool>?` | påkrevd | Tilbakeringing ved endring. |
| label | `Widget?` | `null` | Etikett som vises ved siden av boksen. |
| size | `DsSize?` | `null` | Størrelse på avkrysningsboksen. |
| color | `DsColor?` | `null` | Fargetema. |
| error | `String?` | `null` | Feilmelding som vises under boksen. |
| indeterminate | `bool` | `false` | Om boksen viser ubestemt tilstand. |
| readOnly | `bool` | `false` | Om boksen er skrivebeskyttet. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Eksempel

```dart
DsCheckbox(
  value: godtatt,
  onChanged: (verdi) => setState(() => godtatt = verdi),
  label: Text('Jeg godtar vilkårene'),
)
```

## Tilgjengelighet

- Har `checked`-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
