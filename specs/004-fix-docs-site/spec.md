# Feature Specification: Fix Documentation Site and Widgetbook Issues

**Feature Branch**: `004-fix-docs-site`
**Created**: 2026-03-16
**Status**: Draft
**Input**: The GitHub Pages documentation site for the component library has errors, missing pages, and broken Widgetbook component previews. A comprehensive analysis and fix is needed.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Working Widgetbook Component Previews (Priority: P1)

A developer browsing the documentation site wants to interactively preview a component (e.g., DsButton) directly from its documentation page. Currently, the WidgetbookEmbed links on each component page construct URLs using a `?path=` query parameter format that does not match Widgetbook 3.x's internal routing scheme. When a developer clicks "Prøv DsButton i Widgetbook," they are taken to the Widgetbook app but not navigated to the correct component — they land on the Widgetbook home page instead.

**Why this priority**: Interactive component previews are the primary value proposition of the documentation site. Without working deep-links, developers must manually browse the Widgetbook folder structure to find each component, which defeats the purpose of integrating Widgetbook into the docs.

**Independent Test**: Can be fully tested by clicking any "Prøv [Component] i Widgetbook" link on a component documentation page and verifying that Widgetbook opens with the correct component displayed.

**Acceptance Scenarios**:

1. **Given** a developer is on any component documentation page, **When** they click the Widgetbook link card, **Then** the Widgetbook app opens and displays the corresponding component's use case.
2. **Given** a developer clicks the Widgetbook link for "DsButton" (in the "Kjernekomponenter" folder), **When** Widgetbook loads, **Then** the DsButton component is selected and its "Standard" use case is rendered.
3. **Given** a developer clicks the Widgetbook link for a component in any folder (e.g., "Navigasjon og layout/DsTabs"), **When** Widgetbook loads, **Then** the correct folder is expanded and the correct component is selected.

---

### User Story 2 - All Documentation Pages Load Without Errors (Priority: P2)

A developer visiting the documentation site navigates through all sections — Introduction, Getting Started, Components, Patterns, and Best Practices. All pages should load correctly, display their content, and have working internal navigation links. No broken links, missing content, or rendering errors should be present.

**Why this priority**: A site with broken pages or missing content undermines trust in the library. Developers may assume the library itself is incomplete or unmaintained if its documentation is broken.

**Independent Test**: Can be fully tested by visiting every page in the sidebar navigation and verifying content loads correctly, all internal links resolve, and no visible errors appear.

**Acceptance Scenarios**:

1. **Given** the documentation site is deployed, **When** a developer navigates to any page listed in the sidebar, **Then** the page loads with its full content and no errors.
2. **Given** a developer follows an internal link on any documentation page, **When** the target page loads, **Then** it displays the expected content (not a 404 or blank page).
3. **Given** old URLs exist from the previous navigation structure (e.g., `/komponenter/kjernekomponenter/ds-alert`), **When** a developer visits an old URL, **Then** they are redirected to the correct new URL (e.g., `/komponenter/ds-alert`).
4. **Given** the nav bar "Widgetbook" link, **When** a developer clicks it, **Then** the Widgetbook app loads successfully at `/widgetbook/`.

---

### User Story 3 - Improved Component Documentation Quality (Priority: P3)

A developer evaluating the component library reads the documentation for a specific component to understand its usage, properties, accessibility features, and see code examples. The documentation should be comprehensive, consistent across all 40 components, and provide enough information to use the component without reading source code.

**Why this priority**: High-quality documentation reduces onboarding friction and support burden. Consistent structure across all component pages helps developers build a mental model they can apply across the entire library.

**Independent Test**: Can be tested by reviewing any 5 randomly selected component documentation pages and verifying each has complete and consistent content across all three tabs (Oversikt, Kode, Tilgjengelighet).

**Acceptance Scenarios**:

1. **Given** a developer views any component's documentation page, **When** they switch between tabs (Oversikt, Kode, Tilgjengelighet), **Then** each tab contains substantive content — no empty tabs or placeholder text.
2. **Given** a developer reads the "Kode" tab, **When** they look at the properties table, **Then** all public properties of the component are documented with type, default value, and description.
3. **Given** a developer reads the "Oversikt" tab, **When** they review the code examples, **Then** at least one complete, copy-pasteable code example is provided.
4. **Given** a developer reads the "Tilgjengelighet" tab, **When** they review the content, **Then** semantics, keyboard interaction, focus indicator, and contrast information are documented.

---

### User Story 4 - Reliable Automated Deployment (Priority: P4)

When code is pushed to the main branch, the documentation site and Widgetbook catalog should automatically build and deploy to GitHub Pages without manual intervention. The deployment pipeline should handle both the VitePress docs and the Widgetbook Flutter web app, combining them into a single site.

