# Tasks: Fix Documentation Site and Widgetbook Issues

**Input**: Design documents from `/specs/004-fix-docs-site/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US4)
- Include exact file paths in descriptions

---

## Phase 1: User Story 1 - Working Widgetbook Component Previews (Priority: P1) MVP

**Goal**: Fix the WidgetbookEmbed Vue component's URL construction so all 40 component doc pages deep-link correctly to their Widgetbook use cases.

**Independent Test**: Click any "Prøv [Component] i Widgetbook" link and verify the Widgetbook app opens with the correct component selected.

**Root cause**: Three bugs in URL construction — missing `#/` hash prefix, not lowercasing/hyphenating, missing use case name segment (see research.md R1).

### Core Fix

- [x] T001 [US1] Fix URL construction in site/.vitepress/theme/WidgetbookEmbed.vue — replace `widgetbook/?path=` with `widgetbook/#/?path=`, add `.replace(/ /g, '-').toLowerCase()` transformation, and remove unused `height` prop from defineProps
- [x] T002 [US1] Verify the componentName computed property still works after removing height prop in site/.vitepress/theme/WidgetbookEmbed.vue

### Update Kjernekomponenter docs (14 files)

- [x] T003 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-alert.md — change component to `Kjernekomponenter/DsAlert/Standard` and remove `:height="200"`
- [x] T004 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-badge.md — change component to `Kjernekomponenter/DsBadge/Standard` and remove `:height="300"`
- [x] T005 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-button.md — change component to `Kjernekomponenter/DsButton/Standard` and remove `:height="200"`
- [x] T006 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-card.md — change component to `Kjernekomponenter/DsCard/Standard` and remove `:height="200"`
- [x] T007 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-checkbox.md — change component to `Kjernekomponenter/DsCheckbox/Standard` and remove `:height="200"`
- [x] T008 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-chip.md — change component to `Kjernekomponenter/DsChip/Standard` and remove `:height="200"`
- [x] T009 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-divider.md — change component to `Kjernekomponenter/DsDivider/Standard` and remove `:height="300"`
- [x] T010 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-link.md — change component to `Kjernekomponenter/DsLink/Standard` and remove `:height="300"`
- [x] T011 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-radio.md — change component to `Kjernekomponenter/DsRadio/Standard` and remove `:height="200"`
- [x] T012 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-spinner.md — change component to `Kjernekomponenter/DsSpinner/Standard` and remove `:height="300"`
- [x] T013 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-switch.md — change component to `Kjernekomponenter/DsSwitch/Standard` and remove `:height="200"`
- [x] T014 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-tag.md — change component to `Kjernekomponenter/DsTag/Standard` and remove `:height="200"`
- [x] T015 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-textarea.md — change component to `Kjernekomponenter/DsTextarea/Standard` and remove `:height="200"`
- [x] T016 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-textfield.md — change component to `Kjernekomponenter/DsTextfield/Standard` and remove `:height="200"`

### Update Navigasjon og layout docs (14 files)

- [x] T017 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-avatar.md — change component to `Navigasjon og layout/DsAvatar/Standard` and remove `:height="300"`
- [x] T018 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-avatar-stack.md — change component to `Navigasjon og layout/DsAvatarStack/Standard` and remove `:height="300"`
- [x] T019 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-breadcrumbs.md — change component to `Navigasjon og layout/DsBreadcrumbs/Standard` and remove `:height="300"`
- [x] T020 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-dialog.md — change component to `Navigasjon og layout/DsDialog/Standard` and remove `:height="300"`
- [x] T021 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-dropdown.md — change component to `Navigasjon og layout/DsDropdown/Standard` and remove `:height="300"`
- [x] T022 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-pagination.md — change component to `Navigasjon og layout/DsPagination/Standard` and remove `:height="300"`
- [x] T023 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-popover.md — change component to `Navigasjon og layout/DsPopover/Standard` and remove `:height="300"`
- [x] T024 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-search.md — change component to `Navigasjon og layout/DsSearch/Standard` and remove `:height="300"`
- [x] T025 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-select.md — change component to `Navigasjon og layout/DsSelect/Standard` and remove `:height="300"`
- [x] T026 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-suggestion.md — change component to `Navigasjon og layout/DsSuggestion/Standard` and remove `:height="300"`
- [x] T027 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-table.md — change component to `Navigasjon og layout/DsTable/Standard` and remove `:height="300"`
- [x] T028 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-tabs.md — change component to `Navigasjon og layout/DsTabs/Standard` and remove `:height="300"`
- [x] T029 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-toggle-group.md — change component to `Navigasjon og layout/DsToggleGroup/Standard` and remove `:height="300"`
- [x] T030 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-tooltip.md — change component to `Navigasjon og layout/DsTooltip/Standard` and remove `:height="300"`

### Update Skjema og verktøy docs (8 files)

- [x] T031 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-details.md — change component to `Skjema og verktøy/DsDetails/Standard` and remove `:height="300"`
- [x] T032 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-error-summary.md — change component to `Skjema og verktøy/DsErrorSummary/Standard` and remove `:height="300"`
- [x] T033 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-field.md — change component to `Skjema og verktøy/DsField/Standard` and remove `:height="300"`
- [x] T034 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-fieldset.md — change component to `Skjema og verktøy/DsFieldset/Standard` and remove `:height="300"`
- [x] T035 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-input.md — change component to `Skjema og verktøy/DsInput/Standard` and remove `:height="300"`
- [x] T036 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-list.md — change component to `Skjema og verktøy/DsList/Standard` and remove `:height="300"`
- [x] T037 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-skeleton.md — change component to `Skjema og verktøy/DsSkeleton/Standard` and remove `:height="300"`
- [x] T038 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-skip-link.md — change component to `Skjema og verktøy/DsSkipLink/Standard` and remove `:height="300"`

