# Implementation Plan: Fix Documentation Site and Widgetbook Issues

**Branch**: `004-fix-docs-site` | **Date**: 2026-03-16 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/004-fix-docs-site/spec.md`

## Summary

The documentation site's Widgetbook component preview links are broken due to incorrect URL construction in the WidgetbookEmbed Vue component. The URL format is wrong in three ways: missing hash-based routing prefix (`#/`), not lowercasing/hyphenating path segments, and missing the required use-case name segment. Additionally, unused `:height` props need cleanup across 40 component docs, and the deployment pipeline needs minor resilience improvements.

Research confirmed that documentation content itself is complete and high quality (all 67 pages verified) — the work is focused on fixing the Widgetbook deep-link integration and cleanup.

## Technical Context

**Language/Version**: TypeScript (VitePress theme), Dart 3.3+ (Widgetbook app), YAML (GitHub Actions)
**Primary Dependencies**: VitePress 1.6.4, Widgetbook 3.22.0, Vue 3 (VitePress theme components)
**Storage**: N/A (static site)
**Testing**: Manual verification of deep-links; VitePress local dev server; local Widgetbook build
**Target Platform**: GitHub Pages (static web hosting)
**Project Type**: Documentation site + interactive component catalog
**Performance Goals**: N/A (static site)
**Constraints**: Must work with hash-based Flutter web routing; GitHub Pages base path `/komponentbibliotek-flutter/`
**Scale/Scope**: 40 component docs, 1 Vue component fix, 1 workflow file

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applicable | Status | Notes |
|-----------|-----------|--------|-------|
| I. Designsystemet Fidelity | No | Pass | Docs-only change, no component modifications |
| II. Token-Driven Architecture | No | Pass | No visual property changes |
| III. Theme Portability | No | Pass | No theme changes |
| IV. CLI-First Tooling | No | Pass | No token generation involved |
| V. Flutter-Idiomatic API | No | Pass | No library API changes |
| VI. Test-First Development | Partial | Pass | Documentation/infra fix — manual verification appropriate. No widget code changes requiring widget tests. |
| VII. Accessibility Compliance | No | Pass | No component changes; VitePress theme already uses ARIA roles in ComponentTabs.vue |

**Gate result: PASS** — This feature modifies only documentation infrastructure (Vue theme component, markdown files, workflow YAML). No library source code is changed. The test-first principle applies to widget development, not docs fixes.

## Project Structure

### Documentation (this feature)

```text
specs/004-fix-docs-site/
├── plan.md              # This file
├── research.md          # Widgetbook URL format research
├── data-model.md        # Path mapping and entity relationships
├── spec.md              # Feature specification
└── checklists/
    └── requirements.md  # Spec quality checklist
```

### Source Code (files to modify)

```text
site/.vitepress/theme/
└── WidgetbookEmbed.vue          # Fix URL construction (PRIMARY FIX)

site/nb/komponenter/
├── ds-alert.md                  # Update component prop, remove :height (×40 files)
├── ds-avatar.md
├── ds-avatar-stack.md
├── ...                          # (all 40 component docs)
└── ds-validation-message.md

.github/workflows/
└── deploy-widgetbook.yml        # Minor resilience improvements
```

**Structure Decision**: No new files or directories needed. All changes are modifications to existing files.

## Implementation Phases

### Phase A: Fix WidgetbookEmbed URL Construction (P1 — FR-001, FR-003)

**File**: `site/.vitepress/theme/WidgetbookEmbed.vue`

**Current code** (broken):
```typescript
const widgetbookUrl = computed(() => {
  const path = encodeURIComponent(props.component)
  return `${baseUrl}widgetbook/?path=${path}`
})
```

**Fix**: Transform the path to match Widgetbook's routing:
1. Replace spaces with hyphens
2. Lowercase the entire path
3. Use hash-based URL format (`#/?path=`)

