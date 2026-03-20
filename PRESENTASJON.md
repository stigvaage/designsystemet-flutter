# Presentasjonsprompt — Designsystemet Flutter

Bruk følgende prompt i Claude (claude.ai) for å generere en PowerPoint-presentasjon. Kopier alt mellom `---START---` og `---SLUTT---`.

---START---

Lag en profesjonell PowerPoint-presentasjon (PPTX-fil) for prosjektet **Designsystemet Flutter**. Presentasjonen skal være på **norsk** og egnet for en fagpresentasjon for utviklere og designere. Bruk et rent, moderne design med blå aksent (#003087) og hvit bakgrunn, Inter-font hvis tilgjengelig.

## Prosjektsammendrag

**Designsystemet Flutter** er en uoffisiell Flutter-implementasjon av [Designsystemet](https://designsystemet.no) fra Digitaliseringsdirektoratet. Prosjektet ble utviklet på 6 dager (14.–20. mars 2026) av Stig H. Våge med Claude Code som AI-par-programmerer. Det er publisert som åpen kildekode under MIT-lisens.

## Nøkkeltall (bruk disse i slides)

| Metrikk | Verdi |
|---------|-------|
| Komponenter | 40 tokendrevne UI-komponenter |
| Dart-kodelinjer (lib/) | 6 340 |
| Tester | 177 (40 testfiler) |
| pub.dev-poeng | 160/160 (perfekt) |
| API-dokumentasjonsdekning | 96,0 % |
| Plattformer | Android, iOS, Web, macOS, Linux, Windows + WASM |
| VitePress-sider | 67 norskspråklige dokumentasjonssider |
| MCP-verktøy | 6 verktøy + 2 ressurser |
| Migrasjoner | 18 Material→Designsystemet-mappinger |
| Commits | 74 |
| Utviklingstid | 6 dager |
| TypeScript-kode (MCP) | ~64 000 bytes |
| Lisens | MIT |

## Lysbildestruktur (15–18 slides)

### Slide 1: Tittelside
- **Designsystemet Flutter**
- Undertittel: «Uoffisiell Flutter-implementasjon av det norske offentlige designsystemet»
- Utviklet av Stig H. Våge · Mars 2026
- Logo/ikon: Flutter-fugl i Designsystemet-blått

### Slide 2: Hva er Designsystemet?
- Digitaliseringsdirektoratet sitt designsystem for offentlig sektor
- Brukt av Nav, Skatteetaten, Mattilsynet, Brønnøysundregistrene m.fl.
- React/CSS-basert — ingen Flutter-støtte eksisterte
- Lenke: designsystemet.no

### Slide 3: Hvorfor Flutter?
- Kryssplattform: én kodebase → 6 plattformer
- Offentlig sektor trenger mobile apper med konsistent design
- Ingen eksisterende Flutter-implementasjon av Designsystemet
- Mulighet til å vise AI-assistert utvikling i praksis

### Slide 4: Arkitekturoversikt
- **Ingen Material/Cupertino-avhengigheter** — kun `package:flutter/widgets.dart`
- Tokendrevet temasystem: `DsThemeData` → `DsTheme` → `DsColorScope` / `DsSizeScope`
- Alle visuelle egenskaper styrt av designtokens (farger, typografi, størrelser, avrunding, skygger)
- Tree-shakeable importer: `theme.dart`, `components.dart`, `typography.dart`
- Diagramforslag: DsTheme → DsColorScope → DsSizeScope → Komponenttre

### Slide 5: Komponentbiblioteket — 40 komponenter
Kategorisert:
- **Skjema (11):** Input, Textfield, Textarea, Checkbox, Radio, Switch, Select, Dropdown, Field, Fieldset, ErrorSummary
- **Navigasjon (6):** Button, Link, Breadcrumbs, Pagination, SkipLink, Tabs
- **Layout (7):** Card (+Header/Block/Footer), Dialog, Popover, Divider
- **Innhold (8):** Alert, Badge, Tag, Chip, Avatar, AvatarStack, Spinner, Skeleton
- **Interaktive (7):** ToggleGroup, Tooltip, Details, Search, Suggestion, List, Table
- **Typografi (4):** Heading, Paragraph, Label, ValidationMessage
- Alle med Ds-prefiks, dartdoc, og WCAG 2.1 AA-tilgjengelighet

### Slide 6: Temasystemet
- Fargeskalaer: accent, neutral, brand1–3, success, danger, warning, info (16 tokens per skala)
- Typografi: Inter-font, 400/500/600 vekt, forhåndsdefinerte stiler (headingXxl–bodyXs)
- Størrelser: sm/md/lg-modus med base+step-beregning
- Avrunding: sm, md, lg, xl, full
- Skygger: xs, sm, md, lg, xl
- Egendefinerte temaer via kodegenerator (`dart run designsystemet_flutter:generate`)

### Slide 7: Tilgjengelighet — WCAG 2.1 AA
- Semantikk: `Semantics`-widgets på alle interaktive komponenter
- Tastaturnavigasjon: Enter/Space-aktivering, Escape for å lukke, Tab-navigasjon
- Fokusindikatorer: synlige fokusringer med `DsFocus.focusRingWithRadius`
- Fargekontrast: 4.5:1 tekst, 3:1 grensesnitt
- Bevegelse: `MediaQuery.disableAnimations` respektert
- Skjermleser: liveRegion på Alert, scopesRoute/namesRoute på Dialog, norske semantiske etiketter

### Slide 8: Kodekvalitet
- **pub.dev: 160/160 poeng** (perfekt score)
- 96 % API-dokumentasjonsdekning (dartdoc)
- 177 tester (enhet, widget, semantikk, tastatur)
- Streng analyse: strict-casts, strict-inference, strict-raw-types
- `flutter_lints` med null-sikkerhet
- 0 feil, 0 advarsler i analyse
- CI via GitHub Actions (format, analyse, test)

### Slide 9: Testdekning
- 40 testfiler dekker alle komponentkategorier
- Testtyper:
  - Rendering: verifiserer at komponenter vises korrekt
  - Callbacks: verifiserer at onTap/onChanged/onClose utløses
  - Semantikk: verifiserer ARIA-egenskaper (isButton, isLink, isExpanded, liveRegion)
  - Tastatur: verifiserer Enter/Space/Escape-håndtering
  - Tilstand: verifiserer disabled-opacity, selected-styling, error-border
- Fra 88 → 177 tester på én arbeidsøkt

### Slide 10: Dokumentasjonsside (VitePress)
- 67 norskspråklige sider på GitHub Pages
- Struktur: Intro → Kom i gang → Komponenter → Mønstre → God praksis
- Komponentdokumentasjon med tre faner: Oversikt / Kode / Tilgjengelighet
- Innebygd Widgetbook-forhåndsvisning (iframe-embed)
- Lokalt søk med norske oversettelser
- Designsystemet-inspirert visuelt tema (Digdir-blå, Inter-font)
- Open Graph-metadata for deling i sosiale medier
- Redirects for bakoverkompatibilitet (28 gamle URL-er)
- Responsivt design med mørk modus-støtte
- Lenke: stigvaage.github.io/designsystemet-flutter/

### Slide 11: Widgetbook — Interaktiv komponentkatalog
- Flutter web-app integrert i dokumentasjonssiden
- Alle 40 komponenter med justerbare egenskaper (knobs)
- 3 globale addons: Tema (lys/mørk), Fargeskop, Størrelsesskop
- Interaktive StatefulWidget-forhåndsvisninger (checkbox, switch, dropdown, pagination m.fl.)
- Direkte lenke fra hver komponentside
- Lenke: stigvaage.github.io/designsystemet-flutter/widgetbook/

### Slide 12: MCP-server — AI-integrasjon
- Model Context Protocol-server for AI-kodeassistenter (Claude, Cursor, VS Code)
- **6 verktøy:**
  1. `lookup_component` — Slå opp komponent-API med egenskaper, eksempler og import
  2. `list_components` — List komponenter, filtrer etter kategori
  3. `get_migration_mapping` — Material→Designsystemet-migrering (18 widgets)
  4. `get_theme_setup` — Steg-for-steg temaoppsett
  5. `list_tokens` — Vis designtokens (farger, typografi, størrelser, skygger, ikoner)
  6. `search_docs` — Fulltekstsøk i dokumentasjon (MiniSearch, fuzzy matching)
- **2 ressurser:**
  1. `component:///` — Direkte tilgang til Dart-kildekode
  2. `docs:///` — Direkte tilgang til markdown-dokumentasjon
- TypeScript med zod-validering og @modelcontextprotocol/sdk

### Slide 13: Material-migrering
- 18 forhåndsdefinerte migreringsmappinger fra Material/Cupertino → Designsystemet
- Eksempler:
  - `ElevatedButton` → `DsButton(variant: .primary)`
  - `TextField` → `DsTextfield`
  - `AlertDialog` → `DsDialog`
  - `Checkbox` → `DsCheckbox`
  - `DropdownButton` → `DsSelect`
- Egenskap-for-egenskap-mapping med før/etter-kodeeksempler
- Tilgjengelig via MCP-verktøy eller dokumentasjonsside

### Slide 14: Utviklingsprosess — AI-assistert
- 6 dagers intensiv utvikling (14.–20. mars 2026)
- Claude Code som AI-par-programmerer (Claude Opus 4.6)
- 74 commits, ~6 340 linjer Dart + ~64 000 bytes TypeScript
- Arbeidsflyt: planlegging → implementering → testing → dokumentasjon → publisering
- AI bidro til: komponentkode, tester, dokumentasjon, VitePress-oppsett, MCP-server
- Mennesket bidro til: arkitekturbeslutninger, kvalitetssikring, designvalg, publisering

### Slide 15: Teknologistabel
| Lag | Teknologi | Versjon |
|-----|-----------|---------|
| Komponentbibliotek | Dart / Flutter | 3.8+ / 3.32+ |
| MCP-server | TypeScript / Node.js | 5.x / 18+ |
| Dokumentasjon | VitePress / Vue 3 | 1.6 / 3.5 |
| Komponentkatalog | Widgetbook | 3.x |
| CI/CD | GitHub Actions | - |
| Hosting | GitHub Pages | - |
| Pakkeregister | pub.dev | - |

### Slide 16: Demo / Live visning
- Vis dokumentasjonssiden: stigvaage.github.io/designsystemet-flutter/
- Vis en komponentside med innebygd Widgetbook
- Vis pub.dev-pakken: pub.dev/packages/designsystemet_flutter
- Vis MCP-serveren i aksjon (Claude Code med komponentoppslag)
- Vis GitHub-repoet: github.com/stigvaage/designsystemet-flutter

### Slide 17: Veien videre
- Verifisert utgiver på pub.dev
- Flere tester og gylne filer (golden tests)
- Figma-integrasjon for design-til-kode
- Flere mønstre og eksempelapper
- Bidrag fra fellesskapet
- Potensielt offisiell adopsjon av Digitaliseringsdirektoratet

### Slide 18: Oppsummering og lenker
- **pub.dev:** pub.dev/packages/designsystemet_flutter (160/160 poeng)
- **GitHub:** github.com/stigvaage/designsystemet-flutter
- **Dokumentasjon:** stigvaage.github.io/designsystemet-flutter/
- **Widgetbook:** stigvaage.github.io/designsystemet-flutter/widgetbook/
- **Designsystemet:** designsystemet.no
- MIT-lisens · Åpen kildekode · Bidrag velkomne

## Designretningslinjer for presentasjonen

- **Farger:** Primær #003087 (Designsystemet-blå), sekundær #3D85C0, bakgrunn hvit/lysgrå
- **Font:** Inter (eller fallback: Segoe UI, Calibri)
- **Stil:** Minimalistisk, mye luft, tydelig hierarki — inspirer av designsystemet.no
- **Kodesnutter:** Bruk monospace-font i lyse kodebokser med syntaksutheving
- **Diagrammer:** Enkle boksdiagrammer for arkitektur, ingen komplekse illustrasjoner
- **Ikoner:** Bruk enkle emoji eller Lucide-ikoner der det passer
- **Språk:** Alt på norsk, unntatt tekniske termer (Flutter, Dart, WCAG, MCP, etc.)

---SLUTT---
