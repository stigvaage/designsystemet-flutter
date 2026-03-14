# Feature Specification: Widgetbook Component Catalog & Documentation Site

**Feature Branch**: `002-widgetbook-docs-site`
**Created**: 2026-03-14
**Status**: Draft
**Input**: User description: "Setup Widgetbook interactive component catalog and documentation site for the Flutter component library"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse All Components Interactively (Priority: P1)

A developer or designer visits the published documentation site and sees a categorized catalog of all 40 Designsystemet components. They can select any component, see it rendered live, and interact with it — toggling props like size (sm/md/lg), color scale (accent/danger/success/etc.), variant, disabled state, and more. This lets them understand exactly how each component looks and behaves before using it in their own project.

**Why this priority**: The primary value of a component catalog is letting users explore and try components visually. Without this, the site is just static documentation.

**Independent Test**: Navigate to the published site, select DsButton from the catalog, toggle between primary/secondary/tertiary variants and sm/md/lg sizes, and verify each combination renders correctly with live preview.

**Acceptance Scenarios**:

1. **Given** the documentation site is loaded in a browser, **When** a user navigates to the component catalog, **Then** they see all 40 components organized by category (Core, Navigation, Form/Utility, Typography)
2. **Given** a user selects DsButton, **When** they toggle the variant knob to "secondary", **Then** the live preview immediately updates to show the secondary button style
3. **Given** a user selects DsAlert, **When** they change the severity knob to "danger", **Then** the preview shows the danger color scheme with appropriate icon and border color
4. **Given** a user selects any component, **When** they toggle the size knob between sm/md/lg, **Then** the preview updates to reflect the correct size mode with proper spacing and font sizes

---

### User Story 2 - View Component in Different Themes and Modes (Priority: P2)

A developer previewing a component can switch between the light and dark Digdir theme to see how the component adapts. They can also view components with different color scopes applied, simulating how components look when wrapped in a DsColorScope in a real application.

**Why this priority**: Theme switching is essential for verifying that components work correctly in both light and dark modes, which is a core requirement of the library.

**Independent Test**: Select DsCard, switch from light to dark theme, and verify the card's background, border, and text colors update to the dark color scheme values.

**Acceptance Scenarios**:

1. **Given** a component preview is displayed, **When** the user switches the theme from light to dark, **Then** all colors update to reflect the dark Digdir theme
2. **Given** a component preview is displayed, **When** the user selects a different color scope (e.g., danger, success, neutral), **Then** the component renders with that color scale's tokens

---

### User Story 3 - Access Component Documentation and Code Examples (Priority: P3)

A developer exploring a component can see its description, list of available properties with types and defaults, and copy-paste code examples showing common usage patterns. This reduces the time from discovery to integration.

**Why this priority**: Interactive preview is great for visual exploration, but developers need API reference and code snippets to actually use the components in their projects.

**Independent Test**: Navigate to DsTextfield in the catalog, verify the property table lists all props (controller, size, error, disabled, readOnly, prefix, suffix, etc.) with types, and verify at least one code example is displayed.

**Acceptance Scenarios**:

1. **Given** a user selects a component, **When** they view the documentation panel, **Then** they see the component description, a property reference table with name/type/default/description columns, and at least one usage code example
2. **Given** a user views a code example, **When** they click a copy button, **Then** the code snippet is copied to their clipboard

---

### User Story 4 - Deploy Site Automatically on Push (Priority: P4)

When a maintainer pushes changes to the main branch, the documentation site is automatically rebuilt and deployed to a publicly accessible URL (GitHub Pages). No manual deployment steps are needed.

**Why this priority**: Automated deployment ensures the documentation site always reflects the latest library code without manual effort.

**Independent Test**: Push a commit that changes a component's default prop value, verify the deployed site reflects the change within 10 minutes.

**Acceptance Scenarios**:

1. **Given** a commit is pushed to the main branch, **When** the CI/CD pipeline runs, **Then** the documentation site is rebuilt and deployed to the public URL
2. **Given** the pipeline completes, **When** a user visits the site URL, **Then** they see the updated version reflecting the latest changes
3. **Given** a deployment fails, **When** the maintainer checks the CI logs, **Then** a clear error message indicates what went wrong

---

### Edge Cases

- What happens when the documentation site is accessed on a mobile device? It MUST be usable on mobile screens, though interactive knobs may be collapsed behind a panel
- What happens when a component requires user interaction (e.g., DsDialog needs to be opened)? The catalog MUST provide a trigger button or auto-open mechanism to demonstrate the component
- What happens when a component needs a parent context (e.g., DsCardBlock inside DsCard)? The use case MUST wrap sub-components in their required parent for the preview
- What happens when the site is accessed offline after initial load? It SHOULD work as a cached progressive web app since it's compiled as Flutter web

## Requirements *(mandatory)*

### Functional Requirements

**Component Catalog:**
- **FR-001**: The site MUST display all 40 library components organized by category: Core (14), Navigation & Layout (14), Form & Utility (8), Typography (4)
- **FR-002**: Each component MUST have a live interactive preview that renders the actual Flutter widget
- **FR-003**: Each component MUST expose configurable knobs for its key properties (variant, size, color, disabled, etc.)
- **FR-004**: The component catalog MUST support a search/filter function to quickly find components by name

**Theme & Visual Modes:**
- **FR-005**: The site MUST support switching between the built-in Digdir light and dark themes
- **FR-006**: The site MUST support applying different DsColorScope values to preview components in different color contexts
- **FR-007**: The site MUST support applying different DsSizeScope values (sm, md, lg) globally or per-component

**Documentation:**
- **FR-008**: Each component MUST display a description explaining its purpose and when to use it
- **FR-009**: Each component MUST display a property reference table listing all public constructor parameters with name, type, default value, and description
- **FR-010**: Each component MUST include at least one Dart code example showing typical usage
- **FR-011**: The site MUST include a "Getting Started" section explaining how to install and set up the library

**Deployment & Hosting:**
- **FR-012**: The site MUST be deployable as a static web application to GitHub Pages at zero cost
- **FR-013**: The site MUST be automatically rebuilt and deployed when changes are pushed to the main branch via CI/CD
- **FR-014**: The site MUST be accessible at a predictable, stable public URL

**Navigation & UX:**
- **FR-015**: The site MUST have a sidebar or navigation menu listing all components grouped by category
- **FR-016**: The site MUST support deep-linking so a user can share a URL pointing to a specific component
- **FR-017**: The site MUST display the library name, version, and a link to the GitHub repository

### Assumptions

- Widgetbook is the chosen tool for the interactive component catalog (industry standard for Flutter)
- GitHub Pages is the hosting platform (free, integrated with the repo)
- GitHub Actions is used for CI/CD (free for public repos)
- The site is built as a Flutter web application (same technology as the library)
- All 40 components from the existing library are available and working
- The Digdir light and dark themes are available via DsThemeDigdir.light() and DsThemeDigdir.dark()
- Norwegian language is used for the site UI and descriptions (matching the library documentation)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 40 library components are browsable in the catalog with live interactive previews
- **SC-002**: A developer can find any component and understand its API within 2 minutes of arriving at the site
- **SC-003**: The site loads and becomes interactive within 5 seconds on a standard broadband connection
- **SC-004**: The site is automatically deployed within 10 minutes of a push to the main branch
- **SC-005**: Every component has at least 3 configurable knobs (size, color, and one component-specific prop)
- **SC-006**: The site is accessible at a stable public URL and returns a 200 status code
- **SC-007**: Theme switching (light/dark) updates all component previews correctly with no visual artifacts
