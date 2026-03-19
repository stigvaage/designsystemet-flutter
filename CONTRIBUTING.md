# Bidra til designsystemet_flutter

Takk for at du vil bidra til designsystemet_flutter! Denne guiden forklarer hvordan du kan bidra til prosjektet.

## Hvordan bidra

1. **Rapporter feil** -- Opprett en issue med tydelig beskrivelse, steg for å reprodusere, og forventet vs. faktisk oppførsel.
2. **Foreslå forbedringer** -- Opprett en issue med bakgrunn, motivasjon og eventuelt løsningsforslag.
3. **Bidra med kode** -- Fork prosjektet, opprett en feature-branch, og send inn en pull request.

## Utviklingsmiljø

### Forutsetninger

- Flutter 3.32 eller nyere
- Dart 3.8 eller nyere
- Git

### Oppsett

```bash
# Klon prosjektet
git clone https://github.com/stigvaage/designsystemet-flutter.git
cd designsystemet-flutter

# Installer avhengigheter
flutter pub get

# Verifiser at alt fungerer
flutter analyze
flutter test
```

### Prosjektstruktur

```text
lib/
  designsystemet_flutter.dart       # Hovedeksport (barrel file)
  components.dart                    # Alle komponenter
  theme.dart                         # Tema-infrastruktur
  typography.dart                    # Typografi-komponenter
  src/                               # Intern implementasjon
  fonts/                             # Inter TTF-filer
  generated/                         # Genererte temafiler
bin/
  generate.dart                      # Kodegenerator CLI
example/                             # Eksempelapplikasjon
test/                                # Tester
specs/                               # Spesifikasjoner
docs/                                # Dokumentasjon
```

## Kodestil

