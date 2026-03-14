# Tasks: Designsystemet Flutter Component Library

**Input**: Design documents from `/specs/001-designsystemet-flutter-lib/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Tests**: REQUIRED — Constitution Principle VI mandates test-first development. Widget tests and golden tests MUST be written before component implementation (red-green-refactor).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Library source**: `lib/src/` at repository root
- **Tests**: `test/` at repository root
- **Generated**: `lib/generated/` at repository root
- **Fonts**: `lib/fonts/` at repository root
- **CLI tool**: `bin/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and Dart/Flutter package structure

- [x] T001 Create Flutter package with `flutter create --template=package komponentbibliotek_flutter` and configure pubspec.yaml with name, description, SDK constraints (Dart >=3.3.0, Flutter >=3.19.0), and dev_dependencies (flutter_test, flutter_lints)
- [x] T002 Configure analysis_options.yaml with flutter_lints and strict rules in analysis_options.yaml
- [x] T003 [P] Add Inter font files (Regular 400, Medium 500, SemiBold 600) to lib/fonts/ and register them in pubspec.yaml under flutter.fonts
- [x] T004 [P] Create directory structure per plan.md: lib/src/theme/, lib/src/components/, lib/src/typography/, lib/src/utils/, lib/generated/, bin/, test/theme/, test/components/, test/golden/, test/generator/, example/lib/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Token classes, theme infrastructure, and utility modules that ALL components depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Tests for Foundation (write FIRST, ensure they FAIL)

- [x] T005 [P] Write tests for DsColorScale: construction with 16 tokens, field access, equality, copyWith in test/theme/ds_color_scale_test.dart
- [x] T006 [P] Write tests for DsColorScheme: 9 named scales, custom scale map, resolve by DsColor enum in test/theme/ds_color_scheme_test.dart
- [x] T007 [P] Write tests for DsSizeTokens: sm/md/lg modes with correct base/step, all 31 size values computed correctly in test/theme/ds_size_tokens_test.dart
- [x] T008 [P] Write tests for DsTypography: heading styles (7 levels, weight 500, line-height 1.3, letter-spacing), body styles (5 sizes × 3 variants), configurable fontFamily in test/theme/ds_typography_test.dart
- [x] T009 [P] Write tests for DsBorderRadiusTokens and DsShadowTokens: correct values for each level in test/theme/ds_border_radius_tokens_test.dart and test/theme/ds_shadow_tokens_test.dart
- [x] T010 [P] Write tests for DsThemeData: construction, digdir() factory (light+dark), ThemeExtension copyWith/lerp, fromTokens factory in test/theme/ds_theme_data_test.dart
- [x] T011 [P] Write widget tests for DsTheme InheritedWidget: of() returns data, maybeOf() returns null when missing, of() throws descriptive error when missing in test/theme/ds_theme_test.dart
- [x] T012 [P] Write widget tests for DsColorScope: of() returns overridden color, defaults to accent when no scope in test/theme/ds_color_scope_test.dart
- [x] T013 [P] Write widget tests for DsSizeScope: of() returns overridden size, defaults to md when no scope in test/theme/ds_size_scope_test.dart
- [x] T131 [P] Write contrast ratio validation tests: verify Digdir theme textDefault has ≥4.5:1 contrast against all background/surface colors, borderDefault has ≥3:1 against backgrounds (FR-009) in test/theme/ds_contrast_validation_test.dart

### Implementation for Foundation

