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

`DsDialog` har ingen egen `actions`-slot. Plasser handlingsknapper nederst i
`child`, for eksempel i en `Row`:

```dart
DsDialog(
  title: const Text('Bekreft'),
  onClose: () => Navigator.of(context).pop(),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Vil du fortsette?'),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DsButton(
            variant: DsButtonVariant.secondary,
            onPressed: () => lukk(),
            child: const Text('Avbryt'),
          ),
          const SizedBox(width: 8),
          DsButton(
            variant: DsButtonVariant.primary,
            onPressed: () => bekreft(),
            child: const Text('Bekreft'),
          ),
        ],
      ),
    ],
  ),
)
```

### Uten lukkeknapp

Sett `closeButton: false` for å skjule lukkeknappen (X). `Escape` lukker
fortsatt dialogen.

```dart
DsDialog(
  title: const Text('Viktig melding'),
  closeButton: false,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Du må fullføre registreringen.'),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DsButton(
            variant: DsButtonVariant.primary,
            onPressed: () => fullfoer(),
            child: const Text('Fullfør'),
          ),
        ],
      ),
    ],
  ),
)
```

### Vis dialogen som modal rute

```dart
DsDialog.show(
  context: context,
  builder: (context) => DsDialog(
    title: const Text('Bekreft'),
    onClose: () => Navigator.of(context).pop(),
    child: const Text('Vil du fortsette?'),
  ),
)
```

### Skuff (drawer)

Bruk `placement` for å forankre dialogen til en skjermkant.

```dart
DsDialog.show(
  context: context,
  placement: DsDialogPlacement.right,
  builder: (context) => DsDialog(
    placement: DsDialogPlacement.right,
    title: const Text('Filtre'),
    child: const Text('Innhold i skuffen.'),
  ),
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
| child | Widget | påkrevd | Innholdet i dialogen |
| title | Widget? | null | Tittelen som vises øverst i dialogen |
| onClose | VoidCallback? | null | Kalles når dialogen lukkes (lukkeknapp, `Escape`, klikk utenfor eller tilbakenavigasjon) |
| closeButton | bool | true | Om lukkeknappen (X) vises |
| placement | DsDialogPlacement | center | Hvor dialogen plasseres (center, left, right, top, bottom) |
| color | DsColor? | null | Fargeskala for dialogen (faller tilbake til `DsColorScope`) |

`DsDialog.show` tar i tillegg `closeOnBarrierTap` (standard `false`) som styrer om
klikk utenfor dialogen lukker den, og `placement` for plassering på skjermen.

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Fanger fokus innenfor dialogen (focus trap) slik at brukeren ikke kan tabbe ut av den.
- Lukkeknappen vises som standard, er fokuserbar og annonseres som «Lukk dialogvindu» til skjermlesere.
- Dialogen annonseres med sin tittel til skjermlesere.
- Klikk utenfor dialogen lukker den ikke som standard; bruk `Escape` eller lukkeknappen. Sett `closeOnBarrierTap: true` i `DsDialog.show` for å tillate lukking ved klikk utenfor.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til neste fokuserbare element innenfor dialogen. |
| `Shift + Tab` | Flytter fokus til forrige fokuserbare element innenfor dialogen. |
| `Escape` | Lukker dialogen. |
| `Enter` | Aktiverer den fokuserte handlingsknappen. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsDialog" />