Vi følger [Effective Dart](https://dart.dev/effective-dart)-retningslinjene og bruker `flutter_lints` for statisk analyse.

### Hovedregler

- **Null-sikkerhet**: Alle offentlige API-er skal være fullt typet. Bruk `required` for påkrevde parametre.
- **Dart 3.3-funksjoner**: Bruk mønstermatching (pattern matching) og forseglede klasser (sealed classes) der det gir klarere kode.
- **Navngivning**: Alle komponentklasser starter med `Ds`-prefiks (f.eks. `DsButton`, `DsAlert`).
- **Dartdoc**: Alle offentlige klasser, metoder og egenskaper skal ha dartdoc-kommentarer med brukseksempler.
- **Ingen hardkodede verdier**: Alle visuelle egenskaper (farger, størrelser, radier, skygger) skal hentes fra designtokens via `DsTheme.of(context)`.
- **Ingen Material/Cupertino**: Komponenter skal ikke avhenge av Material- eller Cupertino-widgeter for visuell rendering. Bruk kun `package:flutter/widgets.dart` og `package:flutter/rendering.dart`.

### Statisk analyse

Kjør analyse for å sjekke at koden følger reglene:

```bash
flutter analyze
```

Målet er null advarsler og null feil.

### Formatering

Bruk Darts offisielle formatter:

```bash
dart format .
```

## Testing

### Testdrevet utvikling (TDD)

Prosjektet følger streng TDD-praksis. Alle endringer skal følge rød-grønn-refaktorer-syklusen:

1. **Rød**: Skriv en test som beskriver forventet oppførsel. Verifiser at testen feiler.
2. **Grønn**: Implementer minimalt med kode for å få testen til å bestå.
3. **Refaktorer**: Forbedre koden mens alle tester fortsatt består.

### Widget-tester

Alle komponenter skal ha widget-tester som verifiserer:

- Korrekt rendering med standardverdier
- Alle visuelle tilstander (standard, hover, fokus, aktiv, deaktivert, feil)
- Interaksjon (trykk, tastaturnavigasjon)
- Tilgjengelighet (semantikk, fokuslabeler)
- Korrekt arv av tema, fargeskala og størrelse fra foreldrewidgeter

```dart
testWidgets('DsButton rendrer med primaervariant', (tester) async {
  await tester.pumpWidget(
    DsTheme(
      data: DsThemeDigdir.light(),
      child: DsButton(
        variant: DsButtonVariant.primary,
        onPressed: () {},
        child: Text('Test'),
      ),
    ),
  );
  expect(find.text('Test'), findsOneWidget);
});
```

### Gylne tester (Golden Tests)

Gylne tester brukes for visuell regresjonstesting. Hver komponent skal ha gylne tester for:

- Alle størrelsesvarianter (sm, md, lg)
- Alle fargevarianter der relevant
- Alle visuelle tilstander (standard, hover, fokus, aktiv, deaktivert)
- Både lyst og mørkt modus

Oppdater gylne filer når du bevisst endrer visuell utseende:

```bash
flutter test --update-goldens
```

### Kjør tester

```bash
# Kjør alle tester
flutter test

# Kjør tester i en spesifikk fil
flutter test test/components/ds_button_test.dart

# Kjør tester med dekning
flutter test --coverage
```

## Pull requests

### Før du sender inn en PR

1. **Opprett en branch** fra `main`:
   ```bash
   git checkout -b feature/din-endring
   ```

2. **Følg TDD**: Skriv tester først, deretter implementasjon.

3. **Kjør all kvalitetskontroll**:
   ```bash
   flutter analyze    # Ingen advarsler
   flutter test       # Alle tester består
   dart format .      # Korrekt formatering
   ```

4. **Skriv tydelige commit-meldinger**: Beskriv hva endringen gjør og hvorfor.

### PR-krav

Alle pull requests blir gjennomgått for:

- **Designsystemet-troskap**: Komponenter skal matche referanseimplementasjonen på designsystemet.no visuelt og funksjonelt.
- **Token-bruk**: Alle visuelle egenskaper skal bruke designtokens, ikke hardkodede verdier.
- **Tilgjengelighet**: WCAG 2.1 AA-krav skal være oppfylt. Semantikk, fokushåndtering og tastaturnavigasjon skal være korrekt.
- **Testdekning**: Alle endringer skal ha tilhørende tester (widget-tester og gylne tester).
- **Kodestil**: Koden skal følge Effective Dart og bestå `flutter analyze` uten advarsler.
- **Dokumentasjon**: Offentlige API-er skal ha dartdoc-kommentarer.

### PR-sjekkliste

- [ ] Koden består `flutter analyze` uten advarsler
- [ ] Alle eksisterende tester består
- [ ] Nye tester er skrevet for endringene
- [ ] Gylne tester er oppdatert ved visuelle endringer
- [ ] Dartdoc-kommentarer er lagt til for nye offentlige API-er
- [ ] Commit-meldinger er tydelige og beskrivende
- [ ] PR-beskrivelsen forklarer hva og hvorfor

## Konstitusjon

Prosjektet styres av en konstitusjon som definerer kjerneprinsipper og utviklingsstandarder. Alle bidrag må følge disse prinsippene:

1. **Designsystemet-troskap** -- Visuell og funksjonell nøyaktighet i henhold til designsystemet.no
2. **Tokendrevet arkitektur** -- Ingen hardkodede visuelle verdier
3. **Temaportabilitet** -- Egendefinerte temaer skal fungere uten endring i bibliotekkoden
4. **CLI-først verktøy** -- Designsystemet CLI brukes for tokengenerering
5. **Flutter-idiomatisk API** -- Følger Flutter-konvensjoner og Effective Dart
6. **Testførst utvikling** -- TDD er ikke-forhandlingsbart
7. **Tilgjengelighetskrav** -- WCAG 2.1 AA er et absolutt minstekrav

Den fullstendige konstitusjonen finnes i `.specify/memory/constitution.md`.

## Lisens

Ved å bidra samtykker du i at dine bidrag vil bli lisensiert under samme MIT-lisens som prosjektet.