- [x] T014 [P] Implement DsSize enum (sm, md, lg) and DsColor sealed class (9 named + custom) in lib/src/utils/ds_enums.dart
- [x] T015 Implement DsSeverity, DsButtonVariant, DsIconPosition, DsHeadingLevel, DsBodySize, DsBodyVariant, DsBadgePlacement enums in lib/src/utils/ds_enums.dart (depends on T014, same file)
- [x] T016 [P] Implement DsColorScale immutable class with 16 Color fields, const constructor, copyWith, equality in lib/src/theme/ds_color_scale.dart
- [x] T017 [P] Implement DsColorScheme with 9 named DsColorScale fields + custom Map, resolve(DsColor) method in lib/src/theme/ds_color_scheme.dart
- [x] T018 [P] Implement DsSizeTokens with base, step, size0–size30, sizeUnit fields and factory constructors for sm/md/lg in lib/src/theme/ds_size_tokens.dart
- [x] T019 [P] Implement DsTypography with fontFamily, 7 heading TextStyles, 15 body TextStyles (5 sizes × 3 variants), Inter font feature cv05 in lib/src/theme/ds_typography.dart
- [x] T020 [P] Implement DsBorderRadiusTokens (sm, md, lg, xl, defaultRadius, full) in lib/src/theme/ds_border_radius_tokens.dart
- [x] T021 [P] Implement DsShadowTokens (xs through xl, each with multi-layer BoxShadow lists) in lib/src/theme/ds_shadow_tokens.dart
- [x] T022 Implement DsThemeData extending ThemeExtension with all token fields, digdir() factory (light+dark Digdir colors), fromTokens() factory, copyWith, lerp in lib/src/theme/ds_theme_data.dart
- [x] T023 Implement DsTheme InheritedWidget with of()/maybeOf() static methods (throws descriptive error when missing) in lib/src/theme/ds_theme.dart
- [x] T024 [P] Implement DsColorScope InheritedWidget with of() defaulting to DsColor.accent in lib/src/theme/ds_color_scope.dart
- [x] T025 [P] Implement DsSizeScope InheritedWidget with of() defaulting to DsSize.md in lib/src/theme/ds_size_scope.dart
- [x] T026 [P] Implement focus ring decoration utility (borderStrong color, consistent width) in lib/src/utils/ds_focus.dart
- [x] T027 [P] Implement animation constants (durations, curves) and reduced-motion helper checking MediaQuery.disableAnimations in lib/src/utils/ds_animation.dart
- [x] T028 Hard-code Digdir default theme values (light and dark color schemes from designsystemet.no source) in lib/generated/ds_theme_digdir.dart
- [x] T029 Create theme.dart barrel export exporting all theme classes, scopes, and enums from lib/theme.dart
- [x] T030 Run `flutter test test/theme/` and verify all foundation tests pass

**Checkpoint**: Theme infrastructure complete — `DsTheme(data: DsThemeData.digdir())` works. User story implementation can begin.

---

## Phase 3: User Story 1 - Theme a Flutter App with Designsystemet (Priority: P1) 🎯 MVP

**Goal**: Developer wraps app with DsTheme and typography components render correctly with inherited tokens, light/dark mode, color/size scoping

**Independent Test**: Create minimal app with DsTheme, render DsHeading and DsParagraph, verify font family, weight, size, color from theme

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T031 [P] [US1] Write widget test for DsHeading: renders correct text style per level, inherits size from DsSizeScope, inherits color from DsColorScope in test/components/ds_heading_test.dart
- [x] T032 [P] [US1] Write widget test for DsParagraph: renders correct body style per size/variant, inherits theme tokens in test/components/ds_paragraph_test.dart
- [x] T033 [P] [US1] Write widget test for DsLabel: renders with correct typography style in test/components/ds_label_test.dart
- [ ] T034 [P] [US1] Write golden tests for DsHeading at all 7 levels × 3 sizes in test/golden/ds_heading_golden_test.dart
- [ ] T035 [P] [US1] Write golden tests for DsParagraph at all 5 body sizes × 3 variants × 3 sizes in test/golden/ds_paragraph_golden_test.dart

### Implementation for User Story 1

- [x] T036 [P] [US1] Implement DsHeading widget: reads DsTheme.of(context) for typography, resolves heading level to TextStyle, supports size/color overrides in lib/src/typography/ds_heading.dart
- [x] T037 [P] [US1] Implement DsParagraph widget: reads theme for body text style per bodySize/variant, supports size/color overrides in lib/src/typography/ds_paragraph.dart
- [x] T038 [P] [US1] Implement DsLabel widget: renders label text with appropriate typography style in lib/src/typography/ds_label.dart
- [x] T039 [US1] Create typography.dart barrel export for DsHeading, DsParagraph, DsLabel in lib/typography.dart (DsValidationMessage added in US2 after T059)
- [x] T040 [US1] Run `flutter test test/components/ds_heading_test.dart test/components/ds_paragraph_test.dart test/components/ds_label_test.dart` and verify all US1 tests pass
- [ ] T041 [US1] Run `flutter test test/golden/` and update golden files for US1 typography components

