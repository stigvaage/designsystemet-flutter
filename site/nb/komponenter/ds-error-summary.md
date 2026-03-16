# DsErrorSummary

Feilsammendrag for skjemavalidering — viser alle feil samlet.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsErrorSummary?
- Når et skjema har flere valideringsfeil som skal vises samlet etter innsending.
- Når brukeren trenger en oversikt over alle feil med lenker til de aktuelle feltene.
- Øverst i skjemaet etter mislykket validering, slik at brukeren raskt får oversikt.

### Når bør du unngå DsErrorSummary?
- Når det kun er ett enkelt felt med feil — bruk DsValidationMessage direkte på feltet.
- For generelle varsler som ikke er knyttet til skjemavalidering — bruk en varselkomponent i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsErrorSummary/Standard" />

```dart
DsErrorSummary(
  title: 'Rett følgende feil for å gå videre:',
  errors: [
    DsErrorEntry(field: 'Navn', message: 'Navn er påkrevd'),
    DsErrorEntry(field: 'E-post', message: 'Ugyldig e-postadresse'),
  ],
)
```

### Uten tilpasset tittel

```dart
DsErrorSummary(
  errors: [
    DsErrorEntry(field: 'Telefonnummer', message: 'Ugyldig telefonnummer'),
  ],
)
```

## Retningslinjer
- Plasser feilsammendraget øverst i skjemaet slik at det er synlig uten å måtte scrolle.
- Sørg for at hver feil i sammendraget lenker til det aktuelle skjemafeltet.
- Gi fokus til feilsammendraget automatisk etter mislykket innsending.

## Tekst
- Bruk en tydelig overskrift som forklarer at det finnes feil, f.eks. «Rett følgende feil for å gå videre:».
- Feilmeldingene bør være konkrete og handlingsrettede.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| errors | `List<DsErrorEntry>` | påkrevd | Liste over feil som skal vises. |
| title | `String?` | `null` | Overskrift for feilsammendraget. |
| size | `DsSize?` | `null` | Størrelse på feilsammendraget. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker alert-semantikk for å varsle om feil.
- Lenker til feilaktige felt slik at brukeren raskt kan navigere til dem.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Navigerer mellom feillenker i sammendraget. |
| Enter | Aktiverer feillenken og flytter fokus til det aktuelle feltet. |
| Shift + Tab | Flytter fokus til forrige feillenke. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsErrorSummary" />
