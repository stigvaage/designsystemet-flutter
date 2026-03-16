# DsTag

Etikett for kategorisering og statusvisning med ulike farger og størrelser.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsTag?
- For å vise status eller kategori, f.eks. «Godkjent», «Ny» eller «Under behandling».
- For å merke innhold med metadata som er synlig for brukeren.
- For visuelle indikatorer som ikke krever brukerinteraksjon.

### Når bør du unngå DsTag?
- For interaktive valg eller filtrering — bruk `DsChip` i stedet.
- For handlingsknapper — bruk `DsButton`.
- For lengre tekstblokker — bruk vanlige tekstelementer.

## Eksempler

### Grunnleggende etikett

<WidgetbookEmbed component="Kjernekomponenter/DsTag/Standard" />

```dart
DsTag(
  color: DsColor.success,
  size: DsSize.sm,
  child: Text('Godkjent'),
)
```

### Ulike fargevarianter

```dart
Column(
  children: [
    DsTag(color: DsColor.info, child: Text('Informasjon')),
    DsTag(color: DsColor.success, child: Text('Godkjent')),
    DsTag(color: DsColor.warning, child: Text('Venter')),
    DsTag(color: DsColor.danger, child: Text('Avvist')),
  ],
)
```

## Retningslinjer
- Bruk konsistente farger for samme type status gjennom hele applikasjonen.
- Hold etikett-teksten kort — helst ett eller to ord.
- Unngå for mange etiketter i samme område.

## Tekst
- Bruk korte, beskrivende ord som «Ny», «Aktiv», «Arkivert».
- Unngå setninger eller lengre tekst i etiketter.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i etiketten. |
| size | `DsSize?` | `null` | Størrelse på etiketten. |
| color | `DsColor?` | `null` | Fargetema. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig tekst-semantikk som gjenkjennes av skjermlesere.
- Etiketten leses opp som en del av innholdsflyten.

## Tastaturinteraksjon

DsTag er ikke interaktiv og mottar ikke fokus. Den er en ren visuell indikator.

## Fokusindikator
- Ikke relevant — DsTag er ikke fokuserbar.

## Fargekontrast
- Tekst mot bakgrunn oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Farge alene brukes ikke som eneste informasjonsbærer — teksten formidler alltid meningen.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTag" />