**Checkpoint**: DsTheme + typography components working. Developer can theme an app and render headings/paragraphs with correct Designsystemet styling.

---

## Phase 4: User Story 2 - Build a Form with Core Components (Priority: P2)

**Goal**: Developer builds forms with text inputs, checkboxes, radio buttons, switches, buttons, and field wrappers with validation states

**Independent Test**: Compose form with DsField/DsTextfield/DsCheckbox/DsButton, verify all states (default, hover, focus, error, disabled, loading), keyboard navigation, semantics

### Tests for User Story 2

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T042 [P] [US2] Write widget tests for DsInput (base input): default/hover/focus/error/disabled/readOnly states, size inheritance in test/components/ds_input_test.dart
- [x] - [ ] T043 [P] [US2] Write widget tests for DsTextfield: delegates to DsInput, prefix/suffix, error state, focus ring in test/components/ds_textfield_test.dart
- [x] - [ ] T044 [P] [US2] Write widget tests for DsTextarea: multi-line, autoResize, rows, error state in test/components/ds_textarea_test.dart
- [x] T045 [P] [US2] Write widget tests for DsButton: 3 variants × 3 sizes, disabled (30% opacity), loading (spinner), icon positioning, focus ring, semantics in test/components/ds_button_test.dart
- [x] - [ ] T046 [P] [US2] Write widget tests for DsCheckbox: checked/unchecked/indeterminate, readOnly, error, label, size/color, semantics in test/components/ds_checkbox_test.dart
- [x] - [ ] T047 [P] [US2] Write widget tests for DsRadio: selected/unselected, readOnly, error, label, roving focus, semantics in test/components/ds_radio_test.dart
- [x] - [ ] T048 [P] [US2] Write widget tests for DsSwitch: on/off, readOnly, size, semantics in test/components/ds_switch_test.dart
- [x] - [ ] T049 [P] [US2] Write widget tests for DsField: label rendering, description, error→DsValidationMessage, child wrapping in test/components/ds_field_test.dart
- [x] - [ ] T050 [P] [US2] Write widget tests for DsValidationMessage: renders error text with danger color scale in test/components/ds_validation_message_test.dart
- [x] T051 [P] [US2] Write widget tests for DsSpinner: animation, size, color, reduced motion in test/components/ds_spinner_test.dart
- [x] T052 [P] [US2] Write widget tests for DsLink: renders styled hyperlink, inverted variant in test/components/ds_link_test.dart
- [x] T053 [P] [US2] Write widget tests for DsDivider: horizontal/vertical, color in test/components/ds_divider_test.dart
- [x] - [ ] T054 [P] [US2] Write golden tests for DsButton (3 variants × 3 sizes × 5 states) in test/golden/ds_button_golden_test.dart
- [x] - [ ] T055 [P] [US2] Write golden tests for DsTextfield, DsCheckbox, DsRadio, DsSwitch (all states × 3 sizes) in test/golden/ds_form_components_golden_test.dart

### Implementation for User Story 2

