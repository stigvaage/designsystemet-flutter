# DsTabs

Fanenavigasjon med tastaturstøtte og roving focus.

<ComponentTabs>
<template #oversikt>

## Bruk

### Når bør du bruke DsTabs?
- Til å organisere relatert innhold i separate visninger innenfor samme kontekst.
- Når brukeren trenger å veksle mellom ulike perspektiver på samme data.
- Til å redusere mengden synlig innhold uten å kreve sidenavigasjon.

### Når bør du unngå DsTabs?
- Når innholdet i fanene er sekvensielt og bør leses i rekkefølge. Bruk en stepper eller vertikal layout i stedet.
- Når det er mer enn 5-6 faner. Vurder en annen navigasjonsstruktur.

## Eksempler

### Grunnleggende bruk

<WidgetbookEmbed component="Navigasjon og layout/DsTabs/Standard" />

```dart
DsTabs(
  tabs: [
    DsTab(label: Text('Oversikt'), child: OversiktInnhold()),
    DsTab(label: Text('Innstillinger'), child: InnstillingerInnhold()),
  ],
  onChanged: (indeks) => print('Fane $indeks valgt'),
)
```

### Med initial fane

```dart
DsTabs(
  initialIndex: 1,
  tabs: [
    DsTab(label: Text('Profil'), child: ProfilInnhold()),
    DsTab(label: Text('Aktivitet'), child: AktivitetInnhold()),
    DsTab(label: Text('Varsler'), child: VarslerInnhold()),
  ],
)
```

## Retningslinjer
- Bruk korte og beskrivende faneetiketter.
- Sørg for at rekkefølgen på fanene er logisk og konsekvent.
- Ikke skjul kritisk innhold bak faner som brukeren kan overse.

## Tekst
- Faneetiketter bør være ett til to ord.
- Bruk substantiver eller korte fraser, ikke hele setninger.

</template>
<template #kode>

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| tabs | List\<DsTab\> | påkrevd | Liste over faner med innhold |
| initialIndex | int | 0 | Indeksen til den først valgte fanen |
| onChanged | ValueChanged\<int\>? | null | Kalles når valgt fane endres |
| size | DsSize? | null | Størrelse på fanekomponenten |

## Import

```dart
import 'package:komponentbibliotek_flutter/components.dart';
```

</template>
<template #tilgjengelighet>

## Semantikk
- Bruker riktig tab-semantikk (`tablist`, `tab`, `tabpanel`) slik at skjermlesere kan identifisere komponentens rolle.
- Implementerer roving focus med piltaster for navigasjon mellom faner.

## Tastaturinteraksjon

| Tast | Handling |
| --- | --- |
| `Tab` | Flytter fokus til den aktive fanen i fanelisten. |
| `Pil høyre` | Flytter fokus og aktiverer neste fane. |
| `Pil venstre` | Flytter fokus og aktiverer forrige fane. |
| `Home` | Flytter fokus og aktiverer den første fanen. |
| `End` | Flytter fokus og aktiverer den siste fanen. |

## Fokusindikator
- Synlig fokusindikator ved tastaturnavigasjon.

## Fargekontrast
- Oppfyller WCAG 2.1 AA kontrastkrav.

</template>
</ComponentTabs>

<ComponentFeedback component="DsTabs" />
