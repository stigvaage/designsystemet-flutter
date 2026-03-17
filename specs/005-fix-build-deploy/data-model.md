# Data Model: Fix Build & Deploy Pipeline

**Feature**: 005-fix-build-deploy
**Date**: 2026-03-17

## Overview

This feature has no application-level data model. It concerns CI/CD pipeline configuration (GitHub Actions workflow files) and static site build output. The entities below describe the deployment artifacts and their relationships.

## Entities

### Workflow Configuration

- **Name**: The GitHub Actions workflow YAML file
- **Location**: `.github/workflows/deploy-pages.yml` (new file replacing corrupted `deploy-docs.yml`)
- **Attributes**:
  - Trigger events (push to main, workflow_dispatch)
  - Permissions (contents:read, pages:write, id-token:write)
  - Concurrency group (pages, cancel-in-progress)
  - Build steps (Flutter, Node.js, VitePress)
  - Deploy step (GitHub Pages)

### VitePress Build Output

- **Name**: Documentation site static files
- **Source**: `site/` directory (VitePress project)
- **Output**: `site/.vitepress/dist/` directory
- **Attributes**:
  - HTML pages for all doc sections (intro, kom-i-gang, komponenter, monstre, god-praksis)
  - Redirect HTML files for legacy URLs
  - Static assets (CSS, JS, images, search index)
  - Base path: `/komponentbibliotek-flutter-poc/`

### Widgetbook Build Output

- **Name**: Flutter web application files
- **Source**: `widgetbook/` directory (Flutter project)
- **Output**: `widgetbook/build/web/` directory
- **Attributes**:
  - `index.html` with `$FLUTTER_BASE_HREF` resolved to `/komponentbibliotek-flutter-poc/widgetbook/`
  - `flutter_bootstrap.js`, `main.dart.js` (compiled Dart)
  - Flutter web engine assets
  - Base path: `/komponentbibliotek-flutter-poc/widgetbook/`

### Combined Deployment Artifact

- **Name**: GitHub Pages artifact
- **Composition**: VitePress output + Widgetbook output nested under `/widgetbook/`
- **Structure**:
  ```
  site/.vitepress/dist/           ← uploaded as Pages artifact
  ├── index.html                  ← VitePress root
  ├── intro/
  ├── kom-i-gang/
  ├── komponenter/
  ├── monstre/
  ├── god-praksis/
  ├── assets/                     ← VitePress assets
  └── widgetbook/                 ← copied from widgetbook/build/web/
      ├── index.html              ← Flutter Widgetbook app
      ├── flutter_bootstrap.js
      ├── main.dart.js
      └── ...
  ```

## Relationships

- **Workflow → VitePress Build**: Workflow triggers VitePress build via `npm run build` in `site/` directory
- **Workflow → Widgetbook Build**: Workflow triggers Flutter web build via `flutter build web` in `widgetbook/` directory
- **VitePress Config → Widgetbook**: VitePress navigation includes external link to `/widgetbook/`
- **Widgetbook → Library**: Widgetbook depends on root library via path reference in `pubspec.yaml`
- **Combined Artifact → GitHub Pages**: The merged output is uploaded as a single artifact and deployed via `actions/deploy-pages@v4`
