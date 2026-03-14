# Feilhåndtering

Denne siden beskriver mønstre for feilhåndtering i applikasjoner som bruker komponentbiblioteket. God feilhåndtering handler om å gi brukeren forståelig informasjon om hva som gikk galt og hva de kan gjøre videre.

## Operasjonelle feil med DsAlert

Bruk `DsAlert` med `severity: DsSeverity.danger` for å vise systemfeil som API-feil, nettverksproblemer eller andre operasjonelle feil som ikke er knyttet til enkeltfelt i et skjema:

```dart
DsAlert(
  severity: DsSeverity.danger,
  title: Text('Noe gikk galt'),
  closable: true,
  onClose: () => setState(() => visFeil = false),
  child: Text('Kunne ikke lagre endringene. Prøv igjen senere.'),
)
```

`DsAlert` plasseres typisk øverst i innholdsområdet slik at brukeren ser meldingen umiddelbart. Parameteren `closable` gir brukeren mulighet til å lukke varselet når de har lest det.

For advarsler som ikke blokkerer brukeren, bruk `severity: DsSeverity.warning`:

```dart
DsAlert(
  severity: DsSeverity.warning,
  title: Text('Ustabil tilkobling'),
  child: Text('Tilkoblingen er ustabil. Endringene dine lagres når forbindelsen er gjenopprettet.'),
)
```

## Feiloppsummering i skjemaer med DsErrorSummary

Når et skjema har flere valideringsfeil, bruk `DsErrorSummary` øverst i skjemaet for å gi en samlet oversikt:

```dart
DsErrorSummary(
  title: 'Rett følgende feil for å gå videre:',
  errors: feilListe,
)
```

Denne komponenten lister opp alle feilmeldingene på ett sted, slik at brukeren raskt kan se hva som må rettes. Se [Skjemavalidering](./skjemavalidering) for et fullstendig eksempel.

## Inline-feil på enkeltfelt

For valideringsfeil knyttet til spesifikke felt, bruk `error`-parameteren på `DsField` og `DsTextfield`:

```dart
DsField(
  label: 'E-post',
  error: _epostFeil,
  child: DsTextfield(
    controller: _epostController,
    error: _epostFeil,
  ),
)
```

Inline-feil gir presis tilbakemelding på nøyaktig det feltet som har et problem. Kombiner gjerne med `DsErrorSummary` for skjemaer med mange felt.

## Lastetilstand med DsButton

Bruk `loading`-parameteren på `DsButton` for å vise at en operasjon pågår. Deaktiver knappen samtidig for å hindre dobbelt innsending:

```dart
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: _erSender ? null : _sendSkjema,
  loading: _erSender,
  child: Text('Send inn'),
)
```

Når `loading` er `true`, viser knappen en lasteindikator i stedet for innholdet. Ved å sette `onPressed` til `null` mens operasjonen pågår, forhindrer du at brukeren trykker flere ganger.

## Beste praksis

- **Bruk `DsAlert` med `severity: DsSeverity.danger` for system- og API-feil.** Disse feilene er ikke knyttet til enkeltfelt, men til operasjoner som mislyktes.
- **Bruk `DsAlert` med `severity: DsSeverity.warning` for advarsler som ikke blokkerer.** For eksempel ustabil nettverkstilkobling eller informasjon om planlagt vedlikehold.
- **Bruk `DsErrorSummary` øverst i skjemaer med flere feil.** Det gir brukeren oversikt uten at de må lete gjennom hele skjemaet.
- **Bruk inline-feil på enkeltfelt for spesifikke valideringsmeldinger.** Send alltid samme `error`-verdi til både `DsField` og inputkomponenten.
- **Skriv tydelige og brukervennlige feilmeldinger på norsk.** Unngå teknisk sjargong. Skriv hva som gikk galt og hva brukeren kan gjøre, for eksempel «Kunne ikke lagre endringene. Prøv igjen senere.»
- **Gi alltid mulighet til å prøve igjen eller lukke feilmeldinger.** Bruk `closable: true` på `DsAlert` eller inkluder en prøv-igjen-knapp slik at brukeren ikke sitter fast.
