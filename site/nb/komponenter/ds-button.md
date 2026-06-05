# DsButton

Knapp for handlinger. Tre varianter, støtte for ikon, lastetilstand og deaktivert tilstand.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsButton?
- For primærhandlinger i brukergrensesnittet, f.eks. «Send inn», «Lagre», «Neste».
- For sekundærhandlinger som «Avbryt» eller «Tilbake» (bruk `secondary`- eller `tertiary`-varianten).
- Når handlingen utløser en operasjon eller navigasjon.

### Når bør du unngå DsButton?
- For navigasjon til en annen side — bruk `DsLink` i stedet.
- For av/på-funksjonalitet — bruk `DsSwitch` eller `DsCheckbox`.

## Eksempler

### Primærknapp

<WidgetbookEmbed component="Kjernekomponenter/DsButton/Standard" />

```dart
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () => send(),
  child: Text('Send inn'),
)
```

### Knapp med ikon

```dart
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () => send(),
  icon: Icon(DsIcons.send),
  child: Text('Send inn'),
)
```

### Sekundærknapp

```dart
DsButton(
  variant: DsButtonVariant.secondary,
  onPressed: () => avbryt(),
  child: Text('Avbryt'),
)
```

## Retningslinjer
- Bruk kun én primærknapp per seksjon.
- Plasser primærknappen til høyre eller nederst i skjemaer.
- Unngå for mange knapper i samme område.

## Tekst
- Bruk korte, handlingsrettede tekster som «Send inn», «Lagre», «Neste».
- Unngå generiske tekster som «Klikk her» eller «OK».

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i knappen. |
| onPressed | `VoidCallback?` | `null` | Tilbakeringing når knappen trykkes. Når `null`, vises knappen som deaktivert. |
| variant | `DsButtonVariant` | `primary` | Visuell variant av knappen. |
| size | `DsSize?` | `null` | Størrelse på knappen. |
| color | `DsColor?` | `null` | Fargetema for knappen. |
| disabled | `bool` | `false` | Om knappen er deaktivert. |
| loading | `bool` | `false` | Om knappen viser lastetilstand. |
| icon | `Widget?` | `null` | Valgfritt ikon. |
| iconPosition | `DsIconPosition` | `left` | Plassering av ikonet. |
| focusNode | `FocusNode?` | `null` | Valgfri fokusnode for fokushåndtering. |
| autofocus | `bool` | `false` | Om knappen skal be om fokus når den settes inn i treet. |

## Import

```dart
import 'package:designsystemet_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Har `button`-semantikk som gjenkjennes av skjermlesere.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Enter` | Aktiverer knappen |
| `Space` | Aktiverer knappen |
| `Tab` | Flytter fokus til neste element |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Alle varianter oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Deaktiverte knapper markeres med `disabled: true` (eller `onPressed: null`).

</template>
</ComponentTabs>

<ComponentFeedback component="DsButton" />
