# Implementation Plan: Designsystemet Flutter Component Library

**Branch**: `001-designsystemet-flutter-lib` | **Date**: 2026-03-14 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-designsystemet-flutter-lib/spec.md`

## Summary

Build `komponentbibliotek_flutter`, a Flutter component library that faithfully implements the Norwegian Designsystemet (designsystemet.no). The library provides a complete token-driven theme infrastructure (colors, typography, sizes, shadows, border-radii), 40 accessible components across 4 priority tiers, scoped color/size overrides via InheritedWidgets, and a code generator that converts W3C JSON tokens from the Designsystemet CLI into typed Dart theme classes. All components are built without Material/Cupertino visual dependencies and meet WCAG 2.1 AA accessibility standards.

## Technical Context

**Language/Version**: Dart 3.3+ (null-safe, pattern matching, sealed classes)
**Framework**: Flutter 3.19+ (latest stable channel)
**Primary Dependencies**: `package:flutter/widgets.dart`, `package:flutter/rendering.dart` (no Material/Cupertino visual deps); Inter font bundled as package asset
**Storage**: N/A (client-side UI library)
**Testing**: `flutter_test` for widget tests, golden file tests for visual regression, `integration_test` for end-to-end flows
**Target Platform**: Android, iOS, Web, macOS, Linux, Windows (all Flutter platforms)
**Project Type**: Library (Dart package published to pub.dev)
**Performance Goals**: 60fps during state transitions on mid-range mobile devices
**Constraints**: No Material/Cupertino widget styling; tree-shakable; Inter font bundled (~1MB); offline-capable
**Scale/Scope**: 40 components, 5 token categories, 9 color scales × 16 tokens each, 3 size modes, light/dark schemes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | Designsystemet Fidelity | PASS | SC-002 requires visual identity with storybook.designsystemet.no; all components port from the reference CSS/React implementation |
| II | Token-Driven Architecture | PASS | FR-006 through FR-014 define complete token system; FR-001 aggregates all tokens in DsThemeData; no hardcoded values permitted |
| III | Theme Portability | PASS | US4 + FR-025/026/027 define CLI-to-Dart code generator pipeline; FR-002 provides ThemeExtension integration |
| IV | CLI-First Tooling | PASS | FR-025 uses `@digdir/designsystemet` CLI for token generation; `bin/generate.dart` consumes CLI output |
| V | Flutter-Idiomatic API | PASS | FR-021 defines Widget-based API with InheritedWidget theming; FR-032 constrains to widgets.dart/rendering.dart; Effective Dart style enforced via flutter_lints |
| VI | Test-First Development | PASS | SC-005 requires golden tests for every component/state; constitution mandates red-green-refactor cycle |
| VII | Accessibility Compliance | PASS | FR-028 through FR-031 cover semantics, focus, keyboard nav, reduced motion; SC-003 requires automated accessibility validation |

**Gate result**: ALL PASS — proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/001-designsystemet-flutter-lib/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (public API contracts)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── komponentbibliotek_flutter.dart        # Barrel export
├── src/
│   ├── theme/
│   │   ├── ds_theme.dart                  # DsTheme InheritedWidget + ThemeExtension
│   │   ├── ds_theme_data.dart             # DsThemeData (all tokens)
│   │   ├── ds_color_scheme.dart           # DsColorScheme (9 named + custom scales)
│   │   ├── ds_color_scale.dart            # DsColorScale (16 tokens per scale)
│   │   ├── ds_size_tokens.dart            # DsSizeTokens (size0–size30)
│   │   ├── ds_typography.dart             # DsTypography (headings, body styles)
│   │   ├── ds_border_radius_tokens.dart   # DsBorderRadiusTokens
│   │   ├── ds_shadow_tokens.dart          # DsShadowTokens (xs–xl)
│   │   ├── ds_color_scope.dart            # DsColorScope InheritedWidget
│   │   └── ds_size_scope.dart             # DsSizeScope InheritedWidget
│   ├── components/
│   │   ├── button/ds_button.dart
│   │   ├── alert/ds_alert.dart
│   │   ├── card/
│   │   │   ├── ds_card.dart
│   │   │   ├── ds_card_header.dart
│   │   │   ├── ds_card_block.dart
│   │   │   └── ds_card_footer.dart
│   │   ├── textfield/ds_textfield.dart
│   │   ├── textarea/ds_textarea.dart
│   │   ├── checkbox/ds_checkbox.dart
│   │   ├── radio/ds_radio.dart
│   │   ├── switch/ds_switch.dart
│   │   ├── tag/ds_tag.dart
│   │   ├── chip/ds_chip.dart
│   │   ├── badge/ds_badge.dart
│   │   ├── spinner/ds_spinner.dart
│   │   ├── divider/ds_divider.dart
│   │   ├── link/ds_link.dart
│   │   ├── tabs/ds_tabs.dart
│   │   ├── dialog/ds_dialog.dart
│   │   ├── dropdown/ds_dropdown.dart
│   │   ├── select/ds_select.dart
│   │   ├── pagination/ds_pagination.dart
│   │   ├── table/ds_table.dart
│   │   ├── breadcrumbs/ds_breadcrumbs.dart
│   │   ├── search/ds_search.dart
│   │   ├── tooltip/ds_tooltip.dart
│   │   ├── popover/ds_popover.dart
│   │   ├── avatar/ds_avatar.dart
│   │   ├── avatar_stack/ds_avatar_stack.dart
│   │   ├── toggle_group/ds_toggle_group.dart
│   │   ├── suggestion/ds_suggestion.dart
│   │   ├── field/ds_field.dart
│   │   ├── fieldset/ds_fieldset.dart
│   │   ├── input/ds_input.dart
│   │   ├── error_summary/ds_error_summary.dart
│   │   ├── details/ds_details.dart
│   │   ├── list/ds_list.dart
│   │   ├── skeleton/ds_skeleton.dart
│   │   └── skip_link/ds_skip_link.dart
│   ├── typography/
│   │   ├── ds_heading.dart
│   │   ├── ds_paragraph.dart
│   │   ├── ds_label.dart
│   │   └── ds_validation_message.dart
│   ├── utils/
│   │   ├── ds_enums.dart                  # DsSize, DsColor, DsSeverity, etc.
│   │   ├── ds_focus.dart                  # Focus ring decoration utility
│   │   └── ds_animation.dart              # Transition constants + reduced motion
│   └── generator/
│       ├── dtcg_parser.dart               # W3C DTCG JSON token parser
│       └── dart_emitter.dart              # Dart theme file code emitter
├── generated/
│   └── ds_theme_digdir.dart               # Built-in Digdir theme (hard-coded)
└── fonts/
    ├── Inter-Regular.ttf                  # Weight 400
    ├── Inter-Medium.ttf                   # Weight 500
    └── Inter-SemiBold.ttf                 # Weight 600

bin/
└── generate.dart                          # CLI: dart run komponentbibliotek_flutter:generate

test/
├── theme/
│   ├── ds_theme_test.dart
│   ├── ds_color_scale_test.dart
│   ├── ds_size_tokens_test.dart
│   └── ds_typography_test.dart
├── components/
│   ├── ds_button_test.dart
│   ├── ds_alert_test.dart
│   └── ...                                # One test file per component
├── golden/
│   ├── ds_button_golden_test.dart
│   └── ...                                # One golden test file per component
├── generator/
│   └── generate_test.dart                 # Code generator tests
└── performance/
    └── state_transition_benchmark.dart    # 60fps validation (SC-008)

example/
└── lib/
    └── main.dart                          # Showcase app
```

