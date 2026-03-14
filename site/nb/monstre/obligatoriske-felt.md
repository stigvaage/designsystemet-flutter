# Obligatoriske felt

Denne siden beskriver mønsteret for å håndtere obligatoriske felt i skjemaer med komponentbiblioteket. Tydelig merking av påkrevde og valgfrie felt hjelper brukeren å forstå hva som må fylles ut for innsending.

## Merking av obligatoriske felt

Bruk `description`-parameteren på `DsField` for å angi om et felt er obligatorisk. Skriv «Obligatorisk» som beskrivelse:

```dart
DsField(
  label: 'Fornavn',
  description: 'Obligatorisk',
  error: _fornavnFeil,
  child: DsTextfield(
    controller: _fornavnController,
    error: _fornavnFeil,
  ),
)
```

Beskrivelsesteksten vises under feltetiketten og gir brukeren en klar indikasjon på at feltet må fylles ut. Bruk alltid beskrivende tekst fremfor symboler som stjerne (*), da tekst er lettere å forstå for alle brukere, inkludert de som bruker hjelpemiddelteknologi.

## Gruppering med DsFieldset

Bruk `DsFieldset` for å gruppere relaterte felt. Dette gir en tydelig visuell struktur og gjør det enklere for brukeren å se hvilke felt som hører sammen:

```dart
DsFieldset(
  legend: 'Personopplysninger',
  children: [
    DsField(
      label: 'Fornavn',
      description: 'Obligatorisk',
      error: _fornavnFeil,
      child: DsTextfield(controller: _fornavnController, error: _fornavnFeil),
    ),
    DsField(
      label: 'Etternavn',
      description: 'Obligatorisk',
      error: _etternavnFeil,
      child: DsTextfield(controller: _etternavnController, error: _etternavnFeil),
    ),
    DsField(
      label: 'Telefon',
      description: 'Valgfritt',
      child: DsTextfield(controller: _telefonController),
    ),
  ],
)
```

I dette eksempelet er fornavn og etternavn merket som «Obligatorisk», mens telefon er merket som «Valgfritt». Når de fleste feltene i et skjema er obligatoriske, er det nyttig å merke de valgfrie feltene eksplisitt slik at brukeren forstår forskjellen.

## Validering av obligatoriske felt

Sjekk om obligatoriske felt er tomme ved innsending, og vis en tydelig feilmelding:

```dart
void _valider() {
  setState(() {
    _fornavnFeil = _fornavnController.text.isEmpty
        ? 'Fornavn er påkrevd'
        : null;
    _etternavnFeil = _etternavnController.text.isEmpty
        ? 'Etternavn er påkrevd'
        : null;
  });
}
```

Kombiner med `DsErrorSummary` for å vise alle feil samlet øverst i skjemaet:

```dart
Column(
  children: [
    if (harFeil)
      DsErrorSummary(
        title: 'Du må fylle ut alle obligatoriske felt:',
        errors: [
          if (_fornavnFeil != null) _fornavnFeil!,
          if (_etternavnFeil != null) _etternavnFeil!,
        ],
      ),
    // ... resten av skjemafeltene
  ],
)
```

## Beste praksis

- **Merk obligatoriske felt med «Obligatorisk» i `description`.** Dette er tydelig og tilgjengelig for alle brukere.
- **Merk valgfrie felt med «Valgfritt» når de fleste feltene er obligatoriske.** Det hjelper brukeren å raskt identifisere hva som kan hoppes over.
- **Ikke bruk stjerne (*) alene for å markere obligatoriske felt.** Stjerner kan overses, og betydningen er ikke alltid klar. Bruk beskrivende tekst i stedet.
- **Gi tydelige feilmeldinger når obligatoriske felt er tomme.** Skriv hva som mangler, for eksempel «Fornavn er påkrevd», fremfor generiske meldinger som «Feltet er obligatorisk».
- **Bruk `DsErrorSummary` når brukeren sender inn et skjema med tomme obligatoriske felt.** Oppsummeringen gir en rask oversikt over alt som må rettes.