- [x] T056 [P] [US2] Implement DsSpinner widget: rotating arc animation using CustomPaint, size/color from theme, respects disableAnimations in lib/src/components/spinner/ds_spinner.dart
- [x] T057 [P] [US2] Implement DsDivider widget: horizontal/vertical Container with border color from theme in lib/src/components/divider/ds_divider.dart
- [x] T058 [P] [US2] Implement DsLink widget: styled text with underline, inverted variant, color from scope in lib/src/components/link/ds_link.dart
- [x] T059 [P] [US2] Implement DsValidationMessage widget: error/success text with appropriate color scale in lib/src/typography/ds_validation_message.dart
- [x] T145 [US2] Add DsValidationMessage to typography.dart barrel export in lib/typography.dart (deferred from US1 T039)
- [x] T060 [US2] Implement DsInput (base input widget): EditableText wrapper with DecoratedBox for border states (default→borderDefault, hover→borderStrong, focus→focus ring, error→danger.borderDefault, disabled→0.3 opacity, readOnly→no border), size-aware padding in lib/src/components/input/ds_input.dart
- [x] T061 [US2] Implement DsTextfield: wraps DsInput for single-line, adds prefix/suffix, delegates error/disabled/readOnly/size in lib/src/components/textfield/ds_textfield.dart
- [x] T062 [US2] Implement DsTextarea: wraps DsInput for multi-line, supports rows and autoResize in lib/src/components/textarea/ds_textarea.dart
- [x] T063 [US2] Implement DsField: renders label (DsLabel) + description + child + DsValidationMessage, associates label with child via semantics in lib/src/components/field/ds_field.dart
- [x] T064 [US2] Implement DsButton: StatefulWidget tracking hover/focus/pressed states via MouseRegion+GestureDetector+Focus, 3 variant styles (primary→baseDefault fill, secondary→borderDefault outline, tertiary→text only), loading→DsSpinner, disabled→0.3 opacity, focus ring, Semantics(button: true) in lib/src/components/button/ds_button.dart
- [x] T065 [US2] Implement DsCheckbox: CustomPaint for check/indeterminate mark, StatefulWidget for hover/focus states, Semantics(checked:), readOnly mode in lib/src/components/checkbox/ds_checkbox.dart
- [x] T066 [US2] Implement DsRadio: CustomPaint for circle/dot, StatefulWidget for hover/focus, Semantics(selected:), readOnly mode in lib/src/components/radio/ds_radio.dart
- [x] T067 [US2] Implement DsSwitch: animated toggle using AnimatedContainer, StatefulWidget for states, Semantics(toggled:), readOnly in lib/src/components/switch/ds_switch.dart
- [ ] T068 [US2] Run `flutter test test/components/ds_button_test.dart test/components/ds_textfield_test.dart test/components/ds_checkbox_test.dart test/components/ds_radio_test.dart test/components/ds_switch_test.dart test/components/ds_field_test.dart` and verify all US2 tests pass
- [ ] T069 [US2] Run `flutter test test/golden/ds_button_golden_test.dart test/golden/ds_form_components_golden_test.dart` and update golden files for US2

**Checkpoint**: Form components complete. Developer can build forms with text fields, checkboxes, radio buttons, switches, buttons, and validation.

---

## Phase 5: User Story 3 - Display Information with Layout Components (Priority: P3)

**Goal**: Developer builds dashboard views with cards, alerts, tabs, tags, badges, tables, and navigation components

**Independent Test**: Compose view with DsCard, DsAlert, DsTabs, DsTag, DsBadge, DsTable; verify visual variants, interactive states, keyboard nav

### Tests for User Story 3

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T070 [P] [US3] Write widget tests for DsCard: bordered/elevated variants, onTap→hover state, sub-components (Header, Block, Footer), nested card gesture disambiguation in test/components/ds_card_test.dart
- [x] T071 [P] [US3] Write widget tests for DsAlert: 4 severities with correct color scales, title, closable, icon in test/components/ds_alert_test.dart
- [x] T072 [P] [US3] Write widget tests for DsTag: size/color, variant in test/components/ds_tag_test.dart
- [x] T073 [P] [US3] Write widget tests for DsChip: removable, selected, size in test/components/ds_chip_test.dart
- [x] T074 [P] [US3] Write widget tests for DsBadge: count, color, overlap, placement in test/components/ds_badge_test.dart
- [x] T075 [P] [US3] Write widget tests for DsTabs: tab switching, roving focus (arrow keys), panel visibility, semantics in test/components/ds_tabs_test.dart
- [x] T076 [P] [US3] Write widget tests for DsDialog: modal overlay, close on escape, focus trap in test/components/ds_dialog_test.dart
- [x] T077 [P] [US3] Write widget tests for DsDropdown and DsSelect: open/close, selection, keyboard nav in test/components/ds_dropdown_test.dart and test/components/ds_select_test.dart
- [x] T078 [P] [US3] Write widget tests for DsTable: column headers, rows, sortable, responsive in test/components/ds_table_test.dart
- [x] T079 [P] [US3] Write widget tests for DsPagination, DsBreadcrumbs, DsSearch, DsTooltip, DsPopover in test/components/ (one test file per component)
- [x] T080 [P] [US3] Write widget tests for DsAvatar, DsAvatarStack, DsToggleGroup, DsSuggestion in test/components/ (one test file per component)
- [x] T081 [P] [US3] Write golden tests for DsCard, DsAlert, DsTag, DsChip, DsBadge (all variants × 3 sizes) in test/golden/ds_display_golden_test.dart
- [x] T132 [P] [US3] Write golden tests for DsTabs, DsDialog, DsDropdown, DsSelect (all states × 3 sizes) in test/golden/ds_nav_interactive_golden_test.dart
- [x] T133 [P] [US3] Write golden tests for DsPagination, DsTable, DsBreadcrumbs, DsSearch (all states × 3 sizes) in test/golden/ds_nav_data_golden_test.dart
- [x] T134 [P] [US3] Write golden tests for DsTooltip, DsPopover, DsAvatar, DsAvatarStack, DsToggleGroup, DsSuggestion (all states × 3 sizes) in test/golden/ds_nav_overlay_golden_test.dart

