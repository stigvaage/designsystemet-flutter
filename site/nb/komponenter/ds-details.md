# DsDetails

Sammenleggbar detaljseksjon.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsDetails?
- Når du vil skjule utfyllende informasjon som ikke alle brukere trenger å se umiddelbart.
- For å redusere visuelt støy på sider med mye innhold, f.eks. ofte stilte spørsmål.
- Når innholdet er relevant men sekundært, slik at brukeren selv kan velge å vise det.

### Når bør du unngå DsDetails?
- Når innholdet er kritisk og alle brukere må se det — vis det direkte i stedet.
- Når du har mange sammenleggbare seksjoner i sekvens — vurder en egen FAQ-side eller akkordeon.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsDetails/Standard" />

```dart
DsDetails(
  summary: Text('Tekniske detaljer'),
  initiallyOpen: false,
  child: DsParagraph(text: 'Her er de tekniske detaljene.'),
)
```

### Åpen ved oppstart

```dart
DsDetails(
  summary: Text('Viktig informasjon'),
  initiallyOpen: true,
  child: DsParagraph(text: 'Denne informasjonen vises som standard.'),
)
```

## Retningslinjer
- Bruk en kort og beskrivende overskrift i `summary` slik at brukeren forstår hva som skjules.
- Unngå å nøste DsDetails inne i hverandre, da det gjør navigasjon komplisert.
- Bruk `initiallyOpen: true` kun når innholdet er viktig nok til å vises som standard.

## Tekst
- Overskriften i `summary` bør være en kort setning eller frase, ikke et enkelt ord.
- Innholdet bør gi tilleggsinformasjon som utdyper overskriften.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| summary | `Widget` | påkrevd | Innholdet som alltid vises (klikkbar overskrift). |
| child | `Widget` | påkrevd | Innholdet som vises når seksjonen er åpen. |
| initiallyOpen | `bool` | `false` | Om seksjonen er åpen ved oppstart. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har expanded/collapsed-semantikk slik at skjermlesere annonserer om seksjonen er åpen eller lukket.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til summary-elementet. |
| Enter | Åpner eller lukker detaljseksjonen. |
| Mellomrom | Åpner eller lukker detaljseksjonen. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsDetails" />
