# DsTextfield

Tekstfelt for enlinjes inndata med støtte for validering, prefiks/suffiks og ulike tastaturtyper.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsTextfield?
- For korte tekstinndata som navn, e-post, telefonnummer eller søkefelt.
- Når du trenger innebygd validering med feilmeldinger.
- For passordinntasting med `obscureText`.

### Når bør du unngå DsTextfield?
- For flerlinjes tekst — bruk `DsTextarea` i stedet.
- For valg mellom faste alternativer — bruk `DsRadio`, `DsCheckbox` eller en nedtrekksliste.

## Eksempler

### Grunnleggende tekstfelt

<WidgetbookEmbed component="Kjernekomponenter/DsTextfield/Standard" />

```dart
DsTextfield(
  controller: epostController,
  keyboardType: TextInputType.emailAddress,
  onChanged: (verdi) => valider(verdi),
)
```

### Tekstfelt med feilmelding

```dart
DsTextfield(
  controller: navnController,
  error: 'Navn er påkrevd',
)
```

### Passordfelt

```dart
DsTextfield(
  controller: passordController,
  obscureText: true,
  suffix: Icon(DsIcons.eye),
)
```

## Retningslinjer
- Bruk alltid en beskrivende etikett sammen med tekstfeltet.
- Vis feilmeldinger tydelig under feltet med `error`-egenskapen.
- Bruk riktig `keyboardType` for å gi brukeren riktig tastatur på mobil.

## Tekst
- Feilmeldinger bør være korte og forklarende, f.eks. «E-post er ugyldig» eller «Feltet er påkrevd».

</template>
<template #kode>

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

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har `textField`-semantikk som gjenkjennes av skjermlesere.
- Feilmeldinger knyttes semantisk til feltet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til neste element |
| `Shift+Tab` | Flytter fokus til forrige element |
| `Enter` | Sender inn feltet (utløser `onSubmitted`) |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Tekst og kantlinje oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Feilmeldinger vises med tilstrekkelig kontrast og ikon for ekstra tydelighet.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTextfield" />