### Implementation for User Story 3

- [x] T082 [P] [US3] Implement DsCard: DecoratedBox with borderSubtle or shadowSm, DsCardHeader/DsCardBlock/DsCardFooter sub-components, clickable with hover (surfaceHover), gesture disambiguation in lib/src/components/card/ds_card.dart, ds_card_header.dart, ds_card_block.dart, ds_card_footer.dart
- [x] T083 [P] [US3] Implement DsAlert: 4px left border (borderDefault), surfaceTinted background, severity icon (baseDefault), optional title, optional close button in lib/src/components/alert/ds_alert.dart
- [x] T084 [P] [US3] Implement DsTag and DsChip: sized containers with color scale tokens, DsChip adds removable/selected behavior in lib/src/components/tag/ds_tag.dart and lib/src/components/chip/ds_chip.dart
- [x] T085 [P] [US3] Implement DsBadge: positioned overlay with count, color, placement options in lib/src/components/badge/ds_badge.dart
- [x] T086 [US3] Implement DsTabs: StatefulWidget with tab bar + panel, roving focus via arrow keys (RawKeyboardListener/FocusTraversalGroup), Semantics(tab:, tabPanel:) in lib/src/components/tabs/ds_tabs.dart
- [x] T087 [US3] Implement DsDialog: Overlay entry with modal barrier, focus trap, close on Escape key, Semantics(dialog:) in lib/src/components/dialog/ds_dialog.dart
- [x] T088 [US3] Implement DsDropdown: Overlay-based menu with keyboard navigation, dismiss on outside tap in lib/src/components/dropdown/ds_dropdown.dart
- [x] T089 [US3] Implement DsSelect: combines DsInput appearance with DsDropdown overlay for option selection in lib/src/components/select/ds_select.dart
- [x] T090 [P] [US3] Implement DsPagination: page number buttons with active state, previous/next, Semantics in lib/src/components/pagination/ds_pagination.dart
- [x] T091 [P] [US3] Implement DsTable: column headers with optional sort, rows, borders, responsive behavior in lib/src/components/table/ds_table.dart
- [x] T092 [P] [US3] Implement DsBreadcrumbs: horizontal list with separator, link styling in lib/src/components/breadcrumbs/ds_breadcrumbs.dart
- [x] T093 [US3] Implement DsSearch: DsInput with search icon, suggestion dropdown overlay, clearable in lib/src/components/search/ds_search.dart
- [x] T094 [P] [US3] Implement DsTooltip: Overlay-based on hover/focus with arrow pointer in lib/src/components/tooltip/ds_tooltip.dart
- [x] T095 [P] [US3] Implement DsPopover: Overlay-based panel triggered by click, dismissable in lib/src/components/popover/ds_popover.dart
- [x] T096 [P] [US3] Implement DsAvatar: circle with initials or image, DsAvatarStack for overlapping group in lib/src/components/avatar/ds_avatar.dart and lib/src/components/avatar_stack/ds_avatar_stack.dart
- [x] T097 [US3] Implement DsToggleGroup: segmented control with roving focus, Semantics(selected:) in lib/src/components/toggle_group/ds_toggle_group.dart
- [x] T098 [US3] Implement DsSuggestion: list of selectable suggestion items for autocomplete in lib/src/components/suggestion/ds_suggestion.dart
- [x] T099 [US3] Run `flutter test test/components/ds_card_test.dart test/components/ds_alert_test.dart test/components/ds_tabs_test.dart` and verify all US3 tests pass
- [x] T100 [US3] Run `flutter test test/golden/ds_display_golden_test.dart test/golden/ds_nav_interactive_golden_test.dart test/golden/ds_nav_data_golden_test.dart test/golden/ds_nav_overlay_golden_test.dart` and update golden files for US3

