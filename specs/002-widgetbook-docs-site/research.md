# Research: Widgetbook Component Catalog & Documentation Site

**Feature**: 002-widgetbook-docs-site
**Date**: 2026-03-14

## 1. Widgetbook Framework Selection

### Decision: Use Widgetbook (manual approach, not code-gen)

**Rationale**: Widgetbook is the industry-standard Flutter component catalog tool, equivalent to Storybook for React. The manual approach (writing use cases directly) is preferred over the annotation/code-gen approach because:
- Simpler setup with fewer dependencies
- Full control over how each component is presented
- No build_runner overhead
- Easier to add Norwegian-language descriptions

**Alternatives considered**:
- `storybook_flutter` → less mature, smaller community, fewer features
- Custom showcase app → already exists in `example/`, but lacks knobs, theme switching, search
- Docusaurus/VitePress + static screenshots → no live interaction, not Flutter-native

## 2. Widgetbook App Structure

### Decision: Separate `widgetbook/` directory with path dependency

**Rationale**: Keeping the Widgetbook app in a separate directory (`widgetbook/`) with a path dependency to the main library keeps catalog code cleanly separated while sharing the same repo. This is the recommended Widgetbook pattern for monorepo setups.

**Alternatives considered**:
- Put Widgetbook in `example/` → conflicts with existing example app; different purpose
- Separate repository → harder to keep in sync; no path dependency

## 3. Theme & Scope Addons

### Decision: Custom addons for DsTheme, DsColorScope, and DsSizeScope

**Rationale**: Widgetbook supports custom addons that wrap all previews. Creating three addons:
1. **Theme addon**: Wraps preview in `DsTheme(data: ...)` with light/dark toggle
2. **Color scope addon**: Wraps preview in `DsColorScope(color: ...)` with dropdown for all 9 color scales
3. **Size scope addon**: Wraps preview in `DsSizeScope(size: ...)` with sm/md/lg toggle

This matches how the library's scoping system works and gives users the exact same experience they'd have in a real app.

**Alternatives considered**:
- Use Widgetbook's built-in theme addon → doesn't know about DsThemeData/DsColorScope
- Per-component knobs only → loses the global scoping demonstration

## 4. GitHub Pages Deployment

### Decision: GitHub Actions workflow building Flutter web and deploying to Pages

**Rationale**: GitHub Pages is free, integrated with the repo, and supports custom domains. The workflow:
1. Checkout repo
2. Setup Flutter
3. `flutter build web` in `widgetbook/` directory
4. Deploy `widgetbook/build/web/` to GitHub Pages

The site URL will be `https://stigvaage.github.io/komponentbibliotek-flutter/`.

**Alternatives considered**:
- Vercel/Netlify → free tier available but adds external dependency
- Firebase Hosting → requires Google Cloud setup
- Manual deployment → error-prone, doesn't auto-update

## 5. Component Use Case Pattern

### Decision: One file per component with knobs for key props

**Rationale**: Each component gets a dedicated file in `widgetbook/lib/components/` containing one or more `WidgetbookUseCase` entries. Each use case exposes the most important props as Widgetbook knobs (dropdowns, toggles, text inputs). This gives ~3-5 knobs per component matching SC-005.

**Standard knob pattern**:
- `size` → dropdown knob with sm/md/lg
- `color` → dropdown knob with accent/neutral/brand1-3/success/danger/warning/info
- `disabled` → boolean knob
- Component-specific: `variant` (button), `severity` (alert), `elevated` (card), etc.

**Alternatives considered**:
- One giant file with all components → unmaintainable
- Annotation-based generation → adds build_runner complexity for little benefit
