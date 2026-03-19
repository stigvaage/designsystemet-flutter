# komponentbibliotek_flutter

[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.32-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.8-blue.svg)](https://dart.dev)
[![Designsystemet](https://img.shields.io/badge/Designsystemet-designsystemet.no-003087.svg)](https://designsystemet.no)
[![Lisens: MIT](https://img.shields.io/badge/Lisens-MIT-green.svg)](LICENSE)
[![WCAG 2.1 AA](https://img.shields.io/badge/WCAG_2.1-AA-brightgreen.svg)](https://www.w3.org/WAI/WCAG21/quickref/)
[![CI](https://github.com/stigvaage/komponentbibliotek-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/stigvaage/komponentbibliotek-flutter/actions/workflows/ci.yml)

> Flutter implementation of Norway's public design system ([designsystemet.no](https://designsystemet.no)). 40 accessible, token-driven UI components — no Material or Cupertino dependencies.

> **[Les dokumentasjonen](https://stigvaage.github.io/komponentbibliotek-flutter/)** | **[Interaktiv komponentkatalog (Widgetbook)](https://stigvaage.github.io/komponentbibliotek-flutter/widgetbook/)**

Flutter-implementasjon av [Designsystemet](https://designsystemet.no) -- det norske offentlige designsystemet utviklet av Digitaliseringsdirektoratet (Digdir). Biblioteket gir norske offentlige virksomheter og andre organisasjoner et ferdig sett med tilgjengelige, tokendrevne UI-komponenter som følger det offisielle designsystemet -- uten avhengigheter til Material eller Cupertino.

## Funksjoner

- **40 ferdige komponenter** -- knapper, skjemaelementer, navigasjon, typografi og mer
- **Tokendrevet temaarkitektur** -- alle visuelle egenskaper styres gjennom designtokens
- **Innebygd Digdir-tema** -- standard lyst og mørkt tema fra Designsystemet, klart til bruk
- **Egendefinerte temaer** -- importer egne temaer fra Designsystemet CLI via kodegenerator
- **Fargeoverstyring** -- `DsColorScope` for lokal fargeoverstyring i undertreet
- **Størrelsesstyring** -- `DsSizeScope` for lokal størrelsesendring (sm/md/lg)
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

Kjør deretter:

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

Bytt mellom lyst og mørkt modus ved å endre `brightness`-parameteren:

```dart
// Lyst modus (standard)
DsTheme(
  data: DsThemeData.digdir(brightness: Brightness.light),
  child: const MinApp(),
)

// Mørkt modus
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

Bruk `DsColorScope` for å overstyre fargeskalaen i et undertree:

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

## Størrelsesoverstyring

Bruk `DsSizeScope` for å overstyre størrelsen i et undertree:

```dart
// Alle komponenter i dette undertreet bruker stor størrelse
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

Biblioteket inneholder 40 komponenter fordelt på fire kategorier:

### Kjernekomponenter (14)

| Komponent | Beskrivelse |
|-----------|-------------|
| `DsButton` | Knapp med varianter: primary, secondary, tertiary |
| `DsTextfield` | Tekstfelt for enlinjes inndata |
| `DsTextarea` | Tekstområde for flerlinjes inndata |
| `DsCheckbox` | Avkrysningsboks med støtte for ubestemt tilstand |
| `DsRadio` | Radioknapp for enkeltvalg i gruppe |
| `DsSwitch` | Av/på-bryter |
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
| `DsTabs` | Fanenavigasjon med tastaturstøtte |
| `DsDialog` | Dialogvindu (modal) |
| `DsDropdown` | Nedtrekksmeny |
| `DsSelect` | Velger med nedtrekksliste |
| `DsPagination` | Sidenavigasjon |
| `DsTable` | Datatabell |
| `DsBreadcrumbs` | Brødsmulessti |
| `DsSearch` | Søkefelt |
| `DsTooltip` | Verktøyshjelp |
| `DsPopover` | Innholdsboble |
| `DsAvatar` | Avatarbilde |
| `DsAvatarStack` | Stablet gruppe av avatarer |
| `DsToggleGroup` | Vekslegruppe |
| `DsSuggestion` | Forslagskomponent |

### Skjema og verktøy (8)

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
| `DsHeading` | Overskrift med 7 nivåer (2xs--2xl) |
| `DsParagraph` | Brødtekst med varianter: standard, short, long |
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
- **Tastaturnavigasjon** -- full tastaturstøtte med synlige fokusindikatorer
- **Bevegelsesreduksjon** -- respekterer `MediaQuery.disableAnimations`
- **Roving focus** -- fanegrupper, radiogrupper og vekslegrupper bruker roving focus-mønster

## MCP-server for AI-assistenter

Biblioteket inkluderer en MCP-server (Model Context Protocol) som lar AI-kodeassistenter som Claude Code, Cursor og VS Code Copilot slå opp komponenter, migrere fra Material-widgets og søke i dokumentasjonen.

### Installer i Claude Code

Legg til i prosjektets `.mcp.json`:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "node",
      "args": ["<sti-til-repo>/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "<sti-til-repo>"
      }
    }
  }
}
```

### Installer i VS Code (Copilot)

Legg til i `.vscode/mcp.json`:

```json
{
  "servers": {
    "komponentbibliotek": {
      "command": "node",
      "args": ["<sti-til-repo>/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "<sti-til-repo>"
      }
    }
  }
}
```

### Installer i Cursor

Legg til i `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "node",
      "args": ["<sti-til-repo>/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "<sti-til-repo>"
      }
    }
  }
}
```

### Bygg MCP-serveren

```bash
cd mcp-server
npm install
npm run build
```

### Tilgjengelige verktøy

| Verktøy | Beskrivelse |
|---------|-------------|
| `lookup_component` | Slå opp en komponent -- returnerer egenskaper, eksempler og import |
| `list_components` | List alle komponenter, valgfritt filtrert på kategori |
| `get_migration_mapping` | Migrer fra Material-widget til Designsystemet-ekvivalent |
| `get_theme_setup` | Få trinnvis veiledning for temaoppsett |
| `list_tokens` | List designtokens etter kategori (farger, typografi, størrelser m.m.) |
| `search_docs` | Søk på tvers av all dokumentasjon |

Se [mcp-server/README.md](mcp-server/README.md) for full dokumentasjon og Docker-støtte.

## Teknologi og arkitektur

Prosjektet er bygget med flere teknologier og verktøy som samarbeider for å levere et komplett komponentbibliotek med dokumentasjon, interaktiv katalog og AI-integrasjon:

- **Dart 3.8+ / Flutter 3.32+** -- Selve komponentbiblioteket med 40 UI-komponenter, tokendrevet temasystem, kodegenerator og full testdekning. Bygget uten Material- eller Cupertino-avhengigheter — kun `package:flutter/widgets.dart` og `package:flutter/rendering.dart`.
- **Widgetbook 3.x** -- Interaktiv komponentkatalog som lar utviklere utforske, teste og justere alle komponenter med ulike egenskaper, temaer og størrelser. Bygges som en Flutter-webapp og publiseres som en del av dokumentasjonssiden.
- **VitePress 1.6 / Vue 3** -- Dokumentasjonssiden ([stigvaage.github.io/komponentbibliotek-flutter](https://stigvaage.github.io/komponentbibliotek-flutter/)) med 67 norskspråklige sider. Egendefinert tema med Designsystemets fargepalett, komponentfaner (Oversikt/Kode/Tilgjengelighet), innebygd Widgetbook-forhåndsvisning og søk.
- **MCP-server (TypeScript / Node.js)** -- Model Context Protocol-server som lar AI-kodeassistenter som Claude Code, Cursor og VS Code Copilot slå opp komponent-API-er, migrere fra Material-widgets, hente temaoppsett og søke i dokumentasjonen. Bygget med `@modelcontextprotocol/sdk`, `zod` og `minisearch`.
- **GitHub Actions** -- CI/CD-pipeline med automatisk formatsjekk, statisk analyse, testing og publisering til GitHub Pages. Dependabot overvåker avhengigheter for Dart, npm og GitHub Actions.
- **Designsystemet CLI** -- Integrasjon med `@digdir/designsystemet` for import av egendefinerte temaer via W3C DTCG-format designtokens og kodegenerering av Dart-temafiler.

## Bidra

Vi ønsker bidrag velkommen! Se [CONTRIBUTING.md](CONTRIBUTING.md) for retningslinjer.

## Utviklet av

Utviklet av **Stig H. Våge** og **[Claude Code](https://claude.ai/claude-code)**.

Basert på [Designsystemet](https://designsystemet.no) fra [Digitaliseringsdirektoratet](https://www.digdir.no).

## Lisens

Dette prosjektet er lisensiert under MIT-lisensen. Se [LICENSE](LICENSE) for detaljer.
