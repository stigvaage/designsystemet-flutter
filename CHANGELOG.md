# Endringslogg

## 0.2.1

- **Fiks:** Trykk hvor som helst i tekstfelt/textarea-rammen gir fokus og viser tastatur
- **Fiks:** Korrekt pakkeversjonsreferanse i dokumentasjon (`^0.2.0`, ikke `^1.0.0`)
- **Fiks:** Oppdatert minimumskrav i dokumentasjon (Flutter 3.32+, Dart 3.8+)
- **Ny:** 89 nye tester (177 totalt) for 18 komponenter som manglet testdekning
- **Ny:** Open Graph- og Twitter Card-metadata for deling i sosiale medier
- **Ny:** Interaktive Widgetbook-forhåndsvisninger med ekte tilstandshåndtering
- **Ny:** Innebygd Widgetbook-iframe i komponentdokumentasjonen
- **Ny:** Norske oversettelser for alle gjenværende VitePress-grensesnittelementer

## 0.2.0

- **Rebrand:** Pakken er omdøpt fra `komponentbibliotek_flutter` til `designsystemet_flutter`
- Alle importer oppdatert: `package:designsystemet_flutter/...`
- MCP-server omdøpt til `@stigvaage/designsystemet-flutter-mcp`
- Dokumentasjon og CI/CD oppdatert med nytt navn
- Dartdoc lagt til på 15 sentrale klasser (tema, knapp, varsel, skjemaelementer m.m.)
- Migrert tester fra avviklet `hasFlag` til ny `flagsCollection`-API
- Fjernet `DsThemeData.digdir()` og `DsThemeData.fromTokens()` (bruk `DsThemeDigdir.light()`/`.dark()`)
- Rettet README-eksempler til å bruke korrekt `DsThemeDigdir`-API

## 0.1.0

- Første utgivelse
- 40 UI-komponenter etter Designsystemet-spesifikasjonene
- Tokendrevet temasystem med innebygd Digdir-tema (lyst/mørkt)
- Kodegenerator for egendefinerte temaer
- WCAG 2.1 AA-kompatibilitet
- MCP-server for AI-kodeassistenter
- VitePress-dokumentasjonsside og Widgetbook-katalog
