# Research: Fix Build & Deploy Pipeline

**Feature**: 005-fix-build-deploy
**Date**: 2026-03-17

## R1: GitHub Actions Workflow Registry Corruption

**Decision**: Delete the corrupted `deploy-docs.yml` and create a new file named `deploy-pages.yml`.

**Rationale**: The repo rename from `komponentbibliotek-flutter` to `komponentbibliotek-flutter-poc` corrupted GitHub's internal workflow registry entry for `deploy-docs.yml`. Symptoms: workflow fails instantly (0s, 0 jobs) with "workflow file issue", `workflow_dispatch` not recognized, workflow name shows as filepath instead of the `name:` field. A completely new workflow file (`test.yml`) with identical structure works perfectly, proving the issue is registry-level, not YAML validity.

**Alternatives considered**:
- **Renaming `deploy-docs.yml` in-place** — Attempted in commit `070f68f` (rename to force re-registration). Failed; GitHub's registry is keyed beyond just the filename.
- **Editing content of existing file** — Multiple attempts failed; the corruption persists regardless of content changes.
- **Contacting GitHub Support** — Slow turnaround, and the file-replacement approach is proven to work.

## R2: Diagnostic Test Workflow Cleanup

**Decision**: Remove `.github/workflows/test.yml` after the new deploy workflow is verified working.

**Rationale**: `test.yml` was created solely to diagnose whether the Pages deployment infrastructure worked. It deploys the entire repo root as a Pages artifact (not useful for production). It served its diagnostic purpose and should not remain.

**Alternatives considered**:
- **Keep as a fallback** — Rejected; it deploys wrong content and would confuse future maintainers.

## R3: Base Path Configuration Status

**Decision**: No changes needed — all base paths are correct.

**Rationale**: Verified through code inspection:
- VitePress `config.ts` line 5: `base = '/komponentbibliotek-flutter-poc/'` — correct
- Workflow `deploy-docs.yml` line 41: `--base-href /komponentbibliotek-flutter-poc/widgetbook/` — correct
- Widgetbook `web/index.html` line 4: `<base href="$FLUTTER_BASE_HREF">` — uses Flutter's build-time variable injection, correct

These were fixed in commit `e1096ad` (fix: update base paths after repo rename).

## R4: GitHub Pages Deployment Method

**Decision**: Use GitHub Actions deployment (not branch-based). Use `actions/upload-pages-artifact@v3` + `actions/deploy-pages@v4`.

**Rationale**: This is the approach already in use and verified working via `test.yml`. It's the modern GitHub Pages deployment method — no need for a separate `gh-pages` branch, no force-pushing built artifacts, and it integrates with the Actions UI for deployment status and rollback.

**Alternatives considered**:
- **Branch-based deployment (gh-pages)** — Older approach, requires force-pushing build output to a branch. More moving parts, harder to debug.
- **Third-party actions (peaceiris/actions-gh-pages)** — Unnecessary; GitHub's native actions work correctly.

## R5: Flutter SDK Version for CI

**Decision**: Use `subosito/flutter-action@v2` with `channel: stable` (no pinned version).

**Rationale**: The existing workflow uses `@v2.21.0` which pins the action version, not the Flutter SDK version. The `channel: stable` setting gets the latest stable Flutter, which is compatible with the project's `sdk: ^3.3.0` constraint. Pinning the action version is fine for reproducibility.

**Alternatives considered**:
- **Pin a specific Flutter version** — Unnecessary; stable channel tracks well and the project's SDK constraint is broad enough.

## R6: Concurrency Handling

**Decision**: Use `concurrency: { group: pages, cancel-in-progress: true }` — already configured correctly.

**Rationale**: This ensures that if two deployments are triggered in quick succession (e.g., rapid pushes to main), the earlier one is cancelled. This is already in the existing workflow and matches FR-006.

## R7: Test Commit Cleanup

**Decision**: The test/diagnostic commits on the 005-fix-build-deploy branch (commits `78c3ccd`, `4c3c1b0`, `070f68f`) will be superseded by the final fix. The PR can be squash-merged to keep main history clean.

**Rationale**: These commits are diagnostic artifacts, not meaningful changes. Squash merge is the standard approach for this repo's workflow.
