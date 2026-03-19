# DsSwitch

Av/på-bryter for binære innstillinger med umiddelbar effekt.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsSwitch?
- For innstillinger som slår en funksjon av eller på med umiddelbar effekt.
- Når endringen ikke krever bekreftelse eller innsending av skjema.
- For preferanser som «Aktiver varsler» eller «Mørk modus».

### Når bør du unngå DsSwitch?
- For valg som krever skjemainnsending — bruk `DsCheckbox` i stedet.
- For valg mellom flere alternativer — bruk `DsRadio`.
- For handlinger — bruk `DsButton`.

## Eksempler

### Grunnleggende bryter

<WidgetbookEmbed component="Kjernekomponenter/DsSwitch/Standard" />

```dart
DsSwitch(
  value: aktiv,
  onChanged: (verdi) => setState(() => aktiv = verdi),
  label: Text('Aktiver varsler'),
)
```

### Med beskrivelse

```dart
DsSwitch(
  value: aktiv,
  onChanged: (verdi) => setState(() => aktiv = verdi),
  label: Text('Aktiver varsler'),
  description: Text('Du vil motta varsler på e-post og i appen.'),
)
```

### Skrivebeskyttet bryter

```dart
DsSwitch(
  value: true,
  onChanged: null,
  readOnly: true,
  label: Text('Innstilling låst av administrator'),
)
```

## Retningslinjer
- Bryteren bør ha umiddelbar effekt — ingen ekstra «Lagre»-knapp.
- Plasser alltid en tydelig etikett ved siden av bryteren.
- Unngå negasjoner i etiketten (bruk «Aktiver varsler», ikke «Deaktiver varsler»).

## Tekst
- Etiketten bør beskrive tilstanden som aktiveres, f.eks. «Mørk modus» eller «Aktiver varsler».
- Unngå spørsmålsformuleringer som «Vil du aktivere varsler?».

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| value | `bool` | påkrevd | Om bryteren er på. |
| onChanged | `ValueChanged<bool>?` | påkrevd | Tilbakeringing ved endring. |
| label | `Widget?` | `null` | Etikett som vises ved siden av bryteren. |
| description | `Widget?` | `null` | Hjelpetekst som vises under etiketten. |
| size | `DsSize?` | `null` | Størrelse på bryteren. |
| color | `DsColor?` | `null` | Fargetema. |
| readOnly | `bool` | `false` | Om bryteren er skrivebeskyttet. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har `switch`-semantikk som gjenkjennes av skjermlesere.
- Skjermlesere annonserer på/av-tilstand.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Space` | Veksler bryteren av/på |
| `Enter` | Veksler bryteren av/på |
| `Tab` | Flytter fokus til neste element |
| `Shift+Tab` | Flytter fokus til forrige element |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Av- og på-tilstand oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Deaktiverte brytere markeres med `enabled: false`.

</template>
</ComponentTabs>

<ComponentFeedback component="DsSwitch" />
