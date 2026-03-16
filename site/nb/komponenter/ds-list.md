# DsList

Liste med Designsystemet-styling.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsList?
- Når du skal presentere en samling av relaterte elementer i en strukturert liste.
- Bruk ordnet liste (`ordered: true`) når rekkefølgen er viktig, f.eks. trinnvise instruksjoner.
- Bruk uordnet liste når rekkefølgen ikke har betydning, f.eks. en oppramsing av egenskaper.

### Når bør du unngå DsList?
- Når elementene har kompleks struktur med flere felter — vurder en tabell eller kortliste i stedet.
- Når hvert element krever interaksjon — bruk en navigasjonsliste eller menykomponent.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Skjema og verktøy/DsList/Standard" />

```dart
DsList(
  ordered: true,
  items: [
    Text('Fyll ut søknadsskjema'),
    Text('Last opp dokumentasjon'),
    Text('Send inn søknaden'),
  ],
)
```

### Uordnet liste

```dart
DsList(
  items: [
    Text('Norsk bokmål'),
    Text('Nynorsk'),
    Text('Samisk'),
  ],
)
```

## Retningslinjer
- Velg mellom ordnet og uordnet liste basert på om rekkefølgen er meningsbærende.
- Hold listeelementene konsistente i form og lengde for bedre lesbarhet.
- Bruk `size`-egenskapen for å tilpasse listestørrelsen til konteksten.

## Tekst
- Start hvert listeelement med stor bokstav.
- Hold hvert element kort og konsist — ideelt sett en setning eller frase.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| items | `List<Widget>` | påkrevd | Listeelementene som skal vises. |
| ordered | `bool` | `false` | Om listen er nummerert (ordnet). |
| size | `DsSize?` | `null` | Størrelse på listen. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig list-semantikk (ordnet eller uordnet) slik at skjermlesere annonserer listetypen og antall elementer.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| Tab | Flytter fokus til eventuelle interaktive elementer i listen. |
| Piltaster | Navigerer mellom listeelementer i skjermleser-modus. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsList" />
