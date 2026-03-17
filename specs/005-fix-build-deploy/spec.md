# Feature Specification: Fix Build & Deploy Pipeline

**Feature Branch**: `005-fix-build-deploy`
**Created**: 2026-03-17
**Status**: Complete
**Input**: User description: "Analyze and fix the build and deploy for the component library, including Widgetbook, on GitHub Pages"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automated Deployment on Push to Main (Priority: P1)

As a library maintainer, when I merge changes to the main branch, the documentation site and interactive component catalog (Widgetbook) are automatically built and deployed to GitHub Pages — without any manual intervention.

**Why this priority**: This is the core value of the feature. Without automated deployment, every change requires manual build and upload steps, blocking the team from iterating quickly and keeping documentation in sync with the library.

**Independent Test**: Can be fully tested by pushing a commit to main and verifying both the documentation site and Widgetbook are live and accessible at their expected URLs within a few minutes.

**Acceptance Scenarios**:

1. **Given** a merged pull request on main, **When** GitHub detects the push, **Then** the deployment pipeline triggers automatically and both the docs site and Widgetbook are published to GitHub Pages.
2. **Given** the pipeline is running, **When** both the docs site and Widgetbook build successfully, **Then** the combined output is deployed as a single Pages artifact.
3. **Given** the pipeline is running, **When** either the docs or Widgetbook build fails, **Then** the deployment is halted and the failure is clearly reported in the workflow run log.

---

### User Story 2 - Manual Deployment Trigger (Priority: P2)

As a library maintainer, I can manually trigger the deployment pipeline from the GitHub Actions UI at any time, without needing to push a commit.

**Why this priority**: Enables re-deployment after transient failures (e.g., GitHub infrastructure issues) or when content needs to be refreshed without code changes. This is a safety net for the automated flow.

**Independent Test**: Can be fully tested by clicking "Run workflow" in the GitHub Actions UI and verifying a successful deployment.

**Acceptance Scenarios**:

1. **Given** a maintainer is on the Actions tab in GitHub, **When** they select the deploy workflow and click "Run workflow", **Then** the pipeline executes the same build and deploy steps as an automatic push-triggered run.
2. **Given** a manual run completes successfully, **Then** the Pages site reflects the current state of the main branch.

---

### User Story 3 - Accessible Documentation and Widgetbook (Priority: P1)

As a developer evaluating or using the component library, I can visit the published documentation site and navigate to the interactive Widgetbook to browse components, try different themes, colors, and sizes — all from a web browser.

**Why this priority**: The entire purpose of deploying is to make the library discoverable and usable. If the published site is broken (wrong paths, missing assets, blank pages), the deployment is worthless.

**Independent Test**: Can be fully tested by visiting the Pages URL in a browser and verifying that the docs site loads, navigation works, and the Widgetbook link opens the interactive component catalog with working theme/color/size controls.

**Acceptance Scenarios**:

1. **Given** a successful deployment, **When** a user visits the root Pages URL, **Then** the documentation site loads with all pages, navigation, and search working correctly.
2. **Given** a successful deployment, **When** a user clicks the Widgetbook link in the docs navigation (or visits the Widgetbook path directly), **Then** the Widgetbook app loads and displays the component catalog with functional addons (theme, color scope, size scope).
3. **Given** a successful deployment, **When** a user navigates to any deep-link within the docs site or Widgetbook, **Then** the page resolves correctly (no 404 errors from incorrect base paths).

---

### Edge Cases

- What happens when the Flutter build fails due to dependency resolution errors? The pipeline should fail fast and report the error clearly.
- What happens when the VitePress build fails? The pipeline should not deploy a partial artifact (Widgetbook without docs or vice versa).
- What happens when GitHub Pages is temporarily unavailable? The pipeline should report the deployment failure; a maintainer can re-trigger manually.
- What happens if a concurrent deployment is triggered (e.g., two rapid pushes to main)? Only the latest deployment should proceed; earlier runs should be cancelled.
- What happens when the corrupted workflow file is still present in GitHub's registry? The old file must be removed and replaced with a differently-named file to bypass the registry corruption.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The deployment pipeline MUST automatically trigger on every push to the main branch.
- **FR-002**: The deployment pipeline MUST support manual triggering via the GitHub Actions UI (workflow_dispatch).
- **FR-003**: The pipeline MUST build the Flutter Widgetbook as a web application with the correct base path so all assets load correctly on GitHub Pages.
- **FR-004**: The pipeline MUST build the VitePress documentation site with the correct base path.
- **FR-005**: The pipeline MUST combine the Widgetbook build output into the documentation site output so both are served from a single Pages deployment.
- **FR-006**: The pipeline MUST cancel in-progress deployments when a new deployment is triggered, to avoid conflicts.
- **FR-007**: The pipeline MUST fail and report errors clearly if any build step fails, without deploying a partial or broken artifact.
- **FR-008**: The corrupted workflow file MUST be replaced with a new file (different filename) to bypass the GitHub Actions registry corruption caused by the repository rename.
- **FR-009**: Any temporary diagnostic workflow files created during troubleshooting MUST be removed as part of the fix.
- **FR-010**: All published pages (docs site root, sub-pages, Widgetbook, and deep-links) MUST resolve correctly without 404 errors.

### Key Entities

- **Documentation Site**: The VitePress-generated static site containing library guides, component docs, and navigation. Served at the root of the GitHub Pages URL.
- **Widgetbook**: The Flutter web application providing an interactive component catalog with theme, color, and size controls. Served under a `/widgetbook/` sub-path on GitHub Pages.
- **Deployment Pipeline**: The GitHub Actions workflow that builds both artifacts, combines them, and publishes to GitHub Pages.

## Assumptions

- The GitHub Pages deployment source is configured to use GitHub Actions (not a branch-based deployment).
- The repository has GitHub Pages enabled in its settings.
- The base path for the Pages site is determined by the repository name (`/komponentbibliotek-flutter-poc/`).
- The existing VitePress configuration and Widgetbook code are correct and build successfully when given the right commands — the issue is isolated to the workflow file corruption and pipeline configuration.
- The Flutter SDK version used in CI (stable channel) is compatible with the project's `sdk: ^3.3.0` constraint.
- Renaming the workflow file (e.g., from `deploy-docs.yml` to `deploy-pages.yml`) is sufficient to bypass GitHub's corrupted internal workflow registry.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A push to main triggers the deployment pipeline and the documentation site + Widgetbook are live on GitHub Pages within 5 minutes.
- **SC-002**: The "Run workflow" button is available and functional in the GitHub Actions UI for the deploy workflow.
- **SC-003**: 100% of documentation pages and Widgetbook routes load without 404 or asset-loading errors after deployment.
- **SC-004**: The workflow run completes successfully (green check) with no "workflow file issue" errors in GitHub Actions.
- **SC-005**: No diagnostic or temporary workflow files remain in the repository after the fix is complete.
