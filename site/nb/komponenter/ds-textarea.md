# DsTextarea

Tekstområde for flerlinjes inndata med støtte for tegnbegrensning og konfigurerbar størrelse.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsTextarea?
- For lengre tekst som kommentarer, meldinger eller beskrivelser.
- Når brukeren trenger å skrive flere linjer med tekst.
- Når du ønsker å vise en tegnbegrensning med `maxLength`.

### Når bør du unngå DsTextarea?
- For korte, enlinjes inndata — bruk `DsTextfield` i stedet.
- For strukturert inndata som e-post eller telefonnummer — bruk `DsTextfield` med riktig `keyboardType`.

## Eksempler

### Grunnleggende tekstområde

<WidgetbookEmbed component="Kjernekomponenter/DsTextarea/Standard" />

```dart
DsTextarea(
  controller: kommentarController,
  rows: 5,
  maxLength: 500,
)
```

### Tekstområde med feilmelding

```dart
DsTextarea(
  controller: beskrivelseController,
  rows: 4,
  error: 'Beskrivelse er påkrevd',
)
```

## Retningslinjer
- Sett `rows` til et passende antall basert på forventet innhold.
- Bruk `maxLength` for å begrense lengden der det er relevant.
- Plasser alltid en beskrivende etikett over tekstområdet.

## Tekst
- Feilmeldinger bør være korte og forklarende.
- Bruk hjelpetekst for å veilede brukeren om forventet innhold.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| controller | `TextEditingController?` | `null` | Kontroller for tekstområdet. |
| size | `DsSize?` | `null` | Størrelse på tekstområdet. |
| error | `String?` | `null` | Feilmelding som vises under feltet. |
| disabled | `bool` | `false` | Om tekstområdet er deaktivert. |
| readOnly | `bool` | `false` | Om tekstområdet er skrivebeskyttet. |
| maxLength | `int?` | `null` | Maksimalt antall tegn. |
| rows | `int` | `4` | Antall synlige rader. |
| onChanged | `ValueChanged<String>?` | `null` | Tilbakeringing ved tekstendring. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
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
| `Enter` | Legger til ny linje i tekstområdet |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Tekst og kantlinje oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Feilmeldinger vises med tilstrekkelig kontrast og ikon for ekstra tydelighet.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTextarea" />