```typescript
const widgetbookUrl = computed(() => {
  const path = props.component
    .replace(/ /g, '-')
    .toLowerCase()
  return `${baseUrl}widgetbook/#/?path=${encodeURIComponent(path)}`
})
```

**Also**: Remove the `height` prop from the component definition since it's unused:
```typescript
// Before
const props = defineProps<{
  component: string
  height?: number
}>()

// After
const props = defineProps<{
  component: string
}>()
```

### Phase B: Update Component Doc WidgetbookEmbed Props (P1 — FR-004, FR-010)

**Files**: All 40 `site/nb/komponenter/ds-*.md` files

Two changes per file:
1. **Add use case name** to the `component` prop (append `/Standard` since all components have a "Standard" use case as their first/default)
2. **Remove `:height` prop** (unused since iframe→link card migration)

**Before** (example from `ds-button.md`):
```html
<WidgetbookEmbed component="Kjernekomponenter/DsButton" :height="200" />
```

**After**:
```html
<WidgetbookEmbed component="Kjernekomponenter/DsButton/Standard" />
```

**Complete mapping** (40 files):

| File | Current `component` | Updated `component` |
|------|-------------------|-------------------|
| ds-alert.md | `Kjernekomponenter/DsAlert` | `Kjernekomponenter/DsAlert/Standard` |
| ds-avatar.md | `Navigasjon og layout/DsAvatar` | `Navigasjon og layout/DsAvatar/Standard` |
| ds-avatar-stack.md | `Navigasjon og layout/DsAvatarStack` | `Navigasjon og layout/DsAvatarStack/Standard` |
| ds-badge.md | `Kjernekomponenter/DsBadge` | `Kjernekomponenter/DsBadge/Standard` |
| ds-breadcrumbs.md | `Navigasjon og layout/DsBreadcrumbs` | `Navigasjon og layout/DsBreadcrumbs/Standard` |
| ds-button.md | `Kjernekomponenter/DsButton` | `Kjernekomponenter/DsButton/Standard` |
| ds-card.md | `Kjernekomponenter/DsCard` | `Kjernekomponenter/DsCard/Standard` |
| ds-checkbox.md | `Kjernekomponenter/DsCheckbox` | `Kjernekomponenter/DsCheckbox/Standard` |
| ds-chip.md | `Kjernekomponenter/DsChip` | `Kjernekomponenter/DsChip/Standard` |
| ds-details.md | `Skjema og verktøy/DsDetails` | `Skjema og verktøy/DsDetails/Standard` |
| ds-dialog.md | `Navigasjon og layout/DsDialog` | `Navigasjon og layout/DsDialog/Standard` |
| ds-divider.md | `Kjernekomponenter/DsDivider` | `Kjernekomponenter/DsDivider/Standard` |
| ds-dropdown.md | `Navigasjon og layout/DsDropdown` | `Navigasjon og layout/DsDropdown/Standard` |
| ds-error-summary.md | `Skjema og verktøy/DsErrorSummary` | `Skjema og verktøy/DsErrorSummary/Standard` |
| ds-field.md | `Skjema og verktøy/DsField` | `Skjema og verktøy/DsField/Standard` |
| ds-fieldset.md | `Skjema og verktøy/DsFieldset` | `Skjema og verktøy/DsFieldset/Standard` |
| ds-heading.md | `Typografi/DsHeading` | `Typografi/DsHeading/Standard` |
| ds-input.md | `Skjema og verktøy/DsInput` | `Skjema og verktøy/DsInput/Standard` |
| ds-label.md | `Typografi/DsLabel` | `Typografi/DsLabel/Standard` |
| ds-link.md | `Kjernekomponenter/DsLink` | `Kjernekomponenter/DsLink/Standard` |
| ds-list.md | `Skjema og verktøy/DsList` | `Skjema og verktøy/DsList/Standard` |
| ds-pagination.md | `Navigasjon og layout/DsPagination` | `Navigasjon og layout/DsPagination/Standard` |
| ds-paragraph.md | `Typografi/DsParagraph` | `Typografi/DsParagraph/Standard` |
| ds-popover.md | `Navigasjon og layout/DsPopover` | `Navigasjon og layout/DsPopover/Standard` |
| ds-radio.md | `Kjernekomponenter/DsRadio` | `Kjernekomponenter/DsRadio/Standard` |
| ds-search.md | `Navigasjon og layout/DsSearch` | `Navigasjon og layout/DsSearch/Standard` |
| ds-select.md | `Navigasjon og layout/DsSelect` | `Navigasjon og layout/DsSelect/Standard` |
| ds-skeleton.md | `Skjema og verktøy/DsSkeleton` | `Skjema og verktøy/DsSkeleton/Standard` |
| ds-skip-link.md | `Skjema og verktøy/DsSkipLink` | `Skjema og verktøy/DsSkipLink/Standard` |
| ds-spinner.md | `Kjernekomponenter/DsSpinner` | `Kjernekomponenter/DsSpinner/Standard` |
| ds-suggestion.md | `Navigasjon og layout/DsSuggestion` | `Navigasjon og layout/DsSuggestion/Standard` |
| ds-switch.md | `Kjernekomponenter/DsSwitch` | `Kjernekomponenter/DsSwitch/Standard` |
| ds-table.md | `Navigasjon og layout/DsTable` | `Navigasjon og layout/DsTable/Standard` |
| ds-tabs.md | `Navigasjon og layout/DsTabs` | `Navigasjon og layout/DsTabs/Standard` |
| ds-tag.md | `Kjernekomponenter/DsTag` | `Kjernekomponenter/DsTag/Standard` |
| ds-textarea.md | `Kjernekomponenter/DsTextarea` | `Kjernekomponenter/DsTextarea/Standard` |
| ds-textfield.md | `Kjernekomponenter/DsTextfield` | `Kjernekomponenter/DsTextfield/Standard` |
| ds-toggle-group.md | `Navigasjon og layout/DsToggleGroup` | `Navigasjon og layout/DsToggleGroup/Standard` |
| ds-tooltip.md | `Navigasjon og layout/DsTooltip` | `Navigasjon og layout/DsTooltip/Standard` |
| ds-validation-message.md | `Typografi/DsValidationMessage` | `Typografi/DsValidationMessage/Standard` |

### Phase C: Deployment Pipeline Improvements (P4 — FR-009)

**File**: `.github/workflows/deploy-widgetbook.yml`

Minor resilience improvements:
1. Add a verification step after Widgetbook build to confirm `widgetbook/build/web/index.html` exists
2. Pin `subosito/flutter-action` to a specific version tag for reproducible builds

### Phase D: Verification

1. Build VitePress locally (`cd site && npm run dev`) and verify:
   - All component pages render correctly
   - WidgetbookEmbed link cards display with correct text
   - No console errors
2. Build Widgetbook locally (`cd widgetbook && flutter build web --base-href /`) and verify:
   - Widgetbook loads and renders all 40 components
   - URL hash routing works (manually test a few paths)
3. Verify generated URLs match expected format:
   - `widgetbook/#/?path=kjernekomponenter%2Fdsbutton%2Fstandard`
   - `widgetbook/#/?path=navigasjon-og-layout%2Fdstabs%2Fstandard`

## Complexity Tracking

No constitution violations. No complexity justification needed.

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Widgetbook URL format changes in future version | Low | Medium | The WidgetbookEmbed transformation mirrors Widgetbook's own `path` getter logic. Pin Widgetbook version in pubspec. |
| Some components have non-"Standard" first use case | Low | Low | Audit confirmed all 40 components have "Standard" as a use case name. |
| Hash routing conflicts with VitePress | Very Low | High | VitePress docs and Widgetbook are separate apps at different paths — no routing overlap. |
