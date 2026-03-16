# DsCard

Kort for å gruppere relatert innhold med valgfrie underseksjoner og klikkbarhet.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsCard?
- For å gruppere relatert innhold visuelt, f.eks. en artikkelforhåndsvisning.
- For klikkbare enheter som navigerer til en detaljside.
- Når du trenger en strukturert layout med header, innhold og footer.

### Når bør du unngå DsCard?
- For enkle tekstblokker uten visuell avgrensning — bruk vanlige tekstelementer.
- For interaktive handlinger — bruk `DsButton` i stedet.
- For navigasjonslister — bruk dedikerte navigasjonskomponenter.

## Eksempler

### Grunnleggende kort

<WidgetbookEmbed component="Kjernekomponenter/DsCard/Standard" />

```dart
DsCard(
  child: DsCardBlock(
    child: DsParagraph(text: 'Enkelt kortinnhold.'),
  ),
)
```

### Kort med seksjoner

```dart
DsCard(
  elevated: true,
  onTap: () => naviger(),
  child: Column(
    children: [
      DsCardHeader(child: DsHeading(text: 'Tittel', level: DsHeadingLevel.sm)),
      DsCardBlock(child: DsParagraph(text: 'Kortinnhold her.')),
      DsCardFooter(child: DsButton(onPressed: () {}, child: Text('Les mer'))),
    ],
  ),
)
```

### Kort med skygge

```dart
DsCard(
  elevated: true,
  child: DsCardBlock(
    child: DsParagraph(text: 'Kort med skygge for visuell dybde.'),
  ),
)
```

## Retningslinjer
- Bruk `DsCardHeader`, `DsCardBlock` og `DsCardFooter` for konsistent struktur.
- Bruk `elevated` for å skille kortet visuelt fra bakgrunnen.
- Unngå for mye innhold i ett kort — del heller opp i flere kort.

## Tekst
- Bruk korte, beskrivende titler i header-seksjonen.
- Hold innholdsteksten konsis og fokusert.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i kortet. |
| color | `DsColor?` | `null` | Fargetema. |
| elevated | `bool` | `false` | Om kortet har skygge. |
| onTap | `VoidCallback?` | `null` | Tilbakeringing ved trykk (gjør kortet klikkbart). |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |

Relaterte komponenter: `DsCardHeader`, `DsCardBlock`, `DsCardFooter`.

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Klikkbare kort har `button`-semantikk som gjenkjennes av skjermlesere.
- Ikke-klikkbare kort bruker gruppering-semantikk.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Enter` | Aktiverer klikkbart kort (utløser `onTap`) |
| `Space` | Aktiverer klikkbart kort (utløser `onTap`) |
| `Tab` | Flytter fokus til neste fokuserbare element |
| `Shift+Tab` | Flytter fokus til forrige fokuserbare element |

## Fokusindikator
- Klikkbare kort har synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Kortramme og bakgrunn oppfyller WCAG 2.1 AA kontrastkrav (minimum 3:1 for ikke-tekst).
- Innholdstekst oppfyller minimum 4.5:1 kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsCard" />
