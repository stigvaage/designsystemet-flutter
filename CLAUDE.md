# designsystemet_flutter — Utviklingsretningslinjer

Uoffisiell Flutter-implementasjon av [Designsystemet](https://designsystemet.no) fra Digitaliseringsdirektoratet. Utviklet av Stig H. Våge.

## Teknologi

- **Dart 3.8+ / Flutter 3.32+** — Komponentbiblioteket (40 komponenter, tokendrevet tema, ingen Material/Cupertino-avhengigheter)
- **TypeScript 5.x / Node.js 18+** — MCP-server (`@modelcontextprotocol/sdk`, `zod`, `minisearch`)
- **VitePress 1.6 / Vue 3** — Dokumentasjonsside (67 norskspråklige sider)
- **Widgetbook 3.x** — Interaktiv komponentkatalog
- **GitHub Actions** — CI (format, analyse, test) + deploy til GitHub Pages

## Prosjektstruktur

```
lib/                    # Hovedbiblioteket
  src/components/       # 40 komponentmapper (ds_button, ds_alert, ...)
  src/theme/            # Temasystem (DsTheme, DsThemeData, tokens)
  src/typography/       # Typografikomponenter
  src/generator/        # Kodegenerator for egendefinerte temaer
  src/utils/            # Verktøy (enums, ikoner, fokus, animasjon)
  generated/            # Genererte temafiler (DsThemeDigdir)
  fonts/                # Inter TTF-filer (400, 500, 600)
widgetbook/             # Widgetbook-app (Flutter web)
site/                   # VitePress-dokumentasjonsside
  nb/                   # Norske markdown-sider
  .vitepress/           # Config og egendefinert tema
mcp-server/             # MCP-server (TypeScript)
  src/tools/            # 6 MCP-verktøy
  src/resources/        # 2 ressursbehandlere
  src/parsers/          # Dart-, markdown-, tokenparsere
example/                # Eksempelapp
test/                   # Dart-tester (widget, tema, tilgjengelighet)
```

## Kommandoer

```bash
# Formater
dart format .

# Analyse
flutter analyze --no-fatal-infos

# Test
flutter test

# Widgetbook
cd widgetbook && flutter pub get && flutter build web

# Dokumentasjonsside
cd site && npm ci && npm run build

# MCP-server
cd mcp-server && npm install && npm run build
```

## Kodestil

- **Ds-prefiks** på alle offentlige klasser (`DsButton`, `DsAlert`, `DsThemeData`)
- **Ingen hardkodede verdier** — alle visuelle egenskaper via `DsTheme.of(context)`
- **Ingen Material/Cupertino** — kun `package:flutter/widgets.dart` og `rendering.dart`
- **Null-sikkerhet** — bruk `required` for påkrevde parametre
- **Dartdoc** på alle offentlige API-er
- Følg `flutter_lints` og `analysis_options.yaml` (strict-casts, strict-inference, strict-raw-types)

## Språk

All brukersynlig tekst (README, dokumentasjon, issue-maler, SECURITY.md, pubspec-beskrivelser) skal være på **norsk** med korrekt bruk av **æ, ø, å**. Teknisk kode og identifikatorer forblir på engelsk.

## Tilgjengelighet

Alle komponenter skal oppfylle **WCAG 2.1 AA**: riktig semantikk, tastaturnavigasjon, fokusindikatorer, fargekontrast (4.5:1 tekst, 3:1 grensesnitt), og respektere `MediaQuery.disableAnimations`.

## MCP-server

Prosjektet inkluderer en MCP-server i `mcp-server/` som eksponerer komponent-API-er, migreringsmappinger, tokens og dokumentasjon for AI-kodeassistenter. Se `.mcp.json` for konfigurasjon.
