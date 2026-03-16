# DsAlert

Varselboks med fire alvorlighetsgrader for å kommunisere viktig informasjon til brukeren.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsAlert?
- For å vise viktige meldinger som brukeren bør legge merke til.
- For feilmeldinger, advarsler, suksessmeldinger eller informasjonsmeldinger.
- Når meldingen gjelder hele siden eller en større seksjon.

### Når bør du unngå DsAlert?
- For inline-feilmeldinger på enkeltfelt — bruk `error`-egenskapen på skjemakomponenter i stedet.
- For kortvarige varsler som forsvinner automatisk — bruk en toast/snackbar.
- For dekorasjon eller generell tekst — bruk vanlige tekstelementer.

## Eksempler

### Informasjonsvarsel

<WidgetbookEmbed component="Kjernekomponenter/DsAlert/Standard" />

```dart
DsAlert(
  severity: DsSeverity.info,
  title: Text('Informasjon'),
  child: Text('Systemet oppdateres i kveld kl. 22:00.'),
)
```

### Advarsel

```dart
DsAlert(
  severity: DsSeverity.warning,
  title: Text('Advarsel'),
  closable: true,
  onClose: () => skjul(),
  child: Text('Vær oppmerksom på dette.'),
)
```

### Feilmelding

```dart
DsAlert(
  severity: DsSeverity.danger,
  title: Text('Feil'),
  child: Text('Noe gikk galt. Prøv igjen senere.'),
)
```

### Suksessmelding

```dart
DsAlert(
  severity: DsSeverity.success,
  title: Text('Lagret'),
  child: Text('Endringene dine er lagret.'),
)
```

## Retningslinjer
- Velg riktig alvorlighetsgrad basert på innholdets viktighet.
- Bruk `closable` kun for meldinger som brukeren trygt kan avvise.
- Hold meldingsteksten kort og handlingsrettet.

## Tekst
- Bruk en kort, beskrivende tittel som oppsummerer meldingen.
- Innholdsteksten bør gi kontekst og eventuelt foreslå neste steg.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
| --- | --- | --- | --- |
| child | `Widget` | påkrevd | Innholdet i varselboksen. |
| severity | `DsSeverity` | `info` | Alvorlighetsgrad (info, warning, danger, success). |
| title | `Widget?` | `null` | Valgfri tittel. |
| closable | `bool` | `false` | Om varselboksen kan lukkes. |
| onClose | `VoidCallback?` | `null` | Tilbakeringing når varselboksen lukkes. |
| color | `DsColor?` | `null` | Fargetema. |
| size | `DsSize?` | `null` | Størrelse på varselboksen. |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig semantikk for alvorlighetsgrad (`info`, `warning`, `danger`, `success`).
- Skjermlesere annonserer alvorlighetsgraden sammen med innholdet.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til lukkeknappen (hvis `closable`) |
| `Enter` | Lukker varselboksen (på lukkeknappen) |
| `Space` | Lukker varselboksen (på lukkeknappen) |
| `Escape` | Lukker varselboksen (hvis `closable`) |

## Fokusindikator
- Lukkeknappen har synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Alle alvorlighetsgrader oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1).
- Ikon og farge brukes sammen for å unngå avhengighet av farge alene.

</template>
</ComponentTabs>

<ComponentFeedback component="DsAlert" />