**Checkpoint**: Display and navigation components complete. Developer can build full dashboard views with cards, alerts, tabs, tables, and navigation.

---

## Phase 6: User Story 4 - Import a Custom Theme from Designsystemet CLI (Priority: P4)

**Goal**: Developer generates tokens via CLI, runs Dart code generator, and gets typed theme file with custom brand colors

**Independent Test**: Generate tokens from test config, run generator, verify output Dart file contains correct DsThemeData factory with matching color values

### Tests for User Story 4

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T101 [P] [US4] Write tests for DTCG JSON parser: parse color tokens, size tokens, border-radius tokens, typography tokens, handle light/dark schemes in test/generator/dtcg_parser_test.dart
- [x] T102 [P] [US4] Write tests for Dart code emitter: generated file compiles, contains light()/dark() factories with correct values in test/generator/dart_emitter_test.dart
- [x] T103 [P] [US4] Write end-to-end test for generate.dart CLI: test config → token dir → generated Dart file with expected color values in test/generator/generate_test.dart

### Implementation for User Story 4

- [x] T104 [US4] Implement DTCG JSON parser: reads design-tokens/ directory, parses W3C format ($value/$type), extracts color scales, sizes, border-radii, typography per theme per scheme (light/dark) in lib/src/generator/dtcg_parser.dart
- [x] T105 [US4] Implement Dart code emitter: generates formatted .dart file with DsThemeData factory constructors using parsed token values in lib/src/generator/dart_emitter.dart
- [x] T106 [US4] Implement bin/generate.dart CLI: parses --tokens-dir and --output args, orchestrates parser→emitter, handles errors with exit codes (0=success, 1=invalid args, 2=dir not found, 3=parse error) in bin/generate.dart
- [x] T107 [US4] Create test fixture: sample designsystemet.config.json and pre-generated design-tokens/ directory with known values for testing in test/generator/fixtures/
- [x] T108 [US4] Run `flutter test test/generator/` and verify all US4 tests pass

**Checkpoint**: Code generator complete. Developer can generate custom themes from Designsystemet CLI output.

---

## Phase 7: User Story 5 - Accessibility Compliance (Priority: P5)

**Goal**: All components meet WCAG 2.1 AA — semantics, focus indicators, keyboard navigation, contrast, reduced motion

**Independent Test**: Run automated accessibility checks on each component, verify Semantics presence, focus ring visibility, keyboard-only navigation

### Tests for User Story 5

- [ ] T109 [P] [US5] Write accessibility audit test: iterate all interactive components, verify each has Semantics widget with appropriate properties (label, button, textField, checked, selected, enabled) in test/components/accessibility_audit_test.dart
- [ ] T110 [P] [US5] Write focus indicator test: verify all focusable components show visible focus ring using borderStrong color when focused via keyboard in test/components/focus_indicator_test.dart
- [ ] T111 [P] [US5] Write roving focus test: verify DsTabs, DsRadio group, DsToggleGroup support arrow-key navigation within the group in test/components/roving_focus_test.dart
- [ ] T112 [P] [US5] Write reduced motion test: verify components suppress animations when MediaQuery.disableAnimations is true in test/components/reduced_motion_test.dart

### Implementation for User Story 5

