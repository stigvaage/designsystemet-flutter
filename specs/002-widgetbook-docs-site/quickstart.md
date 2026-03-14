# Quickstart: Widgetbook Component Catalog

**Feature**: 002-widgetbook-docs-site
**Date**: 2026-03-14

## Run locally

```bash
cd widgetbook
flutter pub get
flutter run -d chrome
```

## Build for deployment

```bash
cd widgetbook
flutter build web --base-href /komponentbibliotek-flutter/
```

Output is in `widgetbook/build/web/`.

## View deployed site

Visit: `https://stigvaage.github.io/komponentbibliotek-flutter/`

## Add a new component use case

1. Create `widgetbook/lib/components/<component_name>.dart`
2. Define a `WidgetbookComponent` with use cases and knobs
3. Register it in `widgetbook/lib/widgetbook.dart`
4. Run locally to verify
5. Commit and push — GitHub Actions deploys automatically

## Verification

After setup, this confirms the catalog works:

1. Run `flutter run -d chrome` in `widgetbook/`
2. Verify sidebar shows all 40 components grouped by category
3. Select DsButton → toggle variant knob → preview updates
4. Switch theme (light/dark) → all colors update
5. Change color scope to "danger" → component uses danger scale
