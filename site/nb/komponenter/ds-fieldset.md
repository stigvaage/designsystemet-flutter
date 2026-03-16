# DsFieldset

Gruppering av relaterte skjemaelementer med legend.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsFieldset?
- Når du har en gruppe relaterte skjemafelter som logisk hører sammen, f.eks. adressefelt.
- Når du trenger å gi en felles overskrift (legend) til en samling av inndatafelt.
- Når du grupperer radioknapper eller avkrysningsbokser som hører til samme spørsmål.

### Når bør du unngå DsFieldset?
- Når du kun har ett enkelt felt. Bruk heller `DsField` alene.
- Når feltene ikke er logisk relaterte og ikke trenger en felles overskrift.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsFieldset/Standard" />

```dart
DsFieldset(
  legend: 'Adresse',
  children: [
    DsField(label: 'Gate', child: DsTextfield(controller: gateController)),
    DsField(label: 'Postnummer', child: DsTextfield(controller: postnummerController)),
    DsField(label: 'Sted', child: DsTextfield(controller: stedController)),
  ],
)
```

### Grupperte radioknapper

```dart
DsFieldset(
  legend: 'Foretrukket kontaktmetode',
  children: [
    DsRadio(label: 'E-post', value: 'epost', groupValue: kontaktmetode, onChanged: (v) => setState(() => kontaktmetode = v)),
    DsRadio(label: 'Telefon', value: 'telefon', groupValue: kontaktmetode, onChanged: (v) => setState(() => kontaktmetode = v)),
    DsRadio(label: 'SMS', value: 'sms', groupValue: kontaktmetode, onChanged: (v) => setState(() => kontaktmetode = v)),
  ],
)
```

## Retningslinjer
- Bruk legend til å gi en tydelig overskrift som beskriver gruppen av felt.
- Grupper kun felt som logisk hører sammen, f.eks. adressefelt eller kontaktinformasjon.
- Ikke nøst flere fieldsets dypt -- hold strukturen flat og oversiktlig.

## Tekst
- Legend-teksten bør være kort og beskrivende, f.eks. «Adresse» eller «Kontaktinformasjon».
- Unngå å bruke legend som en instruksjon -- den skal fungere som en overskrift for gruppen.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| legend | `String` | påkrevd | Overskrift for gruppen av skjemaelementer. |
| children | `List<Widget>` | påkrevd | Skjemaelementene som grupperes. |
| size | `DsSize?` | `null` | Størrelse på feltsettet. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har fieldset/legend-semantikk for gruppering slik at skjermlesere annonserer gruppens overskrift.
- Skjermlesere leser legend-teksten automatisk som kontekst for hvert felt i gruppen.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til første inndatafelt i gruppen |
| Shift + Tab | Flytter fokus tilbake til forrige fokuserbare element utenfor gruppen |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsFieldset" />
