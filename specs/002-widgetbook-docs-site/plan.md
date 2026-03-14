# Implementation Plan: Widgetbook Component Catalog & Documentation Site

**Branch**: `002-widgetbook-docs-site` | **Date**: 2026-03-14 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-widgetbook-docs-site/spec.md`

## Summary

Set up Widgetbook as an interactive component catalog for `komponentbibliotek_flutter`, covering all 40 Designsystemet components with configurable knobs (size, color, variant, state), theme switching (light/dark), and Norwegian-language descriptions. Deploy automatically to GitHub Pages via GitHub Actions.

## Technical Context

**Language/Version**: Dart 3.3+ / Flutter 3.19+ (matches library)
**Primary Dependencies**: `widgetbook` (latest stable), `widgetbook_annotation`, `widgetbook_generator` (for code-gen approach), `build_runner`
**Storage**: N/A (static web app)
**Testing**: Manual visual verification; Widgetbook golden image addon (optional)
**Target Platform**: Flutter Web (compiled to JS/WASM, hosted on GitHub Pages)
**Project Type**: Flutter web application (Widgetbook catalog)
**Performance Goals**: Site interactive within 5 seconds on broadband
**Constraints**: Static hosting only (GitHub Pages); no server-side rendering
**Scale/Scope**: 40 component use cases, ~120 knobs total, 2 themes, 9 color scopes, 3 size modes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | Designsystemet Fidelity | PASS | Widgetbook renders actual library widgets — visual fidelity is inherent |
| II | Token-Driven Architecture | PASS | Previews use DsThemeData with real tokens; no hardcoded values in catalog |
| III | Theme Portability | PASS | Theme switching demonstrates portability (light/dark Digdir themes) |
| IV | CLI-First Tooling | N/A | Catalog is a presentation layer; no token generation involved |
| V | Flutter-Idiomatic API | PASS | Widgetbook is a standard Flutter app using the library's public API |
| VI | Test-First Development | PASS | Each Widgetbook use case serves as a visual test; golden addon available |
| VII | Accessibility Compliance | PASS | Widgetbook's accessibility addon can verify semantics in previews |

**Gate result**: ALL PASS — proceed.

## Project Structure

### Documentation (this feature)

```text
specs/002-widgetbook-docs-site/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
widgetbook/
├── lib/
│   ├── main.dart                          # Widgetbook app entry point
│   ├── widgetbook.dart                    # Generated or manual component registry
│   ├── components/
│   │   ├── button.dart                    # DsButton use cases + knobs
│   │   ├── alert.dart                     # DsAlert use cases + knobs
│   │   ├── card.dart                      # DsCard use cases + knobs
│   │   ├── textfield.dart                 # DsTextfield use cases + knobs
│   │   ├── checkbox.dart                  # DsCheckbox use cases + knobs
│   │   ├── radio.dart                     # DsRadio use cases + knobs
│   │   ├── switch.dart                    # DsSwitch use cases + knobs
│   │   ├── tag.dart                       # DsTag use cases + knobs
│   │   ├── chip.dart                      # DsChip use cases + knobs
│   │   ├── badge.dart                     # DsBadge use cases + knobs
│   │   ├── spinner.dart                   # DsSpinner use cases
│   │   ├── divider.dart                   # DsDivider use cases
│   │   ├── link.dart                      # DsLink use cases + knobs
│   │   ├── tabs.dart                      # DsTabs use cases + knobs
│   │   ├── dialog.dart                    # DsDialog use cases
│   │   ├── dropdown.dart                  # DsDropdown use cases
│   │   ├── select.dart                    # DsSelect use cases + knobs
│   │   ├── pagination.dart                # DsPagination use cases + knobs
│   │   ├── table.dart                     # DsTable use cases
│   │   ├── breadcrumbs.dart               # DsBreadcrumbs use cases
│   │   ├── search.dart                    # DsSearch use cases
│   │   ├── tooltip.dart                   # DsTooltip use cases
│   │   ├── popover.dart                   # DsPopover use cases
│   │   ├── avatar.dart                    # DsAvatar use cases + knobs
│   │   ├── toggle_group.dart              # DsToggleGroup use cases + knobs
│   │   ├── field.dart                     # DsField use cases + knobs
│   │   ├── fieldset.dart                  # DsFieldset use cases
│   │   ├── error_summary.dart             # DsErrorSummary use cases
│   │   ├── details.dart                   # DsDetails use cases
│   │   ├── list.dart                      # DsList use cases
│   │   ├── skeleton.dart                  # DsSkeleton use cases
│   │   ├── skip_link.dart                 # DsSkipLink use cases
│   │   └── typography.dart                # DsHeading, DsParagraph, DsLabel, DsValidationMessage
│   └── helpers/
│       ├── theme_addon.dart               # Custom theme addon (light/dark Digdir)
│       ├── color_scope_addon.dart          # DsColorScope knob
│       └── size_scope_addon.dart           # DsSizeScope knob
├── pubspec.yaml                           # Widgetbook app dependencies
└── web/
    └── index.html                         # Flutter web shell

.github/
└── workflows/
    └── deploy-widgetbook.yml              # GitHub Actions: build + deploy to Pages
```

**Structure Decision**: Separate `widgetbook/` directory at repo root — a standalone Flutter web app that depends on the main library package via path dependency. This keeps the catalog code separate from library source while sharing the same repo.

## Constitution Re-Check (Post Phase 1 Design)

| # | Principle | Status | Post-Design Evidence |
|---|-----------|--------|---------------------|
| I | Designsystemet Fidelity | PASS | Use cases render actual library widgets with real DsThemeData tokens |
| II | Token-Driven Architecture | PASS | Theme addon applies DsThemeDigdir.light()/dark() — all tokens are real |
| III | Theme Portability | PASS | Users can switch themes live, demonstrating portability |
| IV | CLI-First Tooling | N/A | No token generation in this feature |
| V | Flutter-Idiomatic API | PASS | Standard Widgetbook Flutter app pattern |
| VI | Test-First Development | PASS | Use cases serve as visual regression baselines |
| VII | Accessibility Compliance | PASS | Widgetbook accessibility addon available for auditing |

**Post-design gate result**: ALL PASS.

## Complexity Tracking

> No constitution violations detected — table not needed.
