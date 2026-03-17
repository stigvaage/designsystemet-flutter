# Quickstart: Fix Build & Deploy Pipeline

**Feature**: 005-fix-build-deploy
**Date**: 2026-03-17

## Problem

The GitHub Actions deploy workflow (`deploy-docs.yml`) is corrupted in GitHub's internal registry after the repository was renamed. It fails instantly with 0 jobs and "workflow file issue". A diagnostic workflow (`test.yml`) proves the Pages infrastructure works fine.

## Solution

1. Delete the corrupted workflow file (`.github/workflows/deploy-docs.yml`)
2. Delete the diagnostic workflow file (`.github/workflows/test.yml`)
3. Create a new workflow file (`.github/workflows/deploy-pages.yml`) with the full build+deploy pipeline
4. Push to main and verify the workflow triggers and completes successfully

## Key Files

| File | Action | Purpose |
|------|--------|---------|
| `.github/workflows/deploy-docs.yml` | DELETE | Corrupted, cannot be registered by GitHub |
| `.github/workflows/test.yml` | DELETE | Diagnostic only, deploys wrong content |
| `.github/workflows/deploy-pages.yml` | CREATE | New deploy workflow (same logic, fresh registry entry) |

## Verification Steps

1. Push the changes to main (via PR merge)
2. Check GitHub Actions tab — new workflow should appear as "Deploy to GitHub Pages"
3. Verify the workflow run completes with a green check
4. Visit `https://stigvaage.github.io/komponentbibliotek-flutter-poc/` — docs site should load
5. Visit `https://stigvaage.github.io/komponentbibliotek-flutter-poc/widgetbook/` — Widgetbook should load
6. Click "Run workflow" button in Actions UI — manual trigger should work

## Build Pipeline Summary

```
checkout → flutter pub get → flutter build web (widgetbook) → npm ci (site) → npm run build (VitePress) → cp widgetbook into dist → upload artifact → deploy pages
```
