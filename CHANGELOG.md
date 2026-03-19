# Endringslogg

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
