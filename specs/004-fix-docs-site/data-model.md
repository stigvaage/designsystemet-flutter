# Data Model: Fix Documentation Site and Widgetbook Issues

**Date**: 2026-03-16
**Branch**: `004-fix-docs-site`

## Entities

### WidgetbookEmbed Props

The Vue component that links documentation pages to Widgetbook previews.

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| component | string | Yes | Widgetbook path: `Folder/ComponentName/UseCaseName` (original casing — Vue component handles lowercasing and hyphenation) |

**Removed properties:**
- `height` (number, optional) — remnant from iframe implementation, no longer used by the link card

### Widgetbook Path Mapping

Each component documentation page maps to a Widgetbook deep-link path.

| Documentation File | WidgetbookEmbed `component` | Resolved URL path |
|---|---|---|
| `ds-button.md` | `Kjernekomponenter/DsButton/Standard` | `kjernekomponenter/dsbutton/standard` |
| `ds-tabs.md` | `Navigasjon og layout/DsTabs/Standard` | `navigasjon-og-layout/dstabs/standard` |
| `ds-field.md` | `Skjema og verktøy/DsField/Standard` | `skjema-og-verktøy/dsfield/standard` |
| `ds-heading.md` | `Typografi/DsHeading/Standard` | `typografi/dsheading/standard` |

**Transformation rules** (applied by WidgetbookEmbed Vue component):
1. Replace spaces with hyphens
2. Lowercase entire string
3. Prepend base URL and hash fragment: `{base}widgetbook/#/?path={encoded}`

### Component-to-Folder Category Map

40 components across 4 Widgetbook folders. This mapping must be consistent between:
- `widgetbook/lib/widgetbook.dart` (Widgetbook folder structure)
- `site/nb/komponenter/*.md` (WidgetbookEmbed `component` prop values)

| Folder | Components (14) |
|--------|----------------|
| Kjernekomponenter | DsButton, DsTextfield, DsTextarea, DsCheckbox, DsRadio, DsSwitch, DsAlert, DsCard, DsTag, DsChip, DsBadge, DsSpinner, DsDivider, DsLink |
| Navigasjon og layout | DsTabs, DsDialog, DsDropdown, DsSelect, DsPagination, DsTable, DsBreadcrumbs, DsSearch, DsTooltip, DsPopover, DsAvatar, DsAvatarStack, DsToggleGroup, DsSuggestion |
| Skjema og verktøy (8) | DsField, DsFieldset, DsInput, DsErrorSummary, DsDetails, DsList, DsSkeleton, DsSkipLink |
| Typografi (4) | DsHeading, DsParagraph, DsLabel, DsValidationMessage |

### URL Structure

```
https://stigvaage.github.io/komponentbibliotek-flutter/
├── (VitePress docs root)
├── komponenter/ds-button.html      → Documentation page
├── widgetbook/                     → Flutter web app
│   ├── index.html                  → Widgetbook entry point
│   └── #/?path=kjernekomponenter%2Fdsbutton%2Fstandard  → Deep-link
```
