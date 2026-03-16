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

### Med størrelse

```dart
DsLink(
  text: 'Les mer om tilgjengelighet',
  size: DsSize.sm,
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
| text | `String` | påkrevd | Lenketeksten. |
| onTap | `VoidCallback?` | påkrevd | Tilbakeringing ved trykk. |
| size | `DsSize?` | `null` | Størrelse på lenken. |
| color | `DsColor?` | `null` | Fargetema. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
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
