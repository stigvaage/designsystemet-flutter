# Contract: Deploy Workflow

**Feature**: 005-fix-build-deploy
**Date**: 2026-03-17

## Workflow Interface

**File**: `.github/workflows/deploy-pages.yml`
**Name**: `Deploy to GitHub Pages`

### Triggers

| Trigger | Condition | Behavior |
|---------|-----------|----------|
| `push` | Branch: `main` | Automatic build + deploy |
| `workflow_dispatch` | Manual (Actions UI) | Same build + deploy on demand |

### Permissions

| Permission | Level | Purpose |
|------------|-------|---------|
| `contents` | `read` | Checkout repository code |
| `pages` | `write` | Upload and deploy Pages artifact |
| `id-token` | `write` | OIDC token for Pages deployment |

### Concurrency

| Setting | Value | Purpose |
|---------|-------|---------|
| `group` | `pages` | Single deployment group |
| `cancel-in-progress` | `true` | Cancel stale runs on new push |

### Jobs

#### `build` (ubuntu-latest)

| Step | Tool/Action | Configuration |
|------|-------------|---------------|
| Checkout | `actions/checkout@v4` | Default |
| Flutter SDK | `subosito/flutter-action@v2` | `channel: stable` |
| Node.js | `actions/setup-node@v4` | `node-version: 20`, cache npm |
| Flutter deps | `flutter pub get` | Root + `widgetbook/` |
| Build Widgetbook | `flutter build web` | `--release --no-tree-shake-icons --base-href /komponentbibliotek-flutter-poc/widgetbook/` |
| Verify Widgetbook | `test -f` | Assert `widgetbook/build/web/index.html` exists |
| VitePress deps | `npm ci` | In `site/` |
| Build docs | `npm run build` | In `site/` |
| Combine output | `cp -r` | Copy `widgetbook/build/web` → `site/.vitepress/dist/widgetbook` |
| Upload | `actions/upload-pages-artifact@v3` | Path: `site/.vitepress/dist` |

#### `deploy` (ubuntu-latest, needs: build)

| Step | Tool/Action | Configuration |
|------|-------------|---------------|
| Deploy | `actions/deploy-pages@v4` | Environment: `github-pages` |

### Output URLs

| Content | URL |
|---------|-----|
| Documentation site | `https://stigvaage.github.io/komponentbibliotek-flutter-poc/` |
| Widgetbook | `https://stigvaage.github.io/komponentbibliotek-flutter-poc/widgetbook/` |

### Error Handling

- Flutter build failure → job fails, no artifact uploaded, no deployment
- VitePress build failure → job fails, no artifact uploaded, no deployment
- Widgetbook output missing → explicit `test -f` check fails the job with descriptive error
- Pages deployment failure → deploy job reports failure in Actions UI