### Update Typografi docs (4 files)

- [x] T039 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-heading.md — change component to `Typografi/DsHeading/Standard` and remove `:height="300"`
- [x] T040 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-label.md — change component to `Typografi/DsLabel/Standard` and remove `:height="300"`
- [x] T041 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-paragraph.md — change component to `Typografi/DsParagraph/Standard` and remove `:height="300"`
- [x] T042 [P] [US1] Update WidgetbookEmbed in site/nb/komponenter/ds-validation-message.md — change component to `Typografi/DsValidationMessage/Standard` and remove `:height="300"`

**Checkpoint**: All 40 Widgetbook links should now generate correct deep-link URLs. Test by running VitePress dev server and clicking several link cards across all 4 categories.

---

## Phase 2: User Story 2 - All Documentation Pages Load Without Errors (Priority: P2)

**Goal**: Verify all documentation pages load correctly with no broken links or missing content.

**Independent Test**: Navigate to every page in the sidebar and verify content loads correctly.

**Note**: Research audit (R2) confirmed all 67 pages are complete with no missing content, broken links, or rendering errors. This phase is verification-only.

- [x] T043 [US2] Run VitePress dev server (`cd site && npm run dev`) and verify all sidebar navigation links in the Komponenter section load correctly — spot-check 5 pages across categories
- [x] T044 [US2] Verify old URL redirects still work — test at least 3 redirect paths from site/.vitepress/config.ts (e.g., `komponenter/kjernekomponenter/ds-alert` redirects to `komponenter/ds-alert`)
- [x] T045 [US2] Verify the Widgetbook nav link at site/.vitepress/config.ts line 98 points to `/widgetbook/` and opens in new tab

**Checkpoint**: All documentation pages verified accessible. No broken links.

---

## Phase 3: User Story 4 - Reliable Automated Deployment (Priority: P4)

**Goal**: Improve deployment pipeline resilience with build verification and pinned action versions.

**Independent Test**: Push to main and verify GitHub Actions completes successfully.

- [x] T046 [US4] Add build verification step in .github/workflows/deploy-widgetbook.yml — after the Widgetbook build step (line 41), add a step that checks `widgetbook/build/web/index.html` exists before proceeding to copy
- [x] T047 [US4] Pin subosito/flutter-action version in .github/workflows/deploy-widgetbook.yml line 23 — change from `@v2` to a specific release tag for reproducible builds

**Checkpoint**: Deployment pipeline has build verification and pinned dependencies.

---

## Phase 4: Polish & Verification

**Purpose**: Final end-to-end verification across all user stories

- [x] T048 Build VitePress site locally (`cd site && npm run build`) and verify no build errors
- [x] T049 Verify generated URLs in VitePress build output match expected format — check that WidgetbookEmbed link cards in built HTML contain `widgetbook/#/?path=` (not `widgetbook/?path=`)
- [x] T050 Spot-check 4 representative deep-link URLs (one per Widgetbook folder) against the expected paths from data-model.md — verify `kjernekomponenter/dsbutton/standard`, `navigasjon-og-layout/dstabs/standard`, `skjema-og-verktøy/dsfield/standard`, `typografi/dsheading/standard`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (US1)**: No dependencies — can start immediately. This is the MVP.
- **Phase 2 (US2)**: Can start after T001 (needs Vue component fix to verify links). Most work is verification.
- **Phase 3 (US4)**: Independent — can run in parallel with Phase 1 (different files).
- **Phase 4 (Polish)**: Depends on Phase 1 completion (needs all markdown updates done).

### User Story Dependencies

- **User Story 1 (P1)**: No dependencies — standalone fix
- **User Story 2 (P2)**: Soft dependency on US1 (Widgetbook link verification requires the fix)
- **User Story 3 (P3)**: No tasks needed — audit confirmed docs are already high quality
- **User Story 4 (P4)**: No dependencies — different file (workflow YAML)

### Within Phase 1 (User Story 1)

- T001 must complete first (Vue component fix)
- T002 depends on T001 (verification)
- T003–T042 can all run in parallel (40 independent markdown file edits)

### Parallel Opportunities

```
# After T001+T002 complete, launch all markdown updates in parallel:
T003–T016: Kjernekomponenter (14 files) — all [P]
T017–T030: Navigasjon og layout (14 files) — all [P]
T031–T038: Skjema og verktøy (8 files) — all [P]
T039–T042: Typografi (4 files) — all [P]

# Independently, US4 tasks can run in parallel:
T046–T047: Deployment improvements (1 file) — independent from markdown edits
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001–T002: Fix WidgetbookEmbed.vue
2. Complete T003–T042: Update all 40 component markdown files
3. **STOP and VALIDATE**: Run VitePress dev server, click several Widgetbook links
4. This alone delivers the primary value — working component previews

### Incremental Delivery

1. Phase 1 (US1) → Fix Widgetbook deep-links → **MVP deployed**
2. Phase 2 (US2) → Verify all pages load → Confidence check
3. Phase 3 (US4) → Harden deployment → Long-term reliability
4. Phase 4 (Polish) → Final verification → Ready for merge

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- US3 (documentation quality) has no tasks — audit confirmed all 67 pages are complete and consistent
- The 40 markdown file updates (T003–T042) follow an identical pattern: replace `component="Folder/Component"` with `component="Folder/Component/Standard"` and remove `:height="N"`
- Commit after each logical group (Vue fix, Kjernekomponenter batch, Navigasjon batch, etc.)
