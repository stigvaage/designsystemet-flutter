# Tasks: Widgetbook Component Catalog & Documentation Site

**Input**: Design documents from `/specs/002-widgetbook-docs-site/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, quickstart.md

**Tests**: Not explicitly requested. Visual verification via Widgetbook previews serves as the test mechanism.

**Organization**: Tasks grouped by user story for incremental delivery.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup

**Purpose**: Initialize Widgetbook Flutter web app with dependencies

- [ ] T001 Create widgetbook/pubspec.yaml with dependencies: flutter, widgetbook, komponentbibliotek_flutter (path: ../), and configure for web in widgetbook/pubspec.yaml
- [ ] T002 Create widgetbook/web/index.html with Flutter web bootstrap and base href for GitHub Pages in widgetbook/web/index.html
- [ ] T003 [P] Create directory structure: widgetbook/lib/components/, widgetbook/lib/helpers/ per plan.md
- [ ] T004 [P] Create widgetbook/lib/main.dart entry point that launches the Widgetbook app

---

## Phase 2: Foundational (Theme & Scope Addons)

**Purpose**: Custom addons that wrap all component previews with DsTheme, DsColorScope, DsSizeScope

**⚠️ CRITICAL**: All component use cases depend on these addons

- [ ] T005 Implement theme addon: wraps previews in DsTheme with light/dark toggle using DsThemeDigdir.light()/dark() in widgetbook/lib/helpers/theme_addon.dart
- [ ] T006 [P] Implement color scope addon: dropdown with all 9 DsColor values (accent, neutral, brand1-3, success, danger, warning, info) wrapping preview in DsColorScope in widgetbook/lib/helpers/color_scope_addon.dart
- [ ] T007 [P] Implement size scope addon: toggle with sm/md/lg wrapping preview in DsSizeScope in widgetbook/lib/helpers/size_scope_addon.dart
- [ ] T008 Wire addons into widgetbook/lib/main.dart Widgetbook app configuration with all three addons active
- [ ] T009 Run `flutter run -d chrome` in widgetbook/ and verify the app launches with empty catalog and addon controls visible

**Checkpoint**: Widgetbook shell running with theme/color/size addons.

---

## Phase 3: User Story 1 - Browse All Components Interactively (Priority: P1) 🎯 MVP

**Goal**: All 40 components in the catalog with live previews and knobs

**Independent Test**: Open site, select DsButton, toggle variant/size knobs, verify preview updates

### Core Components (14)

- [ ] T010 [P] [US1] Create DsButton use case with knobs: variant (primary/secondary/tertiary), disabled, loading, icon in widgetbook/lib/components/button.dart
- [ ] T011 [P] [US1] Create DsTextfield use case with knobs: error, disabled, readOnly, prefix/suffix in widgetbook/lib/components/textfield.dart
- [ ] T012 [P] [US1] Create DsTextarea use case with knobs: rows, error, disabled in widgetbook/lib/components/textarea.dart
- [ ] T013 [P] [US1] Create DsCheckbox use case with knobs: value, indeterminate, readOnly, error in widgetbook/lib/components/checkbox.dart
- [ ] T014 [P] [US1] Create DsRadio use case with knobs: value, readOnly, error in widgetbook/lib/components/radio.dart
- [ ] T015 [P] [US1] Create DsSwitch use case with knobs: value, readOnly in widgetbook/lib/components/switch.dart
- [ ] T016 [P] [US1] Create DsAlert use case with knobs: severity (info/warning/success/danger), closable, title in widgetbook/lib/components/alert.dart
- [ ] T017 [P] [US1] Create DsCard use case with knobs: elevated, clickable, showing Header/Block/Footer sub-components in widgetbook/lib/components/card.dart
- [ ] T018 [P] [US1] Create DsTag use case with knobs: (inherits size/color from addons) in widgetbook/lib/components/tag.dart
- [ ] T019 [P] [US1] Create DsChip use case with knobs: removable, selected in widgetbook/lib/components/chip.dart
- [ ] T020 [P] [US1] Create DsBadge use case with knobs: count, placement, overlap in widgetbook/lib/components/badge.dart
- [ ] T021 [P] [US1] Create DsSpinner use case (inherits size/color from addons) in widgetbook/lib/components/spinner.dart
- [ ] T022 [P] [US1] Create DsDivider use case with knobs: vertical in widgetbook/lib/components/divider.dart
- [ ] T023 [P] [US1] Create DsLink use case with knobs: inverted in widgetbook/lib/components/link.dart

### Navigation & Layout Components (14)

- [ ] T024 [P] [US1] Create DsTabs use case with 3 sample tabs and panel content in widgetbook/lib/components/tabs.dart
- [ ] T025 [P] [US1] Create DsDialog use case with trigger button to open dialog in widgetbook/lib/components/dialog.dart
- [ ] T026 [P] [US1] Create DsDropdown use case with sample items in widgetbook/lib/components/dropdown.dart
- [ ] T027 [P] [US1] Create DsSelect use case with knobs: items, placeholder, error, disabled in widgetbook/lib/components/select.dart
- [ ] T028 [P] [US1] Create DsPagination use case with knobs: totalPages, currentPage in widgetbook/lib/components/pagination.dart
- [ ] T029 [P] [US1] Create DsTable use case with sample columns and rows in widgetbook/lib/components/table.dart
- [ ] T030 [P] [US1] Create DsBreadcrumbs use case with sample path in widgetbook/lib/components/breadcrumbs.dart
- [ ] T031 [P] [US1] Create DsSearch use case in widgetbook/lib/components/search.dart
- [ ] T032 [P] [US1] Create DsTooltip use case with hover trigger in widgetbook/lib/components/tooltip.dart
- [ ] T033 [P] [US1] Create DsPopover use case with click trigger in widgetbook/lib/components/popover.dart
- [ ] T034 [P] [US1] Create DsAvatar use case with knobs: name in widgetbook/lib/components/avatar.dart
- [ ] T035 [P] [US1] Create DsAvatarStack use case with sample avatars in widgetbook/lib/components/avatar.dart
- [ ] T036 [P] [US1] Create DsToggleGroup use case with sample items in widgetbook/lib/components/toggle_group.dart
- [ ] T037 [P] [US1] Create DsSuggestion use case with sample items in widgetbook/lib/components/suggestion.dart

### Form & Utility Components (8)

- [ ] T038 [P] [US1] Create DsField use case with knobs: label, description, error wrapping DsTextfield in widgetbook/lib/components/field.dart
- [ ] T039 [P] [US1] Create DsFieldset use case with sample legend and children in widgetbook/lib/components/fieldset.dart
- [ ] T040 [P] [US1] Create DsInput use case (base input) with knobs: error, disabled, readOnly in widgetbook/lib/components/input.dart
- [ ] T041 [P] [US1] Create DsErrorSummary use case with sample errors in widgetbook/lib/components/error_summary.dart
- [ ] T042 [P] [US1] Create DsDetails use case with knobs: initiallyExpanded in widgetbook/lib/components/details.dart
- [ ] T043 [P] [US1] Create DsList use case with knobs: ordered in widgetbook/lib/components/list.dart
- [ ] T044 [P] [US1] Create DsSkeleton use case with knobs: width, height in widgetbook/lib/components/skeleton.dart
- [ ] T045 [P] [US1] Create DsSkipLink use case in widgetbook/lib/components/skip_link.dart

### Typography Components (4)

- [ ] T046 [P] [US1] Create DsHeading use case with knobs: level (2xl through 2xs) in widgetbook/lib/components/typography.dart
- [ ] T047 [P] [US1] Create DsParagraph use case with knobs: bodySize, variant (standard/short/long) in widgetbook/lib/components/typography.dart
- [ ] T048 [P] [US1] Create DsLabel use case in widgetbook/lib/components/typography.dart
- [ ] T049 [P] [US1] Create DsValidationMessage use case with knobs: isError in widgetbook/lib/components/typography.dart

### Registration & Verification

- [ ] T050 [US1] Register all 40 component use cases in widgetbook/lib/widgetbook.dart organized by category (Kjernekomponenter, Navigasjon, Skjema, Typografi)
- [ ] T051 [US1] Run `flutter run -d chrome` in widgetbook/ and verify all 40 components appear in sidebar grouped by category, knobs work, previews render correctly

**Checkpoint**: Full interactive catalog with all 40 components and knobs.

---

## Phase 4: User Story 2 - Theme & Mode Switching (Priority: P2)

**Goal**: Light/dark theme toggle and color scope switching update all previews

**Independent Test**: Select DsCard, switch to dark theme, verify colors update

- [ ] T052 [US2] Verify theme addon toggles between DsThemeDigdir.light() and DsThemeDigdir.dark() and all component previews re-render with correct colors in widgetbook/lib/helpers/theme_addon.dart
- [ ] T053 [US2] Verify color scope addon applies selected DsColor to all component previews and colors update accordingly in widgetbook/lib/helpers/color_scope_addon.dart
- [ ] T054 [US2] Verify size scope addon applies selected DsSize to all component previews and sizing updates accordingly in widgetbook/lib/helpers/size_scope_addon.dart

**Checkpoint**: Theme/color/size switching works across all 40 components.

---

## Phase 5: User Story 3 - Documentation & Code Examples (Priority: P3)

**Goal**: Each component has description and code example visible in the catalog

- [ ] T055 [P] [US3] Add Norwegian descriptions for all 14 core components as Widgetbook use case descriptions in widgetbook/lib/components/ (button.dart through link.dart)
- [ ] T056 [P] [US3] Add Norwegian descriptions for all 14 navigation components in widgetbook/lib/components/ (tabs.dart through suggestion.dart)
- [ ] T057 [P] [US3] Add Norwegian descriptions for all 8 form/utility components in widgetbook/lib/components/ (field.dart through skip_link.dart)
- [ ] T058 [P] [US3] Add Norwegian descriptions for all 4 typography components in widgetbook/lib/components/typography.dart

**Checkpoint**: Every component has a Norwegian description visible in the catalog.

---

## Phase 6: User Story 4 - Automated Deployment (Priority: P4)

**Goal**: Push to main auto-deploys to GitHub Pages

- [ ] T059 [US4] Create GitHub Actions workflow: checkout, setup Flutter, `flutter build web --base-href /komponentbibliotek-flutter/` in widgetbook/, deploy build/web/ to gh-pages branch in .github/workflows/deploy-widgetbook.yml
- [ ] T060 [US4] Configure GitHub repository Pages settings to serve from gh-pages branch (document manual step in README)
- [ ] T061 [US4] Test deployment by pushing to main and verifying site is live at https://stigvaage.github.io/komponentbibliotek-flutter/

**Checkpoint**: Site auto-deploys on push to main.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final touches and validation

- [ ] T062 Verify search/filter works to find components by name in the Widgetbook sidebar
- [ ] T063 Verify deep-linking: copy URL of a specific component, open in new tab, verify it navigates directly to that component
- [ ] T064 Add library name, version, and GitHub repo link to the Widgetbook app header/footer in widgetbook/lib/main.dart
- [ ] T065 Update root README.md to add link to the live documentation site
- [ ] T066 Run `flutter build web --base-href /komponentbibliotek-flutter/` in widgetbook/ and verify build succeeds with no errors

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational — all 40 component use cases
- **US2 (Phase 4)**: Depends on Phase 2 addons — verifies theme/color/size switching
- **US3 (Phase 5)**: Depends on US1 — adds descriptions to existing use cases
- **US4 (Phase 6)**: Depends on Phase 1 — GitHub Actions workflow is independent of components
- **Polish (Phase 7)**: Depends on US1 at minimum

### Parallel Opportunities

- All Phase 1 tasks T003, T004 can run in parallel
- All Phase 2 addon tasks T006, T007 can run in parallel
- **ALL 40 component use case tasks T010–T049 can run in parallel** (different files, no dependencies)
- US3 description tasks T055–T058 can run in parallel
- US4 (Phase 6) can run in parallel with US1/US2/US3

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Addons (theme/color/size)
3. Complete Phase 3: All 40 component use cases
4. **STOP and VALIDATE**: Run locally, verify catalog works
5. Deploy manually or via Phase 6

### Incremental Delivery

1. Setup + Addons → Widgetbook shell running
2. Add US1 → Full interactive catalog → Deploy
3. Add US2 → Verify theme switching → Redeploy
4. Add US3 → Norwegian descriptions → Redeploy
5. Add US4 → Auto-deployment pipeline

---

## Notes

- [P] tasks = different files, no dependencies
- All 40 component use case tasks (T010–T049) are maximally parallelizable
- Each use case file is self-contained — imports the component and creates knobs
- Widgetbook handles sidebar navigation, search, and deep-linking automatically
