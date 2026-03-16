# DsDialog

Dialogvindu (modal).

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsDialog?
- Til å be brukeren om bekreftelse før en destruktiv eller viktig handling utføres.
- Til å vise viktig informasjon som krever brukerens oppmerksomhet.
- Til korte skjemaer eller inndata som hører til en pågående arbeidsflyt.

### Når bør du unngå DsDialog?
- Til informasjon som ikke krever umiddelbar handling. Bruk en varsling eller banner i stedet.
- Til lange eller komplekse skjemaer. Bruk en egen side i stedet.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsDialog/Standard" />

```dart
DsDialog(
  title: Text('Bekreft'),
  child: Text('Vil du fortsette?'),
  actions: [
    DsButton(
      variant: DsButtonVariant.secondary,
      onPressed: () => lukk(),
      child: Text('Avbryt'),
    ),
    DsButton(
      variant: DsButtonVariant.primary,
      onPressed: () => bekreft(),
      child: Text('Bekreft'),
    ),
  ],
)
```

### Uten lukkeknapp

```dart
DsDialog(
  title: Text('Viktig melding'),
  closable: false,
  child: Text('Du må fullføre registreringen.'),
  actions: [
    DsButton(
      variant: DsButtonVariant.primary,
      onPressed: () => fullfoer(),
      child: Text('Fullfør'),
    ),
  ],
)
```

## Retningslinjer
- Hold dialoginnholdet kort og fokusert på en enkelt oppgave.
- Plasser den primære handlingen til høyre og sekundær handling til venstre.
- Bruk en tydelig tittel som forklarer hva dialogen handler om.

## Tekst
- Tittelen bør være kort og beskrivende (f.eks. «Slett element?»).
- Handlingsknappene bør bruke verb som beskriver handlingen (f.eks. «Slett», «Avbryt»).

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| title | Widget? | null | Tittelen som vises øverst i dialogen |
| child | Widget | påkrevd | Innholdet i dialogen |
| actions | List\<Widget\> | [] | Handlingsknapper nederst i dialogen |
| closable | bool | true | Om dialogen kan lukkes med lukkeknapp |
| onClose | VoidCallback? | null | Kalles når dialogen lukkes |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Fanger fokus innenfor dialogen (focus trap) slik at brukeren ikke kan tabbe ut av den.
- Lukkeknappen er fokuserbar og synlig for skjermlesere.
- Dialogen annonseres med sin tittel til skjermlesere.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til neste fokuserbare element innenfor dialogen. |
| `Shift + Tab` | Flytter fokus til forrige fokuserbare element innenfor dialogen. |
| `Escape` | Lukker dialogen (når `closable` er `true`). |
| `Enter` | Aktiverer den fokuserte handlingsknappen. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsDialog" />
