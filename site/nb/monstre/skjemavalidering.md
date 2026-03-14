# Skjemavalidering

Denne siden beskriver mønsteret for skjemavalidering med komponentbiblioteket. Validering bygger på `error`-parameteren som finnes på `DsField` og `DsTextfield`, og gir brukeren tydelig tilbakemelding når noe må rettes.

## Valideringstilnærming

Komponentbiblioteket har ingen innebygd valideringsmotor. I stedet styrer du valideringslogikken selv i state, og sender feilmeldinger inn via `error`-parameteren på `DsField` og `DsTextfield`. Når `error` er `null`, vises feltet i normal tilstand. Når `error` inneholder en streng, vises feltet i feiltilstand med den angitte meldingen.

Denne tilnærmingen gir full fleksibilitet til å integrere med hvilken som helst valideringsløsning — enten det er enkel manuell sjekk, et dedikert valideringsbibliotek, eller serverside-validering.

## Enkelt valideringseksempel

Her er et komplett eksempel med et skjema som har navn- og e-postfelt. Validering kjøres når brukeren trykker «Send inn»:

```dart
class MittSkjema extends StatefulWidget {
  @override
  State<MittSkjema> createState() => _MittSkjemaState();
}

class _MittSkjemaState extends State<MittSkjema> {
  final _navnController = TextEditingController();
  final _epostController = TextEditingController();
  String? _navnFeil;
  String? _epostFeil;

  void _valider() {
    setState(() {
      _navnFeil = _navnController.text.isEmpty ? 'Navn er påkrevd' : null;
      _epostFeil = _epostController.text.contains('@')
          ? null
          : 'Ugyldig e-postadresse';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DsField(
          label: 'Navn',
          error: _navnFeil,
          child: DsTextfield(
            controller: _navnController,
            error: _navnFeil,
          ),
        ),
        DsField(
          label: 'E-post',
          error: _epostFeil,
          child: DsTextfield(
            controller: _epostController,
            error: _epostFeil,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        DsButton(
          variant: DsButtonVariant.primary,
          onPressed: _valider,
          child: Text('Send inn'),
        ),
      ],
    );
  }
}
```

Legg merke til at `error`-verdien sendes til **både** `DsField` og `DsTextfield`. Dette sikrer at feilmeldingen vises under feltet, og at selve tekstfeltet får visuell feiltilstand (rød ramme).

## Feiloppsummering med DsErrorSummary

For skjemaer med mange felt er det god praksis å vise en samlet oversikt over alle feil øverst i skjemaet. Bruk `DsErrorSummary` til dette:

```dart
Column(
  children: [
    if (harFeil)
      DsErrorSummary(
        title: 'Rett følgende feil for å gå videre:',
        errors: [
          if (_navnFeil != null) _navnFeil!,
          if (_epostFeil != null) _epostFeil!,
        ],
      ),
    // ... resten av skjemafeltene
  ],
)
```

`DsErrorSummary` gir brukeren en rask oversikt slik at de ikke trenger å lete gjennom hele skjemaet for å finne hva som mangler. Dette er spesielt nyttig i lange skjemaer der feilfeltene kan være utenfor synlig visningsområde.

## Beste praksis

- **Send alltid samme `error`-verdi til både `DsField` og inputkomponenten.** Dersom de er ulike, vil det oppstå inkonsistens mellom feilmelding og visuell feiltilstand.
- **Bruk `DsErrorSummary` for skjemaer med mange felt.** Det gir brukeren oversikt og gjør det lettere å rette opp i feilene.
- **Valider ved innsending, ikke ved hvert tastetrykk.** Sanntidsvalidering kan forstyrre brukeren mens de skriver. Bruk sanntidsvalidering kun der det er et eksplisitt behov, for eksempel ved sjekk av brukernavn.
- **Skriv tydelige og spesifikke feilmeldinger på norsk.** Unngå tekniske eller generiske meldinger som «Ugyldig verdi». Skriv heller «Navn er påkrevd» eller «E-postadressen må inneholde @».