**Why this priority**: Automated deployment ensures the live site always reflects the latest changes. Past deployment failures (2 out of 10 recent runs failed) indicate fragility in the pipeline that should be addressed.

**Independent Test**: Can be tested by pushing a minor documentation change to the main branch and verifying the deployed site reflects the change within 5 minutes.

**Acceptance Scenarios**:

1. **Given** a commit is pushed to the main branch, **When** the GitHub Actions workflow runs, **Then** it completes successfully and the site is updated.
2. **Given** the deployment workflow runs, **When** both VitePress and Widgetbook builds complete, **Then** the Widgetbook app is accessible at `/widgetbook/` as a subdirectory of the VitePress site.
3. **Given** a developer triggers a manual workflow dispatch, **When** the workflow runs, **Then** it produces the same result as an automatic deployment.

---

### Edge Cases

- What happens when a developer navigates directly to a Widgetbook deep-link URL that references a component name with spaces (e.g., "Navigasjon og layout")?
- How does the site behave when the Widgetbook Flutter web app fails to load (e.g., slow connection, JavaScript disabled)?
- What happens when a developer bookmarks a component page URL and returns later after the site structure has changed?
- How does the WidgetbookEmbed link card behave if the Widgetbook path format changes in a future Widgetbook version update?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The WidgetbookEmbed component MUST construct deep-link URLs that match Widgetbook 3.x's actual routing scheme, navigating directly to the specified component.
- **FR-002**: All 40 component documentation pages MUST load without errors and display content in all three tabs (Oversikt, Kode, Tilgjengelighet).
- **FR-003**: The WidgetbookEmbed component MUST handle component paths containing spaces (e.g., "Navigasjon og layout") correctly in the generated URL.
- **FR-004**: Every component documentation page MUST include a working link to its corresponding Widgetbook use case.
- **FR-005**: All internal navigation links in the sidebar and within documentation pages MUST resolve to valid pages (no 404s).
- **FR-006**: URL redirects from the old navigation structure MUST continue to work, directing users to the correct new URLs.
- **FR-007**: The Widgetbook app at `/widgetbook/` MUST load and render all 40 components with their interactive knobs (theme, color scope, size scope).
- **FR-008**: Each component documentation page MUST have a consistent structure: usage guidelines with examples (Oversikt), complete property reference table (Kode), and accessibility information (Tilgjengelighet).
- **FR-009**: The deployment pipeline MUST build and deploy both the VitePress documentation and the Widgetbook app in a single workflow run.
- **FR-010**: The unused `:height` prop on WidgetbookEmbed (remnant from the iframe implementation) MUST be cleaned up across all component documentation files.

### Key Entities

- **Component Documentation Page**: A markdown file in `site/nb/komponenter/` representing one library component, containing usage guidelines, code examples, property tables, and accessibility info. Linked to its Widgetbook use case.
- **WidgetbookEmbed**: A Vue component that generates a link card connecting a documentation page to its interactive Widgetbook preview. Takes a component path (folder/name) and generates the correct deep-link URL.
- **Widgetbook Use Case**: A Dart definition in `widgetbook/lib/components/` that provides an interactive preview of a library component with configurable knobs. Organized into folders matching the documentation categories.
- **Deployment Pipeline**: A GitHub Actions workflow that builds both VitePress and Widgetbook, combines their output, and deploys to GitHub Pages.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Widgetbook link cards on component documentation pages navigate to the correct component in the Widgetbook app (currently 0% work correctly).
- **SC-002**: All 40 component documentation pages load without errors and display content in all three tabs.
- **SC-003**: Zero broken internal links across the entire documentation site.
- **SC-004**: The deployment pipeline achieves 100% success rate for standard documentation changes (up from 80% in recent history).
- **SC-005**: All component documentation pages follow a consistent structure with no empty or placeholder sections.
- **SC-006**: Developers can navigate from any component page to its interactive Widgetbook preview in a single click.

## Assumptions

- The Widgetbook 3.x deep-link URL format uses a `?path=` query parameter with a specific encoding scheme that differs from simple folder/component name concatenation. The exact format needs to be verified against the Widgetbook 3.10.0 routing implementation.
- The two past deployment failures (for MCP server and Lucide icons commits) were transient build issues rather than fundamental pipeline problems, but the pipeline should be made more resilient regardless.
- The component library itself (38+ components in `lib/`) is stable and functional — this feature focuses exclusively on the documentation and preview infrastructure.
- The WidgetbookEmbed was intentionally changed from an iframe embed to a link card (per commit history), and this approach should be maintained rather than reverting to iframes — the fix is about making the link URLs work correctly.
