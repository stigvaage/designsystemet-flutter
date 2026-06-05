# Oppgaver — Komplett Flutter-versjon av Designsystemet

Avledet fra plan: full API-paritet med Designsystemet (React-referanse `digdir/designsystemet` **v1.15.0**), regenerert fargetema fra Helse Vest mørkeblå **#003087**, oppdatert README, komplett VitePress-site og 100 % fungerende MCP-server.

**Branch:** `oppdater-komponentbiblioteket-iht-designsystemet`
**Status-symboler:** `[ ]` ikke startet · `[~]` pågår · `[x]` ferdig

**Akseptkriterier (gjelder alle kode-oppgaver):** `flutter analyze --no-fatal-infos` rent · `dart format` rent · `flutter test` grønt · dartdoc på alle offentlige API-er · ingen hardkodede visuelle verdier (alt via `DsTheme.of(context)`) · WCAG 2.1 AA.

---

## STATUS (sluttført på branchen)

**Levert og verifisert:** `flutter analyze` = 0 issues, **644 tester grønne**, `dart format` rent (CI-gate), MCP `npm run build` + 16 tester grønne. Versjon **0.3.0** (pubspec ↔ mcp), CHANGELOG oppdatert.

- ✅ **Track 0** — variant-enums (mot v1.15.0-kilde) + `DsPlacement`/`DsSortDirection`; `DsCard.block/.header/.footer` compound-aliaser. *(Avgrensning: `DsSize` beholdt sm/md/lg = React `data-size`.)*
- ✅ **Track A** — varianter (outline/tinted/circle-square/primary-secondary) + a11y (aria-current, aria-hidden, ariaLabel, tooltip-fokus) + tap-target-fikser.
- ✅ **Track B** — Popover, **Suggestion (combobox)**, Table (sticky/sort/foot), Pagination (ellipse), Search, **Select<T>**, Chip-varianter.
- ✅ **Track C3** — WCAG-kontrasttest (accent #003087 verifisert AA).
- ✅ **Track D3/D4** — README + site (#003087 + manglende mønstre). **D5** — MCP versjon-synk + #003087 + dart-parser dartdoc. **D6** — 0.3.0 + CHANGELOG + CI-format-gate. **D1/D2** — alle 40 komponenter har test + Widgetbook-story.
- ✅ **Track E** — alle 28 funn fra ultrakritisk adversarisk review lukket + regresjonstester.

### Gjenstående (bevisst avgrenset oppfølging)
- **T0.4 verdi-basert seleksjon for Tabs/ToggleGroup** (`<T>` + deprecated indeks-shims). Select er allerede `<T>`; Tabs/ToggleGroup bruker fungerende indeks-API — utsatt for å ikke bryte arbeidende komponenter uten klar gevinst.
- **C1/C2 full token-regenerering fra #003087 via offisiell algoritme** (reproduserbar DTCG). Accent ER #003087 og oppfyller WCAG AA (verifisert). Funn fra C3: `success` (4.35:1) og `info` (3.77:1) hvit-på-base ligger like under 4.5 — løses presist av algoritme-regenerering.

---

## Track 0 — Fundament (låser opp alt)
- [ ] **T0.1** Utvid `lib/src/utils/ds_enums.dart`: `DsCardVariant`, `DsDetailsVariant`, `DsToggleGroupVariant`, `DsAvatarVariant`, `DsDialogModality`, `DsPlacement` (12 verdier), `DsSelectionVariant {default_, outline}`, `DsSortDirection`, `DsComboboxMode`.
- [ ] **T0.2** Legg `xs` + `xl` til `DsSize`; oppdater alle 17 uttømmende `switch (size)` (avatar, badge, button, checkbox, chip, input, pagination, radio, select, spinner, switch, table, tabs, tag, toggle_group, label, size_scope). Test-sikret.
- [ ] **T0.3** Kodifiser compound-mønster (statisk fabrikk + privat `_DsXScope extends InheritedWidget`) med `DsCard` som referanse; notat i `CONTRIBUTING.md`.
- [ ] **T0.4** Generisk verdi-basert seleksjon: `DsTab<T>`, `DsToggleGroupOption<T>`, `DsSelectOption<T>` med `value`/`defaultValue`/`onValueChange`; `@Deprecated` indeks-shims gjennom 1.x.

## Track A — Variant/farge/størrelse-sveip (parallelt etter Track 0)
Kopier `DsButton`-malen (eksplisitt prop `?? Scope.of(context)` → `colorScheme.resolve` → variant-switch).
- [ ] **A1** `outline`-variant (`DsSelectionVariant`): Tag, Switch, Checkbox, Radio
- [ ] **A2** `tinted`-variant: Card (`DsCardVariant`, deprecér `elevated`-bool), Details (`DsDetailsVariant`)
- [ ] **A3** Avatar: `DsAvatarVariant {circle, square}` + `xs`-størrelse
- [ ] **A4** Button: `fullWidth`
- [ ] **A5** Dialog: `DsDialogModality {modal, nonModal}` + `DsPlacement`
- [ ] **A6** ToggleGroup: `DsToggleGroupVariant {primary, secondary}` + verdi-API
- [ ] **A7** Alert: eksplisitt `size` + `role`/`aria-live`-semantikk
- [ ] **A8** Breadcrumbs: `aria-current=page`, konfigurerbar separator, default norsk aria-label
- [ ] **A9** Link: `href`/ekstern-lenke-markering ved siden av `onTap`
- [ ] **A10** Divider: `aria-hidden` (default true); Spinner: `ariaLabel`-param; Skeleton: size-tokens
- [ ] **A11** Alle øvrige P2-poleringer (se per-komponent-tabell)

## Track B — Tunge ombygginger (parallelle, avhenger kun av Track 0)
- [ ] **B1 Popover** — `DsPlacement`-mapping, autoPlacement (overflow-flip), controlled `open`/`onOpenChange`, `DsPopover.trigger` + `DsPopoverTriggerContext`, `tinted`-variant, Escape/fokus-retur.
- [ ] **B2 Suggestion (combobox)** — `DsSuggestion<T>`: overlay (gjenbruk dropdown), synkron filtrering, `single/multiple`, `creatable`, tastatur (pil/Enter/Esc/Backspace), chips, slots `.input/.list/.option/.empty/.clear` via `_DsSuggestionScope`, ARIA + live-region.
- [ ] **B3 Table** — `CustomScrollView` + `SliverPersistentHeader(pinned: stickyHeader)`, delte kolonnebredder via `_DsTableScope`, sorterbar `DsTableHeaderCell(sortKey)` + `DsSortState`, `caption`, `DsTableFoot`, `onRowTap`, compound `DsTable.builder`.
- [ ] **B4 Pagination** — ren `buildRange({current,total,siblingCount,boundaryCount})` + ellipse, compound `.list/.item/.button`.
- [ ] **B5 Search/Select** — Search.Input/Button/Clear (+ clear-knapp), Select.Option/Optgroup (+ objekter), Chip-varianter (radio/checkbox/button/removable).

## Track C — Tokens (uavhengig, kan starte dag 1)
- [ ] **C1** Generer Helse Vest DTCG-tokens (accent #003087) via `@digdir/designsystemet` CLI; commit `design-tokens/`.
- [ ] **C2** Regenerer `lib/generated/ds_theme_digdir.dart` via `dart run designsystemet_flutter:generate`; golden-snapshot av verdier.
- [ ] **C3** `test/theme/contrast_test.dart`: WCAG-kontrast (4.5:1 tekst, 3:1 grensesnitt) over alle 9 skalaer × lys/mørk.
- [ ] **C4** Juster mørk-modus-skygger mot offisiell veiledning (lyse kanter i stedet for skygger).
- [ ] **C5** (valgfri) Port OKLCH/HSLuv-algoritmen til Dart for `:generate --base-color`.

## Track D — Overflater (følger komponent-PR-ene)
- [ ] **D1** Widget-tester for hver ny variant/prop + manglende: checkbox, radio, switch, textfield, textarea, search, spinner, table, tabs, toggle_group, validation_message.
- [ ] **D2** Widgetbook-stories for manglende: alert, avatar_stack, divider, dropdown, list, search, suggestion, field, heading, label, paragraph, validation_message.
- [ ] **D3** README: fiks versjon (`^0.2.0`→ny), Helse Vest #003087-seksjon, lenke til `mcp-server/README.md`, paritet-/komponent-tabell, badges.
- [ ] **D4** VitePress-site: «egendefinert tema»-side (#003087-eksempel), manglende mønstre (`knappplassering`, `samtykkebanner`, `eksterne-lenker`, `representasjon`), oppdater komponentsider, verifiser build + Pages-deploy.
- [ ] **D5** MCP-server 100 %: versjon-synk; fullfør `migrations.json` (alle 40 + Material/Cupertino + Ds-1.x→2.0); `dart-parser.ts` henter enum-verdier + dartdoc; `theme-setup.md` (versjon + #003087 + token-arbeidsflyt); `list_tokens` reflekterer regenererte tokens; tester for alle 6 verktøy; `npm build`+`test` grønt.
- [ ] **D6** Release/CI: versjonsbump (pubspec ↔ mcp `package.json`), `CHANGELOG.md`, grønn CI, Pages-deploy, MCP-publish. 2.0-brytende fjerning av indeks-API/bool-varianter samlet til slutt.

## Track E — Ultrakritisk code review (etter paritet-arbeidet)
- [ ] **E1** Dyp multi-agent review av alle komponenter for «rusk»/bugs i klasse med dobbelttapp-tastatur-bugen: gesture-/fokus-konflikter, element-teardown ved fokus/tilstandsbytte, manglende `dispose`, race conditions i overlay/postframe, layout-jump, hardkodede verdier, a11y-hull (fokusrekkefølge, semantikk, tastatur).
- [ ] **E2** Adversarisk verifisering av hvert funn (uavhengige skeptikere) → fiks bekreftede funn → tester.

---

## Per-komponent paritet (mål: alle → ~100 %)

| Komponent | Score | Hovedgap → oppgave |
|---|---|---|
| suggestion | 25 | full combobox-ombygging → B2 |
| popover | 42 | placement/controlled/composition → B1 |
| search | 52 | clear/submit/subkomponenter → B5 |
| chip | 55 | radio/checkbox/button/removable-varianter → B5 |
| select | 55 | Option/Optgroup + objekter → B5 |
| pagination | 58 | ellipse + compound → B4 |
| radio | 62 | name/value + outline → A1/T0.4 |
| dialog | 65 | modality + placement + Block → A5 |
| avatar | 65 | square + xs → A3 |
| table | 65 | sticky header (ikke impl!) + sort/caption/foot → B3 |
| tooltip | 65 | tastatur + placement → A11 |
| list | 68 | Item/Ordered/Unordered → A11 |
| card | 70 | tinted-variant + asChild → A2 |
| avatar-stack | 70 | size-skalering → A11 |
| textfield | 70 | label/description/counter-komposisjon → A11 |
| field | 72 | Counter/Affixes → A11 |
| link | 72 | href + ekstern → A9 |
| error-summary | 75 | List/Item/Link + felt-lenking → A11 |
| breadcrumbs | 78 | aria-current + separator → A8 |
| fieldset | 78 | Legend/Description → A11 |
| spinner | 78 | ariaLabel-param → A10 |
| tag | 80 | outline → A1 |
| toggle-group | 80 | variant + verdi → A6 |
| alert | 82 | size + role → A7 |
| details | 82 | tinted → A2 |
| skip-link | 82 | href → A11 |
| checkbox | 85 | outline → A1 |
| dropdown | 85 | dokumentér theme-scope-workaround → A11 |
| input | 85 | ✅ tastatur-fix hentet inn; HTML-input-typer → A11 |
| skeleton | 85 | size-tokens → A10 |
| textarea | 85 | size-arv → A11 |
| validation-message | 85 | asChild → A11 |
| switch | 88 | outline → A1 |
| button | 88 | fullWidth → A4 |
| divider | 90 | aria-hidden → A10 |
| label | 90 | dokumentér weight-mapping → A11 |
| tabs | 90 | verdi-basert → T0.4 |
| badge | 92 | aria-label-verifisering → A11 |
| paragraph | 93 | dokumentér variant-navn → A11 |
| heading | 95 | verifiser header-semantikk → A11 |
