# komponentbibliotek_flutter

[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.19-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.3-blue.svg)](https://dart.dev)
[![Designsystemet](https://img.shields.io/badge/Designsystemet-designsystemet.no-0062BA.svg)](https://designsystemet.no)
[![Lisens: MIT](https://img.shields.io/badge/Lisens-MIT-green.svg)](LICENSE)
[![WCAG 2.1 AA](https://img.shields.io/badge/WCAG_2.1-AA-brightgreen.svg)](https://www.w3.org/WAI/WCAG21/quickref/)

Flutter-implementasjon av [Designsystemet](https://designsystemet.no) -- det norske offentlige designsystemet utviklet av Digitaliseringsdirektoratet (Digdir).

## Kort beskrivelse

`komponentbibliotek_flutter` er et komplett komponentbibliotek for Flutter som implementerer Designsystemet fra designsystemet.no. Biblioteket gir norske offentlige virksomheter og andre organisasjoner et ferdig sett med tilgjengelige, tokendrevne UI-komponenter som folger det offisielle designsystemet -- uten avhengigheter til Material eller Cupertino.

## Funksjoner

- **40 ferdige komponenter** -- knapper, skjemaelementer, navigasjon, typografi og mer
- **Tokendrevet temaarkitektur** -- alle visuelle egenskaper styres gjennom designtokens
- **Innebygd Digdir-tema** -- standard lyst og morkt tema fra Designsystemet, klart til bruk
- **Egendefinerte temaer** -- importer egne temaer fra Designsystemet CLI via kodegenerator
- **Fargeoverstyring** -- `DsColorScope` for lokal fargeoverstyring i undertreet
- **Storrelsesstyring** -- `DsSizeScope` for lokal storrelsesendring (sm/md/lg)
- **WCAG 2.1 AA** -- alle komponenter oppfyller krav til universell utforming
- **Alle plattformer** -- Android, iOS, Web, macOS, Linux, Windows
- **Ingen Material/Cupertino-avhengigheter** -- rendret direkte med Flutter widgets
- **Inter-font inkludert** -- tre skriftvekter (400, 500, 600) levert som pakkeressurs
- **Tree-shakable** -- ubrukte komponenter fjernes automatisk fra applikasjonspakken

## Installasjon

Legg til pakken i din `pubspec.yaml`:

```yaml
dependencies:
  komponentbibliotek_flutter: ^1.0.0
```

Kjor deretter:

```bash
flutter pub get
```

## Hurtigstart

Pakk inn applikasjonen din med `DsTheme` og bruk Designsystemet-komponenter direkte:

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    DsTheme(
      data: DsThemeData.digdir(), // Innebygd Digdir-tema, lyst modus
      child: const MinApp(),
    ),
  );
}

class MinApp extends StatelessWidget {
  const MinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DsHeading(text: 'Velkommen', level: DsHeadingLevel.lg),
        DsParagraph(text: 'Dette er en app med Designsystemet.'),
        DsButton(
          variant: DsButtonVariant.primary,
          onPressed: () => print('Trykket!'),
          child: Text('Klikk her'),
        ),
      ],
    );
  }
}
```

## Temabytte

Bytt mellom lyst og morkt modus ved a endre `brightness`-parameteren:

```dart
// Lyst modus (standard)
DsTheme(
  data: DsThemeData.digdir(brightness: Brightness.light),
  child: const MinApp(),
)

// Morkt modus
DsTheme(
  data: DsThemeData.digdir(brightness: Brightness.dark),
  child: const MinApp(),
)
```

### Material-integrasjon (valgfritt)

Dersom applikasjonen din allerede bruker `MaterialApp`, kan du integrere via `ThemeExtension`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [DsThemeData.digdir()],
  ),
  home: DsTheme(
    data: DsThemeData.digdir(),
    child: const MinApp(),
  ),
)
```

## Fargestyring

Bruk `DsColorScope` for a overstyre fargeskalaen i et undertree:

```dart
// Alle komponenter i dette undertreet bruker danger-fargeskalaen
DsColorScope(
  color: DsColor.danger,
  child: Column(
    children: [
      DsAlert(
        severity: DsSeverity.danger,
        title: Text('Feil'),
        child: Text('Noe gikk galt.'),
      ),
      DsButton(
        onPressed: () => slett(),
        child: Text('Slett'),
      ),
    ],
  ),
)
```

## Storrelseoverstyring

Bruk `DsSizeScope` for a overstyre storrelsen i et undertree:

```dart
// Alle komponenter i dette undertreet bruker stor storrelse
DsSizeScope(
  size: DsSize.lg,
  child: Column(
    children: [
      DsTextfield(controller: navnController),
      DsButton(
        onPressed: () => send(),
        child: Text('Send inn'),
      ),
    ],
  ),
)
```

## Komponenter

Biblioteket inneholder 40 komponenter fordelt pa fire kategorier:

### Kjernekomponenter (14)

| Komponent | Beskrivelse |
|-----------|-------------|
| `DsButton` | Knapp med varianter: primary, secondary, tertiary |
| `DsTextfield` | Tekstfelt for enlinjes inndata |
| `DsTextarea` | Tekstomrade for flerlinjes inndata |
| `DsCheckbox` | Avkrysningsboks med stotte for ubestemt tilstand |
| `DsRadio` | Radioknapp for enkeltvalg i gruppe |
| `DsSwitch` | Av/pa-bryter |
| `DsAlert` | Varselboks med alvorlighetsgrader: info, warning, success, danger |
| `DsCard` | Kort med valgfri header, innholdsblokk og bunntekst |
| `DsTag` | Etikett for kategorisering |
| `DsChip` | Kompakt element for filtrering eller valg |
| `DsBadge` | Merke for telling eller statusindikasjon |
| `DsSpinner` | Lastindikator |
| `DsDivider` | Skillelinje |
| `DsLink` | Lenke med Designsystemet-styling |

### Navigasjon og layout (14)

| Komponent | Beskrivelse |
|-----------|-------------|
| `DsTabs` | Fanenavigasjon med tastaturstotte |
| `DsDialog` | Dialogvindu (modal) |
| `DsDropdown` | Nedtrekksmeny |
| `DsSelect` | Velger med nedtrekksliste |
| `DsPagination` | Sidenavigasjon |
| `DsTable` | Datatabell |
| `DsBreadcrumbs` | Brodsmulessti |
| `DsSearch` | Sokefelt |
| `DsTooltip` | Verktoyshjelp |
| `DsPopover` | Innholdsboble |
| `DsAvatar` | Avatarbilde |
| `DsAvatarStack` | Stablet gruppe av avatarer |
| `DsToggleGroup` | Vekslegruppe |
| `DsSuggestion` | Forslagskomponent |

### Skjema og verktoy (8)

| Komponent | Beskrivelse |
|-----------|-------------|
| `DsField` | Skjemafelt-wrapper med etikett, beskrivelse og feilmelding |
| `DsFieldset` | Gruppering av relaterte skjemaelementer |
| `DsInput` | Generisk inndatafelt |
| `DsErrorSummary` | Feilsammendrag for skjemavalidering |
| `DsDetails` | Sammenleggbar detaljseksjon |
| `DsList` | Liste med Designsystemet-styling |
| `DsSkeleton` | Plassholder for innhold som lastes |
| `DsSkipLink` | Hopp-til-innhold-lenke for tilgjengelighet |

### Typografi (4)

| Komponent | Beskrivelse |
|-----------|-------------|
| `DsHeading` | Overskrift med 7 nivaer (2xs--2xl) |
| `DsParagraph` | Brodtekst med varianter: standard, short, long |
| `DsLabel` | Etikett for skjemaelementer |
| `DsValidationMessage` | Valideringsmelding for feilvisning |

## Egendefinert tema

Du kan importere egendefinerte temaer fra Designsystemet CLI:

### Steg 1: Generer tokens med Designsystemet CLI

```bash
npx @digdir/designsystemet tokens create --config designsystemet.config.json
```

### Steg 2: Generer Dart-temafil

```bash
dart run komponentbibliotek_flutter:generate \
  --tokens-dir ./design-tokens \
  --output lib/generated/
```

### Steg 3: Bruk det egendefinerte temaet

```dart
import 'package:min_app/generated/ds_theme_mitt_tema.dart';

DsTheme(
  data: DsThemeMittTema.light(),
  child: const MinApp(),
)
```

## Tilgjengelighet

Alle komponenter i biblioteket er bygget med universell utforming som grunnprinsipp:

- **WCAG 2.1 AA** -- alle fargekombinasjoner oppfyller krav til kontrast (4.5:1 for tekst, 3:1 for grensesnittkomponenter)
- **Semantikk** -- alle interaktive elementer har korrekte `Semantics`-widgeter
- **Tastaturnavigasjon** -- full tastaturstotte med synlige fokusindikatorer
- **Bevegelsesreduksjon** -- respekterer `MediaQuery.disableAnimations`
- **Roving focus** -- fanegrupper, radiogrupper og vekslegrupper bruker roving focus-monster

## Bidra

Vi onsker bidrag velkommen! Se [CONTRIBUTING.md](CONTRIBUTING.md) for retningslinjer.

## Lisens

Dette prosjektet er lisensiert under MIT-lisensen. Se [LICENSE](LICENSE) for detaljer.
