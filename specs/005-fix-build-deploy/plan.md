# Implementation Plan: Fix Build & Deploy Pipeline

**Branch**: `005-fix-build-deploy` | **Date**: 2026-03-17 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/005-fix-build-deploy/spec.md`

## Summary

The GitHub Actions deploy workflow is corrupted in GitHub's internal registry after the repository rename. The fix is to delete the corrupted workflow file (`deploy-docs.yml`), remove the diagnostic workflow (`test.yml`), and create a new workflow file (`deploy-pages.yml`) with the same build+deploy logic. Base paths and build configurations are already correct — the issue is isolated to the workflow registry corruption.

## Technical Context

**Language/Version**: YAML (GitHub Actions workflow), Dart 3.3+ (Flutter Widgetbook build), TypeScript (VitePress docs build)
**Primary Dependencies**: `actions/checkout@v4`, `subosito/flutter-action@v2`, `actions/setup-node@v4`, `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4`
**Storage**: N/A (static site deployment)
**Testing**: Manual verification — push to main, check Actions run, visit deployed URLs
**Target Platform**: GitHub Pages (static hosting)
**Project Type**: CI/CD pipeline configuration
**Performance Goals**: Deployment completes within 5 minutes of push to main
**Constraints**: Must use GitHub Actions native Pages deployment; must bypass corrupted registry entry
**Scale/Scope**: Single workflow file managing two build outputs (VitePress + Flutter Widgetbook)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applicable? | Status | Notes |
|-----------|-------------|--------|-------|
| I. Designsystemet Fidelity | No | N/A | CI/CD change, no component modifications |
| II. Token-Driven Architecture | No | N/A | No visual properties involved |
| III. Theme Portability | No | N/A | No theme changes |
| IV. CLI-First Tooling | Partially | PASS | Workflow uses `flutter build web` CLI command as required |
| V. Flutter-Idiomatic API | No | N/A | No API changes |
| VI. Test-First Development | No | N/A | No component code changes; verification is deployment success |
| VII. Accessibility Compliance | No | N/A | No UI changes |

**Gate result**: PASS — This feature is purely CI/CD infrastructure. Constitution principles primarily govern component development and do not impose constraints on workflow file changes.

**Post-Phase 1 re-check**: PASS — No design decisions impact constitution principles. The workflow file contents are functionally identical to the existing (corrupted) version.

## Project Structure

### Documentation (this feature)

```text
specs/005-fix-build-deploy/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0: research findings
├── data-model.md        # Phase 1: deployment artifact model
├── quickstart.md        # Phase 1: implementation quickstart
├── contracts/
│   └── deploy-workflow.md  # Phase 1: workflow contract
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
.github/workflows/
├── deploy-docs.yml      ← DELETE (corrupted)
├── test.yml             ← DELETE (diagnostic, no longer needed)
└── deploy-pages.yml     ← CREATE (new workflow, identical logic)
```

**Structure Decision**: This feature modifies only `.github/workflows/` — no changes to library source, Widgetbook code, VitePress config, or any other project files. The fix is a file-level operation: delete two files, create one.

## Implementation Approach

### Step 1: Create new workflow file

Create `.github/workflows/deploy-pages.yml` with the full build+deploy pipeline. The content is functionally identical to the existing `deploy-docs.yml` — the only difference is the filename (to get a fresh registry entry) and the workflow `name` field.

**Key decisions**:
- Workflow name: `Deploy to GitHub Pages` (slightly different from original `Deploy Documentation to GitHub Pages` to further differentiate the registry entry)
- Pin `subosito/flutter-action` to `@v2` (major version) rather than specific patch to get Flutter bug fixes automatically
- Keep `--no-tree-shake-icons` flag for Widgetbook build (Widgetbook uses Material icons in its chrome)
- Keep the explicit `test -f` verification step for Widgetbook output as a safety net

### Step 2: Delete corrupted and diagnostic files

Delete both `.github/workflows/deploy-docs.yml` (corrupted) and `.github/workflows/test.yml` (diagnostic). These should be removed in the same commit as the new file creation so the transition is atomic.

### Step 3: Verify deployment

After merging to main:
1. Check GitHub Actions tab for the new workflow
2. Confirm the run completes with green check
3. Visit both URLs to verify content loads correctly
4. Test manual trigger via "Run workflow" button

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| New workflow also corrupted | Very Low | High | Name is different; `test.yml` proved new files work |
| Flutter build fails in CI | Low | Medium | Same build command that worked before the corruption |
| VitePress build fails | Low | Medium | No VitePress config changes; `npm ci` ensures deterministic deps |
| Base path regression | Very Low | High | All base paths verified correct; no changes made |

## Complexity Tracking

No constitution violations to justify. This is a minimal-scope CI/CD fix with no architectural decisions.