- [ ] T113 [US5] Audit and fix Semantics on all US2 components (DsButton, DsTextfield, DsCheckbox, DsRadio, DsSwitch, DsInput, DsField) — ensure label, role, state properties are correct
- [ ] T114 [US5] Audit and fix Semantics on all US3 components (DsCard, DsAlert, DsTabs, DsDialog, DsSelect, DsToggleGroup) — ensure label, role, state properties are correct
- [ ] T115 [US5] Verify focus ring rendering on all interactive components — confirm borderStrong color and sufficient contrast
- [ ] T116 [US5] Verify reduced motion behavior — confirm all AnimatedContainer/animation durations are set to Duration.zero when disableAnimations is true
- [ ] T117 [US5] Run `flutter test test/components/accessibility_audit_test.dart test/components/focus_indicator_test.dart test/components/roving_focus_test.dart test/components/reduced_motion_test.dart` and verify all pass

**Checkpoint**: All components pass accessibility validation.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Form utilities, remaining components, barrel exports, example app, final validation

### Tests for Polish Components (write FIRST per Constitution Principle VI)

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T135 [P] Write widget tests for DsFieldset: legend rendering, child grouping, size, semantics in test/components/ds_fieldset_test.dart
- [ ] T136 [P] Write widget tests for DsErrorSummary: error list, links to fields, semantics in test/components/ds_error_summary_test.dart
- [ ] T137 [P] Write widget tests for DsDetails: expand/collapse, animation, reduced motion, semantics in test/components/ds_details_test.dart
- [ ] T138 [P] Write widget tests for DsList: ordered/unordered, nested, styling in test/components/ds_list_test.dart
- [ ] T139 [P] Write widget tests for DsSkeleton: shimmer animation, size variants, reduced motion in test/components/ds_skeleton_test.dart
- [ ] T140 [P] Write widget tests for DsSkipLink: visible on focus, navigates to target, semantics in test/components/ds_skip_link_test.dart
- [ ] T141 [P] Write golden tests for DsFieldset, DsErrorSummary, DsDetails, DsList, DsSkeleton, DsSkipLink (all states × 3 sizes) in test/golden/ds_utility_golden_test.dart

### Implementation for Polish Components

- [x] T118 [P] Implement DsFieldset: group of fields with legend in lib/src/components/fieldset/ds_fieldset.dart
- [x] T119 [P] Implement DsErrorSummary: list of form errors with links in lib/src/components/error_summary/ds_error_summary.dart
- [x] T120 [P] Implement DsDetails: expandable accordion with animation in lib/src/components/details/ds_details.dart
- [x] T121 [P] Implement DsList: ordered/unordered list with Designsystemet styling in lib/src/components/list/ds_list.dart
- [x] T122 [P] Implement DsSkeleton: loading placeholder with shimmer animation in lib/src/components/skeleton/ds_skeleton.dart
- [x] T123 [P] Implement DsSkipLink: accessibility skip-to-content link, visible on focus in lib/src/components/skip_link/ds_skip_link.dart
- [x] T124 Create components.dart barrel export for all 40 component widgets in lib/components.dart
- [x] T125 Create main barrel export komponentbibliotek_flutter.dart re-exporting theme.dart, components.dart, typography.dart in lib/komponentbibliotek_flutter.dart
- [x] T126 Build example/showcase app demonstrating all components with default Digdir theme and at least one custom theme in example/lib/main.dart
- [x] T127 Run `flutter analyze` and fix any warnings or errors to achieve 100% clean score
- [x] T128 Run full test suite `flutter test` and verify all tests pass
- [ ] T129 Validate quickstart.md steps by creating a fresh Flutter app and following the guide end-to-end
- [ ] T130 Verify tree-shaking: import only DsButton in a test app, confirm other components are not in the bundle
- [ ] T142 Add dartdoc comments with usage examples to all public widget APIs across lib/src/ (constitution Development Workflow mandate)
- [ ] T143 Profile state transitions (hover, focus, press) on DsButton, DsTextfield, DsCheckbox, DsTabs to verify 60fps on mid-range device (SC-008) in test/performance/state_transition_benchmark.dart
- [ ] T144 Run `flutter test test/golden/ds_utility_golden_test.dart` and update golden files for Phase 8 components

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup (Phase 1) completion — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational (Phase 2) — typography is the first MVP validation
- **US2 (Phase 4)**: Depends on Foundational (Phase 2) — can start in parallel with US1 but DsSpinner (US2) is used by DsButton
- **US3 (Phase 5)**: Depends on Foundational (Phase 2) — most components can start immediately; T089 (DsSelect) and T093 (DsSearch) require T060 (DsInput from US2)
- **US4 (Phase 6)**: Depends on Foundational (Phase 2) only — code generator is independent of component implementation
- **US5 (Phase 7)**: Depends on US2 + US3 completion — accessibility audit requires implemented components
- **Polish (Phase 8)**: Depends on US1 + US2 + US3 at minimum

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 — No dependencies on other stories
- **US2 (P2)**: Can start after Phase 2 — Independent but DsSpinner is used internally by DsButton
- **US3 (P3)**: Can start after Phase 2 for most components — **however T089 (DsSelect) and T093 (DsSearch) depend on T060 (DsInput from US2)**. DsCard, DsAlert, DsTabs, DsTag, DsChip, DsBadge, DsTooltip, DsPopover, DsAvatar, DsPagination, DsTable, DsBreadcrumbs are independent of US2
- **US4 (P4)**: Can start after Phase 2 — Code generator only depends on token data model classes
- **US5 (P5)**: Requires US2 + US3 — Cannot audit accessibility without implemented components

