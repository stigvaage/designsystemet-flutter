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
  title: 'Du må rette opp følgende',
  errors: const ['Navn er påkrevd', 'Ugyldig e-postadresse'],
  onErrorTap: (index) => _fokuserFelt(index),
)
```

### Uten tilpasset tittel

Uten `title` brukes standardteksten «Du må rette opp følgende».

```dart
DsErrorSummary(
  errors: const ['Ugyldig telefonnummer'],
)
```

### Flytt fokus til sammendraget

Send med en `focusNode` og kall `requestFocus()` etter mislykket innsending,
slik at tastatur- og skjermleserbrukere tas til feillisten. Alternativt kan du
sette `autofocus: true`.

```dart
final summaryFocusNode = FocusNode();

DsErrorSummary(
  errors: feilListe,
  focusNode: summaryFocusNode,
  onErrorTap: (index) => _fokuserFelt(index),
)

// Etter mislykket validering:
summaryFocusNode.requestFocus();
```

## Retningslinjer
- Plasser feilsammendraget øverst i skjemaet slik at det er synlig uten å måtte scrolle.
- Sørg for at hver feil i sammendraget lenker til det aktuelle skjemafeltet.
- Gi fokus til feilsammendraget automatisk etter mislykket innsending.

## Tekst
- Bruk en tydelig overskrift som forklarer at det finnes feil. Standardteksten er «Du må rette opp følgende».
- Feilmeldingene bør være konkrete og handlingsrettede.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| errors | `List<String>` | påkrevd | Liste over feilmeldinger som skal vises. |
| title | `String?` | `'Du må rette opp følgende'` | Overskrift for feilsammendraget. |
| onErrorTap | `ValueChanged<int>?` | `null` | Kalles med feilens indeks når en feil aktiveres; gjør hver feil til en fokuserbar lenke. |
| size | `DsSize` | `DsSize.md` | Størrelse på feilsammendraget. |
| color | `DsColor` | `DsColor.danger` | Semantisk farge for sammendraget. |
| focusNode | `FocusNode?` | `null` | Fokusnode for sammendraget. Kall `requestFocus()` etter mislykket innsending for å flytte fokus hit. |
| autofocus | `bool` | `false` | Gir sammendraget fokus så snart det vises. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Sammendraget er en «live region» slik at skjermlesere kunngjør det når det vises.
- Send med en `focusNode` (eller bruk `autofocus`) for å flytte fokus til sammendraget etter mislykket innsending.
- Når `onErrorTap` er satt, blir hver feil en lenke til det aktuelle feltet. Uten `onErrorTap` vises feilene som vanlig tekst.

## Tastaturinteraksjon

Tabellen under gjelder når `onErrorTap` er satt, slik at feilene er fokuserbare lenker.

| Tast | Handling |
| --- | --- |
| Tab | Navigerer mellom feillenker i sammendraget. |
| Enter / Mellomrom | Aktiverer feillenken og kaller `onErrorTap` med feilens indeks. |
| Shift + Tab | Flytter fokus til forrige feillenke. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsErrorSummary" />
