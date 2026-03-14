# DsTextfield

Tekstfelt for enlinjes inndata.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Kjernekomponenter/DsTextfield" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| controller | `TextEditingController?` | `null` | Kontroller for tekstfeltet. |
| size | `DsSize?` | `null` | Størrelse på tekstfeltet. |
| error | `String?` | `null` | Feilmelding som vises under feltet. |
| disabled | `bool` | `false` | Om tekstfeltet er deaktivert. |
| readOnly | `bool` | `false` | Om tekstfeltet er skrivebeskyttet. |
| prefix | `Widget?` | `null` | Widget som vises foran inndata. |
| suffix | `Widget?` | `null` | Widget som vises etter inndata. |
| onChanged | `ValueChanged<String>?` | `null` | Tilbakeringing ved tekstendring. |
| onSubmitted | `ValueChanged<String>?` | `null` | Tilbakeringing ved innsending. |
| keyboardType | `TextInputType?` | `null` | Type tastatur som vises. |
| obscureText | `bool` | `false` | Om teksten skal skjules (f.eks. passord). |
| maxLength | `int?` | `null` | Maksimalt antall tegn. |
| autofocus | `bool` | `false` | Om feltet får fokus automatisk. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Eksempel

```dart
DsTextfield(
  controller: epostController,
  keyboardType: TextInputType.emailAddress,
  onChanged: (verdi) => valider(verdi),
)
```

## Tilgjengelighet

- Har `textField`-semantikk.
- Synlig fokusindikator ved tastaturnavigasjon.
