# DsInput

Generisk inndatafelt (lavnivå-komponent).

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsInput?
- Når brukeren skal oppgi tekst, tall eller annen kort fritekst i et skjema.
- Når du bygger egendefinerte skjemakomponenter og trenger et lavnivå inndatafelt.
- I kombinasjon med DsLabel og DsValidationMessage for å lage fullstendige skjemafelt.

### Når bør du unngå DsInput?
- Når brukeren skal velge mellom forhåndsdefinerte alternativer — bruk DsSelect eller radioknapper i stedet.
- Når brukeren skal skrive lengre tekst — vurder et flerlinjet tekstfelt i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsInput/Standard" />

```dart
DsInput(
  controller: navnController,
  onChanged: (verdi) => print(verdi),
)
```

### Med feiltilstand

```dart
DsInput(
  controller: epostController,
  error: 'Ugyldig e-postadresse',
  onChanged: (verdi) => valider(verdi),
)
```

## Retningslinjer
- Bruk alltid en tilhørende DsLabel slik at brukeren vet hva feltet forventer.
- Vis tydelige feilmeldinger med `error`-egenskapen når validering feiler.
- Velg passende størrelse med `size` for å opprettholde konsistens i skjemaet.

## Tekst
- Hold plassholdertekst kort og beskrivende, f.eks. «Skriv inn navn».
- Unngå å bruke plassholdertekst som erstatning for en etikett.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| controller | `TextEditingController?` | `null` | Kontroller for inndatafeltet. Opprettes internt når den er `null`. |
| size | `DsSize?` | `null` | Størrelse på inndatafeltet. Faller tilbake til omsluttende størrelse. |
| error | `String?` | `null` | Feilmelding som aktiverer feiltilstand. Faller tilbake til feltets `DsField`-feil. |
| disabled | `bool` | `false` | Om inndatafeltet er deaktivert (dempet og ignorerer trykk). |
| readOnly | `bool` | `false` | Om innholdet er skrivebeskyttet (kan fokuseres og markeres, men ikke redigeres). |
| prefix | `Widget?` | `null` | Innhold til venstre for feltet, f.eks. et ikon. |
| suffix | `Widget?` | `null` | Innhold til høyre for feltet, f.eks. et ikon eller en tøm-knapp. |
| placeholder | `String?` | `null` | Plassholdertekst som vises når feltet er tomt. |
| onChanged | `ValueChanged<String>?` | `null` | Tilbakeringing ved hver endring av verdi. |
| onSubmitted | `ValueChanged<String>?` | `null` | Tilbakeringing når brukeren utløser handlingstasten. |
| onTap | `VoidCallback?` | `null` | Tilbakeringing når brukeren trykker på feltet. |
| focusNode | `FocusNode?` | `null` | Eksternt fokusobjekt. Opprettes internt når den er `null`. |
| keyboardType | `TextInputType?` | `null` | Tastaturtype for myktastatur. |
| obscureText | `bool` | `false` | Skjuler tegnene (passordfelt). |
| maxLength | `int?` | `null` | Maksimalt antall tegn. |
| maxLines | `int?` | `1` | Maksimalt antall linjer. `1` gir et enkeltlinjefelt. |
| minLines | `int?` | `null` | Minste antall synlige linjer for et flerlinjefelt. |
| autofocus | `bool` | `false` | Gir feltet fokus automatisk ved første visning. |
| textInputAction | `TextInputAction?` | `null` | Handlingen som tastaturets handlingstast representerer. |
| inputFormatters | `List<TextInputFormatter>?` | `null` | Inndatafiltere som transformerer eller begrenser teksten. |
| autocorrect | `bool` | `true` | Lar plattformen foreslå rettelser. |
| enableSuggestions | `bool` | `true` | Lar plattformen vise skriveforslag. |
| textCapitalization | `TextCapitalization` | `none` | Hvordan tekst automatisk gjøres til store bokstaver. |
| textAlign | `TextAlign` | `start` | Horisontal justering av teksten. |

## Implementasjon

`DsInput` er bygget direkte på `EditableText` fra `package:flutter/widgets.dart` —
uten avhengighet til Material eller Cupertino. Kantlinje, bakgrunn, polstring,
fokusring og plassholder tegnes av komponenten selv ut fra `DsTheme`-tokens, og
markør-, markerings- og tekstfarger kommer rett fra tokenpaletten.

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har textField-semantikk slik at skjermlesere annonserer feltet korrekt.
- Eksponerer gjeldende verdi, plassholder som etikett, og om feltet er deaktivert eller skrivebeskyttet.
- I feiltilstand markeres feltet som ugyldig (`validationResult: invalid`), og feilmeldingen leses opp som et hint.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til inndatafeltet. |
| Shift + Tab | Flytter fokus til forrige element. |
| Bokstaver / tall | Skriver inn tekst i feltet. |
| Backspace | Sletter tegnet foran markøren. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsInput" />
