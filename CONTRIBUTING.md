# Bidra til komponentbibliotek_flutter

Takk for at du vil bidra til komponentbibliotek_flutter! Denne guiden forklarer hvordan du kan bidra til prosjektet.

## Hvordan bidra

1. **Rapporter feil** -- Opprett en issue med tydelig beskrivelse, steg for a reprodusere, og forventet vs. faktisk oppforsel.
2. **Foreslaa forbedringer** -- Opprett en issue med bakgrunn, motivasjon og eventuelt losningsforslag.
3. **Bidra med kode** -- Fork prosjektet, opprett en feature-branch, og send inn en pull request.

## Utviklingsmiljo

### Forutsetninger

- Flutter 3.19 eller nyere
- Dart 3.3 eller nyere
- Git

### Oppsett

```bash
# Klon prosjektet
git clone https://github.com/user/komponentbibliotek.flutter.git
cd komponentbibliotek.flutter

# Installer avhengigheter
flutter pub get

# Verifiser at alt fungerer
flutter analyze
flutter test
```

### Prosjektstruktur

```text
lib/
  komponentbibliotek_flutter.dart   # Hovedeksport (barrel file)
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

Vi folger [Effective Dart](https://dart.dev/effective-dart)-retningslinjene og bruker `flutter_lints` for statisk analyse.

### Hovedregler

- **Null-sikkerhet**: Alle offentlige API-er skal vaere fullt typet. Bruk `required` for pakrevde parametre.
- **Dart 3.3-funksjoner**: Bruk monstermatching (pattern matching) og forseglede klasser (sealed classes) der det gir klarere kode.
- **Navngivning**: Alle komponentklasser starter med `Ds`-prefiks (f.eks. `DsButton`, `DsAlert`).
- **Dartdoc**: Alle offentlige klasser, metoder og egenskaper skal ha dartdoc-kommentarer med brukseksempler.
- **Ingen hardkodede verdier**: Alle visuelle egenskaper (farger, storrelser, radier, skygger) skal hentes fra designtokens via `DsTheme.of(context)`.
- **Ingen Material/Cupertino**: Komponenter skal ikke avhenge av Material- eller Cupertino-widgeter for visuell rendering. Bruk kun `package:flutter/widgets.dart` og `package:flutter/rendering.dart`.

### Statisk analyse

Kjor analyse for a sjekke at koden folger reglene:

```bash
flutter analyze
```

Malet er null advarsler og null feil.

### Formatering

Bruk Darts offisielle formatter:

```bash
dart format .
```

## Testing

### Testdrevet utvikling (TDD)

Prosjektet folger streng TDD-praksis. Alle endringer skal folge rod-gronn-refaktorer-syklusen:

1. **Rod**: Skriv en test som beskriver forventet oppforsel. Verifiser at testen feiler.
2. **Gronn**: Implementer minimalt med kode for a fa testen til a besta.
3. **Refaktorer**: Forbedre koden mens alle tester fortsatt bestar.

### Widget-tester

Alle komponenter skal ha widget-tester som verifiserer:

- Korrekt rendering med standardverdier
- Alle visuelle tilstander (standard, hover, fokus, aktiv, deaktivert, feil)
- Interaksjon (trykk, tastaturnavigasjon)
- Tilgjengelighet (semantikk, fokuslabeler)
- Korrekt arv av tema, fargeskala og storrelse fra foreldrewidgeter

```dart
testWidgets('DsButton rendrer med primaervariant', (tester) async {
  await tester.pumpWidget(
    DsTheme(
      data: DsThemeData.digdir(),
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

- Alle storrelsesvarianter (sm, md, lg)
- Alle fargevarianter der relevant
- Alle visuelle tilstander (standard, hover, fokus, aktiv, deaktivert)
- Bade lyst og morkt modus

Oppdater gylne filer nar du bevisst endrer visuell utseende:

```bash
flutter test --update-goldens
```

### Kjor tester

```bash
# Kjor alle tester
flutter test

# Kjor tester i en spesifikk fil
flutter test test/components/ds_button_test.dart

# Kjor tester med dekning
flutter test --coverage
```

## Pull requests

### For du sender inn en PR

1. **Opprett en branch** fra `main`:
   ```bash
   git checkout -b feature/din-endring
   ```

2. **Folg TDD**: Skriv tester forst, deretter implementasjon.

3. **Kjor all kvalitetskontroll**:
   ```bash
   flutter analyze    # Ingen advarsler
   flutter test       # Alle tester bestar
   dart format .      # Korrekt formatering
   ```

4. **Skriv tydelige commit-meldinger**: Beskriv hva endringen gjor og hvorfor.

### PR-krav

Alle pull requests blir gjennomgatt for:

- **Designsystemet-troskap**: Komponenter skal matche referanseimplementasjonen pa designsystemet.no visuelt og funksjonelt.
- **Token-bruk**: Alle visuelle egenskaper skal bruke designtokens, ikke hardkodede verdier.
- **Tilgjengelighet**: WCAG 2.1 AA-krav skal vaere oppfylt. Semantikk, fokushandtering og tastaturnavigasjon skal vaere korrekt.
- **Testdekning**: Alle endringer skal ha tilhorende tester (widget-tester og gylne tester).
- **Kodestil**: Koden skal folge Effective Dart og besta `flutter analyze` uten advarsler.
- **Dokumentasjon**: Offentlige API-er skal ha dartdoc-kommentarer.

### PR-sjekkliste

- [ ] Koden bestar `flutter analyze` uten advarsler
- [ ] Alle eksisterende tester bestar
- [ ] Nye tester er skrevet for endringene
- [ ] Gylne tester er oppdatert ved visuelle endringer
- [ ] Dartdoc-kommentarer er lagt til for nye offentlige API-er
- [ ] Commit-meldinger er tydelige og beskrivende
- [ ] PR-beskrivelsen forklarer hva og hvorfor

## Konstitusjon

Prosjektet styres av en konstitusjon som definerer kjerneprinsipper og utviklingsstandarder. Alle bidrag ma folge disse prinsippene:

1. **Designsystemet-troskap** -- Visuell og funksjonell noyaktighet i henhold til designsystemet.no
2. **Tokendrevet arkitektur** -- Ingen hardkodede visuelle verdier
3. **Temaportabilitet** -- Egendefinerte temaer skal fungere uten endring i bibliotekkoden
4. **CLI-forst verktoy** -- Designsystemet CLI brukes for tokengenerering
5. **Flutter-idiomatisk API** -- Folger Flutter-konvensjoner og Effective Dart
6. **Testforst utvikling** -- TDD er ikke-forhandlingsbart
7. **Tilgjengelighetskrav** -- WCAG 2.1 AA er et absolutt minstekrav

Den fullstendige konstitusjonen finnes i `.specify/memory/constitution.md`.

## Lisens

Ved a bidra samtykker du i at dine bidrag vil bli lisensiert under samme MIT-lisens som prosjektet.
