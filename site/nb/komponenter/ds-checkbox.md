# DsCheckbox

Avkrysningsboks for flervalg med støtte for ubestemt tilstand og validering.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsCheckbox?
- Når brukeren skal velge ett eller flere alternativer fra en liste.
- For å bekrefte vilkår eller samtykke, f.eks. «Jeg godtar vilkårene».
- Når du trenger en ubestemt tilstand for delvis valg i en gruppe.

### Når bør du unngå DsCheckbox?
- For enkeltvalg mellom gjensidig utelukkende alternativer — bruk `DsRadio` i stedet.
- For enkel av/på-funksjonalitet — bruk `DsSwitch`.

## Eksempler

### Grunnleggende avkrysningsboks

<WidgetbookEmbed component="Kjernekomponenter/DsCheckbox/Standard" />

```dart
DsCheckbox(
  value: godtatt,
  onChanged: (verdi) => setState(() => godtatt = verdi),
  label: Text('Jeg godtar vilkårene'),
)
```

### Ubestemt tilstand

```dart
DsCheckbox(
  value: false,
  indeterminate: true,
  onChanged: (verdi) => velgAlle(verdi),
  label: Text('Velg alle'),
)
```

### Avkrysningsboks med feilmelding

```dart
DsCheckbox(
  value: false,
  onChanged: (verdi) => setState(() => godtatt = verdi),
  label: Text('Jeg godtar vilkårene'),
  error: 'Du må godta vilkårene for å fortsette',
)
```

## Retningslinjer
- Bruk alltid en tydelig etikett som beskriver hva valget innebærer.
- Grupper relaterte avkrysningsbokser visuelt.
- Bruk ubestemt tilstand kun for foreldre-avkrysningsbokser i hierarkiske lister.

## Tekst
- Etiketter bør være korte og beskrivende.
- Unngå negasjoner i etiketter (f.eks. «Ikke send meg e-post»).

</template>
<template #kode>

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

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har `checked`-semantikk som gjenkjennes av skjermlesere.
- Ubestemt tilstand annonseres som «mixed» av skjermlesere.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Space` | Veksler avkrysset/ikke avkrysset |
| `Tab` | Flytter fokus til neste element |
| `Shift+Tab` | Flytter fokus til forrige element |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Avkrysset og ikke-avkrysset tilstand oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Feilmeldinger vises med tilstrekkelig kontrast.

</template>
</ComponentTabs>

<ComponentFeedback component="DsCheckbox" />