### Within Each User Story

- Tests MUST be written and FAIL before implementation (Constitution Principle VI)
- Simpler/leaf components before complex/composite components
- Base widgets (DsInput) before wrappers (DsTextfield, DsTextarea)
- All tests pass before checkpoint

### Parallel Opportunities

- All Setup tasks T003, T004 can run in parallel
- All Foundation test tasks T005–T013 can run in parallel
- All Foundation implementation tasks T014, T016–T021, T024–T027 can run in parallel (T015 depends on T014 same file; T022 depends on T016–T021)
- US1 and US4 can proceed fully in parallel (no dependencies between them)
- US2 test tasks T042–T055 can all run in parallel
- US2 implementation: T056–T059 in parallel, then T060, then T061–T063 in parallel, then T064–T067 in parallel
- US3 test tasks T070–T081 can all run in parallel
- US3 implementation: T082–T085 in parallel, then T086–T098 in dependency order
- Polish tasks T118–T123 can all run in parallel

---

## Parallel Example: User Story 2

```bash
# Launch all US2 tests together (they target different files):
Task T042: "Widget tests for DsInput in test/components/ds_input_test.dart"
Task T043: "Widget tests for DsTextfield in test/components/ds_textfield_test.dart"
Task T045: "Widget tests for DsButton in test/components/ds_button_test.dart"
Task T046: "Widget tests for DsCheckbox in test/components/ds_checkbox_test.dart"

# Launch independent US2 components together:
Task T056: "DsSpinner in lib/src/components/spinner/ds_spinner.dart"
Task T057: "DsDivider in lib/src/components/divider/ds_divider.dart"
Task T058: "DsLink in lib/src/components/link/ds_link.dart"
Task T059: "DsValidationMessage in lib/src/typography/ds_validation_message.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: User Story 1 (theme + typography)
4. **STOP and VALIDATE**: Test that DsTheme + DsHeading + DsParagraph render correctly
5. Publish 0.1.0-alpha if ready

### Incremental Delivery

1. Complete Setup + Foundational → Theme infrastructure ready
2. Add US1 → Theme + typography working → 0.1.0-alpha
3. Add US2 → Form components working → 0.2.0-alpha
4. Add US3 → Display/nav components → 0.3.0-alpha
5. Add US4 → Code generator → 0.4.0-alpha
6. Add US5 + Polish → Accessibility audited, example app → 1.0.0

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: US1 (typography) + US5 (accessibility audits)
   - Developer B: US2 (form components)
   - Developer C: US3 (display/nav components)
   - Developer D: US4 (code generator)
3. Stories complete and integrate independently
4. Polish phase as a team

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Tests MUST fail before implementing (Constitution Principle VI — NON-NEGOTIABLE)
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
