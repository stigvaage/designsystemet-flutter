# Research: Fix Documentation Site and Widgetbook Issues

**Date**: 2026-03-16
**Branch**: `004-fix-docs-site`

## R1: Widgetbook 3.x Deep-Link URL Format

### Decision
The WidgetbookEmbed Vue component must construct URLs using Widgetbook's hash-based routing with lowercase, hyphenated, three-segment paths.

### Rationale
Widgetbook 3.x (version 3.22.0, installed via `^3.10.0`) uses hash-based URL routing by default. The `path` query parameter value is computed by `WidgetbookNode.path` (in `widgetbook_node.dart` lines 47-52) with these transformations:

1. Collect node names from root to leaf: `['', 'FolderName', 'ComponentName', 'UseCaseName']`
2. Join with `/`: `/FolderName/ComponentName/UseCaseName`
3. Replace spaces with hyphens: `/Folder-Name/Component-Name/Use-Case-Name`
4. Lowercase everything: `/folder-name/component-name/use-case-name`
5. Remove leading `/`: `folder-name/component-name/use-case-name`

The path **must include the use case name** (third segment). Widgetbook's `WidgetbookRoot.table` only maps paths to leaf `WidgetbookUseCase` nodes — a two-segment path (folder/component) will not match anything.

The full URL format is:
```
<base-url>widgetbook/#/?path=<encoded-path>
```

### Current Bug (3 issues)
The WidgetbookEmbed Vue component currently constructs:
```
/komponentbibliotek-flutter/widgetbook/?path=Kjernekomponenter%2FDsButton
```

This is wrong because:
1. **Missing `#/` hash prefix** — Flutter web uses hash routing (`/#/?path=...`)
2. **Not lowercased** — `Kjernekomponenter` should be `kjernekomponenter`, `DsButton` should be `dsbutton`
3. **Missing use case name** — must include third segment (e.g., `/standard`)

### Correct URLs (examples)

| Component | Current (broken) | Correct |
|-----------|-----------------|---------|
| DsButton | `widgetbook/?path=Kjernekomponenter%2FDsButton` | `widgetbook/#/?path=kjernekomponenter%2Fdsbutton%2Fstandard` |
| DsTabs | `widgetbook/?path=Navigasjon%20og%20layout%2FDsTabs` | `widgetbook/#/?path=navigasjon-og-layout%2Fdstabs%2Fstandard` |
| DsButton (med ikon) | N/A | `widgetbook/#/?path=kjernekomponenter%2Fdsbutton%2Fmed-ikon` |

### Additional URL Parameters
- `preview` — triggers preview mode (no panels)
- `panels=navigation,addons,knobs` — controls visible panels
- `q` — search query

### Alternatives Considered
- **Reverting to iframe embed**: Rejected — the link card approach was an intentional design decision. Iframes have CORS, sizing, and performance issues with Flutter web apps.
- **Using Widgetbook's path URL strategy**: Rejected — would require adding `usePathUrlStrategy()` to the Widgetbook app, which may conflict with the GitHub Pages base-href setup.

### Source Files Verified
- `.pub-cache/hosted/pub.dev/widgetbook-3.22.0/lib/src/navigation/nodes/widgetbook_node.dart` (path getter)
- `.pub-cache/hosted/pub.dev/widgetbook-3.22.0/lib/src/routing/app_route_config.dart` (query param parsing)
- `.pub-cache/hosted/pub.dev/widgetbook-3.22.0/lib/src/navigation/nodes/widgetbook_root.dart` (path-to-usecase lookup)

---

## R2: Documentation Content Audit

### Decision
Documentation content is complete and consistent — no missing pages, broken links, or empty sections found. Focus shifts from "fix missing content" to "verify accuracy and clean up WidgetbookEmbed props."

### Rationale
Comprehensive audit of all 67 markdown files in `site/nb/`:

- **40 component pages**: All have complete three-tab structure (Oversikt, Kode, Tilgjengelighet) with usage guidelines, code examples, property tables, and accessibility info.
- **10 getting-started pages**: All substantive and complete.
- **5 pattern pages** + index: Complete with code examples.
- **7 best-practices pages** + index: Comprehensive guidelines.
- **2 intro pages**: Present and complete.
- **All index pages**: Properly structured with navigation grids.
- **Internal links**: All verified to resolve correctly.
- **Code examples**: All use correct import paths (`package:komponentbibliotek_flutter/components.dart`).

### Remaining Work
- Remove unused `:height` prop from all 40 WidgetbookEmbed usages
- Update `component` prop values to include use case name (e.g., `Kjernekomponenter/DsButton/Standard`)

### Alternatives Considered
- **Rewriting all component docs**: Rejected — audit showed existing content is already high quality. Would be unnecessary churn.

---

## R3: Deployment Pipeline Analysis

### Decision
The deployment pipeline is fundamentally sound (latest builds succeed). Minor improvements for resilience but no critical fixes needed.

### Rationale
Analysis of recent GitHub Actions runs:
- 8 of 10 recent runs succeeded
- 2 failures were for specific feature commits (MCP server, Lucide icons) — transient build issues, not pipeline problems
- All failures were resolved in subsequent commits

**Pipeline architecture is correct:**
- VitePress builds docs site
- Widgetbook builds Flutter web app with `--base-href /komponentbibliotek-flutter/widgetbook/`
- Widgetbook output is copied into VitePress dist at `/widgetbook/`
- Combined output deployed to GitHub Pages via `actions/deploy-pages@v4`

**The `$FLUTTER_BASE_HREF` substitution works correctly** — `flutter build web --base-href` replaces the token in the built `index.html` at build time. The source file `widgetbook/web/index.html` contains the placeholder, but the build output has the correct value.

**`.nojekyll` is not needed** — the `actions/upload-pages-artifact` + `actions/deploy-pages` deployment path bypasses Jekyll processing entirely.

### Potential Improvements (low priority)
- Pin `subosito/flutter-action` to a specific version for reproducible builds
- Add build verification step (check that `widgetbook/build/web/` exists before copy)

### Alternatives Considered
- **Switching to a different deployment method**: Rejected — current GitHub Actions approach is standard and working.
- **Splitting into separate workflows**: Rejected — single workflow ensures atomic deployment of both sites.
