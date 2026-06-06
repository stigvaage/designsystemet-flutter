# Endringslogg

## 0.3.0 — 2026-06-06

Stor paritetsoppdatering mot Designsystemet (React-referanse v1.15.0). Standardtemaet
bruker mørkeblå `#003087` som accent-base (WCAG 2.1 AA, verifisert med ny
kontrasttest). (Først utgitt som forhåndsutgivelse `0.3.0-beta.1`.)

### Brytende endringer

- **`DsSuggestion`** bygd om fra streng-liste til ekte combobox `DsSuggestion<T>`
  (`options`/`onSelectedChanged`, type-ahead-filtrering, `multiple`, `creatable`,
  tomtilstand, tastaturnavigasjon). Erstatter `items`/`onSelected`.
- **`DsSelect`** bygd om til generisk `DsSelect<T>` med `DsSelectOption<T>` /
  `DsSelectOptgroup<T>` og value-basert `onChanged`. Erstatter `items`/`selectedIndex`.

### Nytt

- **Varianter (React-paritet):** `outline` på Tag/Switch/Checkbox/Radio, `tinted` på
  Card/Details, `primary/secondary` på ToggleGroup, `circle/square` på Avatar.
- **Popover:** 12 `DsPlacement`-posisjoner, `autoPlacement`, controlled `open` +
  `onOpen`/`onClose`, `tinted`-variant.
- **Table:** sticky header (sliver-basert), sorterbare kolonner (`DsSortDirection`),
  `caption`, `footerRows`, klikkbare rader (`onRowTap`), `border`-flagg.
- **Pagination:** ellipse for store sideområder (offisiell `getSteps`-algoritme).
- **Tooltip:** vises ved tastaturfokus (ikke bare hover) + `placement`.
- **Tilgjengelighet:** Divider `aria-hidden`, Spinner `ariaLabel`, Breadcrumbs
  `aria-current`/`ariaLabel`.
- **Chip:** navngitte konstruktører `DsChip.button/.removable/.checkbox/.radio`.
- **Search:** `clearable` clear-knapp + `onClear`/`onSubmit`.
- **Nye enums:** `DsCardVariant`, `DsDetailsVariant`, `DsToggleGroupVariant`,
  `DsSelectionVariant`, `DsAvatarVariant`, `DsPlacement`, `DsPopoverVariant`,
  `DsSortDirection`.
- **WCAG-kontrasttest** for hele temaet, og `#003087` dokumentert i README + site.

### Fikser

- Checkbox/Radio/Switch toggler nå ved trykk hvor som helst i kontrollen (inkl. label
  og `outline`-padding/border-sonen), ikke bare på selve ikonet.
- `DsInput`/`DsTextarea`: tastatur på første trykk; `ensureVisible` bruker
  `keepVisibleAtStart` + respekterer redusert bevegelse + hopper over read-only.
- Lukket 17 funn fra ultrakritisk code review (dekker PR #32).

### Robusthet og forbedringer

Lukket alle 59 funn fra en intern forbedringsgjennomgang, alle vurdert mot offisiell
Designsystemet-troskap:

- **Delte hjelpere (DRY):** `DsFocus.reserveRing`/`reserveRingCircle` (alltid-reservert
  fokusring, samlet fra ~13 komponenter), `DsSize.pick` + `DsSizeValues.fontSize`,
  `DsControlLabel` (kontroll+label+beskrivelse), `DsSpinner.paintColor`.
- **Skjemakontroller:** Checkbox/Radio fikk faktisk `error`-tilstand (danger-skala +
  feilmelding + a11y) — feltet var tidligere død kode; `disabled` skilt fra `readOnly`
  på Checkbox/Radio/Switch; hover respekterer `readOnly`; `autofocus` lagt til.
- **Knapp:** `onPressed == null` regnes som deaktivert; loading-spinner er nå synlig på
  alle varianter (forgrunnsfarge); «Laster» annonseres for skjermlesere.
- **Fokus/tastatur:** synlig fokusring og tastaturbetjening på Select-trigger,
  ErrorSummary-lenker og Alert-lukkeknapp; Switch hopper ikke lenger i layout ved fokus;
  Dropdown fikk pil/Enter-navigasjon; ToggleGroup fikk Home/End; `focusNode` eksponert på
  flere komponenter.
- **Overlays:** Select/Suggestion klamrer høyde mot tastatur og vipper opp ved behov;
  highlightet rad scrolles inn i synsfeltet; Dropdown rydder overlay uten `setState`.
- **Norsk tekst:** Search defaulter til «Søk...»; ErrorSummary-tittel og Select/Suggestion-
  etiketter er norske og overstyrbare.
- **Tema-ytelse:** verdibasert `==`/`hashCode` på `DsThemeData` m.fl. (unngår unødvendige
  rebuilds), farge-/skygge-`lerp`, og cachede `DsThemeDigdir.light()/dark()`.
- **Diverse:** Skeleton bruker `dart:math.sin` (riktig shimmer), AvatarStack kobler `size`
  til dimensjon + «+N»-overflyt + gruppe-semantikk, ikke-interaktivt Card kortslutter
  uten animasjon.

### Ultra-kritisk gjennomgang av hele repoet

Kjørte en altomfattende, adversarielt verifisert review av HELE repoet (25 lenser,
344 rå funn → 302 bekreftet) og lukket alle bekreftede funn:

- **KRITISK — Material fjernet:** `DsInput` var bygget på Material `TextField`; reimplementert
  på `EditableText` (kun `package:flutter/widgets.dart`). Hele tekst-overflaten (Textfield/
  Textarea/Search/Suggestion/Select) er nå fri for Material/Cupertino i `lib/` (eneste unntak:
  `show ThemeExtension` for valgfri Material-integrasjon).
- **Typografi-troskap:** font-størrelse-skalaen var ett offisielt trinn for liten — rettet til
  Designsystemets primitiv-tokens (overskrift 60/48/36/30/24/21/18, brødtekst 24/21/18/16/14).
- **Tilgjengelighet:** 44×44 tap-mål, live-region feilmeldinger, fokusring + tastaturbetjening
  og korrekte `SemanticsRole` (meny/liste/listItem) på tvers.
- **Dokumentasjon/MCP/site:** kompilerende kodeeksempler, korrekte standardtitler, selvhostet
  Inter (ikke render-blokkerende Google Fonts), MCP-data og -parser oppdatert, widgetbook-knotter.

**Bevisst utsatt (dokumentert, lav/medium risiko):**
- Dedikerte fokus-tokens (`focusOuter`/`focusInner`) i fargeskalaen — krever en strukturell
  token-/generator-endring; dagens fokusring bruker `borderStrong` og oppfyller WCAG-kontrast.
- Eget scrim-/overlay-token for `DsDialog`-barrieren — barrierfargen er allerede token-avledet.
- Semantiske info/suksess-basefarger: hvit tekst på `base` (info ≈3,77:1, suksess ≈4,35:1)
  er under 4,5:1 AA for normal tekst. Korrekt fiks krever regenerering av de semantiske
  skalaene fra offisielle tokens (Track C) for ikke å gjette farger og bryte troskap;
  kontrasttesten beholder inntil videre et 3:1-gulv for disse to skalaene med dokumentert
  begrunnelse.

### Tester

- 202 → 657 Dart-tester. `flutter analyze` uten merknader; MCP-server 16 tester grønne.

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
