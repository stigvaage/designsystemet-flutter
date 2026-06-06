# DsLink

Lenke med Designsystemet-styling.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsLink?
- Til navigasjon mellom sider eller seksjoner i applikasjonen.
- Til å lenke til eksterne ressurser eller nettsider.
- I løpende tekst der brukeren skal kunne navigere videre.

### Når bør du unngå DsLink?
- Når handlingen utfører en operasjon (f.eks. sletting eller lagring). Bruk `DsButton` i stedet.
- Når lenken ikke har en tydelig destinasjon eller formål.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Kjernekomponenter/DsLink/Standard" />

```dart
DsLink(
  text: 'Gå til designsystemet.no',
  onTap: () => åpneLenke('https://designsystemet.no'),
)
```

### På farget bakgrunn

Sett `inverted: true` når lenken vises på en sterk eller farget bakgrunn, slik at
teksten bruker kontrastfargen og forblir lesbar.

```dart
DsLink(
  text: 'Les mer om tilgjengelighet',
  inverted: true,
  onTap: () => navigerTil('/tilgjengelighet'),
)
```

## Retningslinjer
- Bruk beskrivende lenketekst som forteller brukeren hva som skjer når de klikker.
- Unngå generiske lenketekster som «Klikk her» eller «Les mer» uten kontekst.
- Marker tydelig om lenken åpner en ny fane eller et eksternt nettsted.

## Tekst
- Lenketeksten bør være kort og beskrivende.
- Bruk hele setninger eller meningsfulle fraser, ikke enkeltstående ord som «her».

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| text | `String` | påkrevd | Lenketeksten. Brukes også som Semantics-etikett. |
| onTap | `VoidCallback?` | `null` | Tilbakeringing ved trykk. Når `null` er lenken ikke-interaktiv. |
| color | `DsColor?` | `null` | Overstyrer farge fra omkringliggende `DsColorScope`. |
| inverted | `bool` | `false` | Bruk kontrastfarge på mørk/farget bakgrunn (portspesifikk utvidelse). |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for programmatisk fokusstyring. |
| autofocus | `bool` | `false` | Gi lenken fokus automatisk når den vises. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har link-semantikk slik at skjermlesere identifiserer elementet som en lenke.
- Lenketeksten er tilgjengelig for skjermlesere og beskriver destinasjonen.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til lenken. |
| `Enter` | Aktiverer lenken. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsLink" />