**Material context note**: Constitution Principle V states components "MUST support both Material and Cupertino contexts." This means components work correctly when placed inside a `MaterialApp` or `CupertinoApp` — achieved via the `ThemeExtension<DsThemeData>` integration. It does NOT mean components depend on Material/Cupertino widgets for visual rendering (FR-032 prohibits that). Components use only `package:flutter/widgets.dart` and `package:flutter/rendering.dart` for their visual implementation.

**Structure Decision**: Single Dart package structure following pub.dev conventions. The `lib/src/` directory is organized by concern (theme, components, typography, utils) with each component in its own directory. The `bin/` directory hosts the code generator CLI tool. The `generated/` directory under `lib/` contains theme files produced by the generator (the default Digdir theme is pre-generated and committed). Fonts are bundled in `lib/fonts/`.

## Constitution Re-Check (Post Phase 1 Design)

| # | Principle | Status | Post-Design Evidence |
|---|-----------|--------|---------------------|
| I | Designsystemet Fidelity | PASS | Research confirms DTCG token names map 1:1 to DsColorScale fields; CSS class patterns documented for porting; `cv05` font feature included |
| II | Token-Driven Architecture | PASS | All 16 color tokens per scale mapped; size computation documented; border-radius derived from config; no hardcoded values in data model |
| III | Theme Portability | PASS | Code generator contract defined (input: DTCG JSON, output: typed Dart theme files); config override structure documented |
| IV | CLI-First Tooling | PASS | Generator consumes CLI output directly; documented CLI commands and config format |
| V | Flutter-Idiomatic API | PASS | Public API contract uses Widget subclasses, InheritedWidget, ThemeExtension; follows Effective Dart naming |
| VI | Test-First Development | PASS | Test directory structure defined; golden tests per component/state; red-green-refactor enforced by constitution |
| VII | Accessibility Compliance | PASS | Component implementation strategy includes Semantics wrapping, FocusNode management, reduced motion check, roving focus pattern |

**Post-design gate result**: ALL PASS — proceed to task generation.

## Complexity Tracking

> No constitution violations detected — table not needed.
