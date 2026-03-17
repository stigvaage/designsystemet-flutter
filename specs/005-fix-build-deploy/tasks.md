# Tasks: Fix Build & Deploy Pipeline

**Input**: Design documents from `/specs/005-fix-build-deploy/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No automated tests — verification is via GitHub Actions run status and live URL checks.

**Organization**: All three user stories are served by a single workflow file. Tasks are organized by implementation phase rather than individual stories, since each story is an aspect of the same deliverable.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: No setup needed — project structure and build configuration already exist and are correct.

*No tasks in this phase.*

---

## Phase 2: Foundational (Workflow Replacement)

**Purpose**: Replace the corrupted workflow with a fresh file and clean up diagnostic artifacts. This single phase delivers the core fix for all user stories.

**⚠️ CRITICAL**: These tasks must be completed atomically (single commit) so GitHub Actions registers the new workflow cleanly.

- [x] T001 [P] Create new deploy workflow at .github/workflows/deploy-pages.yml per contracts/deploy-workflow.md — include triggers (push to main, workflow_dispatch), permissions (contents:read, pages:write, id-token:write), concurrency (group: pages, cancel-in-progress: true), build job (checkout, Flutter SDK via subosito/flutter-action@v2 with channel: stable, Node.js 20 via actions/setup-node@v4 with npm cache, flutter pub get in root and widgetbook/, flutter build web --release --no-tree-shake-icons --base-href /komponentbibliotek-flutter-poc/widgetbook/ in widgetbook/, verify widgetbook/build/web/index.html exists, npm ci in site/, npm run build in site/, cp -r widgetbook/build/web to site/.vitepress/dist/widgetbook, upload-pages-artifact@v3 from site/.vitepress/dist), and deploy job (deploy-pages@v4 with github-pages environment)
- [x] T002 [P] Delete corrupted workflow file .github/workflows/deploy-docs.yml (FR-008: bypass registry corruption)
- [x] T003 [P] Delete diagnostic workflow file .github/workflows/test.yml (FR-009: remove temporary files)

**Checkpoint**: All three file operations (create + 2 deletes) should be committed together. The `.github/workflows/` directory should contain only `deploy-pages.yml`.

---

## Phase 3: User Story 1 — Automated Deployment on Push to Main (Priority: P1) 🎯 MVP

**Goal**: Pushing to main automatically triggers the full build+deploy pipeline for both docs and Widgetbook.

**Independent Test**: Push branch to main (via PR merge), observe that the "Deploy to GitHub Pages" workflow runs automatically and completes with a green check.

### Verification for User Story 1

- [ ] T004 [US1] Push changes to remote and create PR for branch 005-fix-build-deploy targeting main
- [ ] T005 [US1] After PR merge, verify GitHub Actions shows "Deploy to GitHub Pages" workflow triggered automatically by the push event
- [ ] T006 [US1] Verify workflow run completes with green check (no "workflow file issue" errors) — confirms FR-001, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008

**Checkpoint**: US1 is verified when the workflow runs automatically on push and completes successfully.

---

## Phase 4: User Story 2 — Manual Deployment Trigger (Priority: P2)

**Goal**: The "Run workflow" button appears in the GitHub Actions UI and triggers a successful deployment.

**Independent Test**: Click "Run workflow" in the Actions tab and verify a successful deployment.

### Verification for User Story 2

- [ ] T007 [US2] Navigate to Actions tab → "Deploy to GitHub Pages" workflow → verify "Run workflow" dropdown button is visible (confirms FR-002, workflow_dispatch trigger is registered)
- [ ] T008 [US2] Click "Run workflow" and verify the pipeline executes the same build+deploy steps as an automatic run and completes successfully

**Checkpoint**: US2 is verified when manual trigger works and deploys successfully.

---

## Phase 5: User Story 3 — Accessible Documentation and Widgetbook (Priority: P1)

**Goal**: Both the documentation site and Widgetbook load correctly at their published URLs with working navigation and interactive features.

**Independent Test**: Visit both URLs in a browser and verify all content, navigation, and Widgetbook addons work.

### Verification for User Story 3

- [ ] T009 [US3] Visit https://stigvaage.github.io/komponentbibliotek-flutter-poc/ — verify docs site loads with navigation, search, and all page sections (intro, kom-i-gang, komponenter, monstre, god-praksis)
- [ ] T010 [US3] Click "Widgetbook" link in docs navigation (or visit https://stigvaage.github.io/komponentbibliotek-flutter-poc/widgetbook/) — verify Widgetbook app loads and displays component catalog with theme, color scope, and size scope addons (confirms FR-010)
- [ ] T011 [US3] Test deep-links: navigate directly to a component page (e.g., /komponenter/ds-button.html) and a Widgetbook deep-link — verify both resolve without 404 errors

**Checkpoint**: US3 is verified when all pages and Widgetbook load correctly without errors.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup after all verification passes.

- [x] T012 Confirm no diagnostic or temporary workflow files remain in .github/workflows/ (only deploy-pages.yml should exist) — validates SC-005
- [x] T013 Update spec.md status from "Draft" to "Complete" in specs/005-fix-build-deploy/spec.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 2 (Foundational)**: No dependencies — can start immediately. All 3 tasks (T001-T003) are parallelizable (different files).
- **Phase 3 (US1)**: Depends on Phase 2 commit being pushed and merged to main.
- **Phase 4 (US2)**: Depends on Phase 3 (workflow must be registered on main first).
- **Phase 5 (US3)**: Depends on Phase 3 (deployment must succeed first).
- **Phase 6 (Polish)**: Depends on Phases 3-5 all passing verification.

### User Story Dependencies

- **US1 (P1)**: Requires Phase 2 merged to main. No dependencies on other stories.
- **US2 (P2)**: Requires US1 (workflow must be live on main to test manual trigger). Can run in parallel with US3 once US1 passes.
- **US3 (P1)**: Requires US1 (deployment must succeed to test URLs). Can run in parallel with US2 once US1 passes.

### Parallel Opportunities

- T001, T002, T003 (Phase 2) can all be done in parallel (different files, committed together)
- T007-T008 (US2) and T009-T011 (US3) can be verified in parallel after US1 passes
- T009, T010, T011 (within US3) can be checked in parallel (independent URL checks)

---

## Parallel Example: Phase 2 (Core Fix)

```bash
# All three file operations in parallel (committed atomically):
Task: "Create deploy-pages.yml at .github/workflows/deploy-pages.yml"
Task: "Delete deploy-docs.yml at .github/workflows/deploy-docs.yml"
Task: "Delete test.yml at .github/workflows/test.yml"
```

## Parallel Example: Post-Deployment Verification (US2 + US3)

```bash
# After US1 passes, verify US2 and US3 in parallel:
Task: "Verify manual trigger (US2) via Actions UI"
Task: "Verify docs site URL loads (US3)"
Task: "Verify Widgetbook URL loads (US3)"
Task: "Verify deep-links resolve (US3)"
```

---

## Implementation Strategy

### MVP First (Phase 2 + US1)

1. Complete Phase 2: Create `deploy-pages.yml`, delete `deploy-docs.yml` and `test.yml` — single commit
2. Push and create PR
3. Merge PR to main
4. **STOP and VALIDATE**: Verify workflow triggers automatically and completes (US1)
5. If US1 passes → proceed to US2 + US3 verification

### Incremental Delivery

1. Phase 2 → Commit the file changes (this is the actual fix)
2. US1 verified → Automatic deployment works (MVP!)
3. US2 verified → Manual trigger works
4. US3 verified → All URLs load correctly
5. Phase 6 → Final cleanup

---

## Notes

- This feature is unusual in that all user stories are delivered by a single file change (T001). The remaining tasks are verification, not implementation.
- The [P] marker on T001-T003 indicates they touch different files. In practice they should be committed together as one atomic change.
- No automated tests are defined — success criteria are verified via GitHub Actions run status and live URL checks.
- Commit after Phase 2 tasks are complete. Do not commit incrementally within Phase 2.
