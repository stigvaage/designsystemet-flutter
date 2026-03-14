# Feature Specification: Komponentbibliotek MCP Server

**Feature Branch**: `003-mcp-server`
**Created**: 2026-03-14
**Status**: Clarified
**Input**: User description: "Create a Komponentbibliotek-Flutter MCP server based on this repo. Make it run both via npm and docker. I need it to migrate my flutter app to this component library."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Look Up Component API (Priority: P1)

A developer using an AI coding assistant (e.g. Claude Code) asks "how do I replace my Material AppBar with Designsystemet components?" The assistant queries the MCP server, which returns the relevant component APIs, properties, usage examples, and import statements. The developer receives accurate, up-to-date guidance based on the actual library source code.

**Why this priority**: This is the core value proposition — making component knowledge accessible to AI assistants so they can guide migration accurately. Without this, the server has no purpose.

**Independent Test**: Can be fully tested by querying a component name and verifying the response contains correct properties, examples, and import paths from the actual source code.

**Acceptance Scenarios**:

1. **Given** the MCP server is running, **When** the assistant calls the "lookup component" tool with "DsButton", **Then** it returns the component's properties (variant, size, color, disabled, loading, icon, iconPosition, onPressed, child), usage examples, and import statement.
2. **Given** the MCP server is running, **When** the assistant calls the "lookup component" tool with a name that doesn't exist, **Then** it returns a clear "not found" message with suggestions of similar component names.
3. **Given** the MCP server is running, **When** the assistant calls the "list components" tool, **Then** it returns all available components grouped by category (form, navigation, layout, content, interactive, typography).

---

### User Story 2 - Get Migration Mapping (Priority: P1)

A developer wants to migrate their existing Flutter app from Material widgets to this component library. The AI assistant queries the MCP server with a Material widget name (e.g. "ElevatedButton", "TextField", "AlertDialog") and receives the equivalent Designsystemet component, a property mapping, and a before/after code example.

**Why this priority**: Migration guidance is the stated primary use case. Developers need to know which Material widget maps to which Ds component and how properties translate.

**Independent Test**: Can be tested by querying with a Material widget name and verifying the response contains the correct Ds equivalent, property mappings, and transformation examples.

**Acceptance Scenarios**:

1. **Given** the MCP server is running, **When** the assistant calls the "get migration mapping" tool with "ElevatedButton", **Then** it returns `DsButton` as the equivalent, maps `onPressed` → `onPressed`, `child` → `child`, `style` → `variant`/`color`/`size`, and includes before/after code snippets.
2. **Given** the MCP server is running, **When** the assistant calls the "get migration mapping" tool with "TextField", **Then** it returns `DsTextfield` as the equivalent with property mappings for `controller`, `decoration.errorText` → `error`, `decoration.prefixIcon` → `prefix`, etc.
3. **Given** the MCP server is running, **When** the assistant calls the "get migration mapping" tool with a Material widget that has no equivalent, **Then** it returns a clear message explaining no direct mapping exists and suggests the closest alternatives or a custom approach.

---

### User Story 3 - Query Theme and Token Reference (Priority: P2)

A developer needs to understand how to set up the theme, use color tokens, or apply sizing. The AI assistant queries the MCP server for theme documentation — how to wrap the app with `DsTheme`, the available color scales, size tokens, typography styles, border radii, and shadow presets.

**Why this priority**: Theme setup is required before any component works. Without understanding the token system, migration cannot proceed.

**Independent Test**: Can be tested by querying for theme setup instructions and verifying the response includes DsTheme wrapping, DsThemeDigdir.light/dark usage, and token reference.

**Acceptance Scenarios**:

1. **Given** the MCP server is running, **When** the assistant calls the "get theme setup" tool, **Then** it returns instructions for wrapping the app with `DsTheme`, using `DsThemeDigdir.light()` / `DsThemeDigdir.dark()`, and the required import.
2. **Given** the MCP server is running, **When** the assistant calls the "list tokens" tool with category "colors", **Then** it returns all 9 named color types (accent, neutral, brand1-3, success, danger, warning, info) plus the custom color option, along with the 16 scale stops per color.
3. **Given** the MCP server is running, **When** the assistant calls the "list tokens" tool with category "typography", **Then** it returns all heading levels (xxl–xxs), body sizes (xl–xs) with variants (standard, short, long), and the font family (Inter).

---

### User Story 4 - Search Documentation (Priority: P2)

A developer asks a natural-language question like "how do I make an accessible form with validation?" The AI assistant queries the MCP server's search tool, which finds relevant documentation across component docs, getting-started guides, and best-practice pages, returning the most relevant excerpts.

**Why this priority**: Free-text search helps developers discover features they didn't know existed and find answers to questions that don't map to a single component.

**Independent Test**: Can be tested by searching for a topic and verifying the response includes relevant document excerpts with source references.

**Acceptance Scenarios**:

1. **Given** the MCP server is running, **When** the assistant calls the "search docs" tool with "form validation", **Then** it returns relevant excerpts from DsField, DsFieldset, DsErrorSummary, and DsTextfield documentation.
2. **Given** the MCP server is running, **When** the assistant calls the "search docs" tool with "keyboard navigation", **Then** it returns accessibility documentation covering focus indicators, tab order, and keyboard interaction tables.
3. **Given** the MCP server is running, **When** the assistant calls the "search docs" tool with a query that matches nothing, **Then** it returns an empty result set with a helpful message.

---

### User Story 5 - Run via npm or Docker (Priority: P3)

A developer installs and runs the MCP server either by running it directly via npm (for quick local use) or by pulling/building a Docker image (for team-wide consistent environments). Both methods produce an identical, working MCP server.

**Why this priority**: Distribution is essential but secondary to the server's actual capabilities. Both methods are needed to serve different developer workflows.

**Independent Test**: Can be tested by running the server via each method and verifying it responds to a health check or basic tool call.

**Acceptance Scenarios**:

1. **Given** a developer has Node.js installed, **When** they run the npm start command from the `mcp-server/` directory, **Then** the MCP server starts and responds to tool calls over stdio transport.
2. **Given** a developer has Docker installed, **When** they build and run the Docker image, **Then** the MCP server starts and responds to tool calls over stdio transport.
3. **Given** a developer wants to add the server to their AI assistant configuration, **When** they follow the documented configuration snippet, **Then** the assistant can successfully connect and call tools.

---

### Edge Cases

- What happens when the server is queried for a component that was recently added but documentation hasn't been updated yet? The server should still return the component's properties parsed from source code.
- How does the server handle queries in both English and Norwegian? (Documentation is in Norwegian, but developers may query in English.) The server should match on both component names and Norwegian documentation content.
- What happens when the library source code is malformed or incomplete? The server should gracefully degrade and return partial results with a warning.
- How does the server handle concurrent tool calls? Each call should be stateless and independent.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The server MUST implement the Model Context Protocol (MCP) specification and communicate over stdio transport.
- **FR-002**: The server MUST provide a tool to look up any component by name, returning its full property list, types, defaults, description, usage examples, and import statement.
- **FR-003**: The server MUST provide a tool to list all available components, optionally filtered or grouped by category.
- **FR-004**: The server MUST provide a tool that maps Material widget names to their Designsystemet equivalents, including property-level mappings and before/after code examples.
- **FR-005**: The server MUST provide a tool to query theme setup instructions, including DsTheme wrapping and available presets.
- **FR-006**: The server MUST provide a tool to list design tokens by category (colors, typography, sizes, border-radius, shadows, icons).
- **FR-007**: The server MUST provide a tool to search across all documentation content (component docs, getting-started guides, best practices) and return relevant excerpts with source references.
- **FR-008**: The server MUST derive component metadata from the actual library source code and documentation files in this repository — not from hardcoded data that can drift.
- **FR-009**: The server MUST be runnable via `npm start` (or equivalent) from the `mcp-server/` directory.
- **FR-010**: The server MUST be buildable and runnable as a Docker container.
- **FR-011**: The server MUST include configuration examples for connecting it to Claude Code and other MCP-compatible AI assistants.
- **FR-012**: The server MUST expose component source files (Dart) and documentation pages (Markdown) as readable MCP resources, allowing AI assistants to access raw library content on demand.
- **FR-013**: The server MUST include a `build-data` script that pre-processes component metadata and documentation into a bundled format, enabling standalone distribution without a repo checkout.
- **FR-014**: The migration mapping tool MUST cover at minimum the 20 most common Material widgets (Button variants, TextField, Checkbox, Radio, Switch, AlertDialog, Card, Tabs, Tooltip, DropdownButton, Chip, Badge, Divider, CircularProgressIndicator, Skeleton/Shimmer, List/ListView items, Table/DataTable, Breadcrumb patterns, Search/SearchBar, Pagination patterns).

### Key Entities

- **Component**: A widget in the library — has a name, category, property list, usage examples, import path, and documentation.
- **Migration Mapping**: A relationship between a Material/Cupertino widget and its Designsystemet equivalent — includes property-level correspondences and code transformation examples.
- **Design Token**: A named value in the theme system — belongs to a category (color, size, typography, shadow, border-radius) and has a name, value/description, and usage context.
- **Documentation Page**: A markdown file from the site — has a path, title, content sections, and code examples.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: AI assistants using the MCP server can correctly identify the Designsystemet equivalent for at least 90% of common Material widget queries.
- **SC-002**: Component lookup returns accurate, complete property information that matches the actual source code for 100% of library components.
- **SC-003**: The server starts and responds to its first tool call within 5 seconds of launch (both npm and Docker).
- **SC-004**: Documentation search returns relevant results for common migration questions (form building, theming, accessibility, layout) within 2 seconds.
- **SC-005**: A developer can go from zero to a connected, working MCP server in under 5 minutes following the provided setup instructions.
- **SC-006**: Migration tool provides correct, complete before/after code for at least 90% of mapped Material widgets without requiring manual edits beyond project-specific names.

## Clarifications

### Session 2026-03-14

- Q: Should the server only run from a cloned repo checkout, or also be publishable as a standalone npm package with bundled data? → A: Hybrid — local filesystem by default, with an optional `build-data` script that pre-processes and bundles component metadata for standalone npm/Docker distribution.
- Q: Should the server expose MCP resources (readable content) in addition to tools? → A: Yes — expose component source files and documentation as readable MCP resources alongside the structured tools.

## Assumptions

- The MCP server will be implemented as a Node.js/TypeScript application, which is the standard runtime for MCP servers.
- The server reads component metadata and documentation from the repository's file system by default (co-located in the same repo). An optional `build-data` script pre-processes and bundles this data, enabling standalone npm/Docker distribution without a repo checkout.
- Stdio transport is sufficient; SSE/HTTP transport is not required for the initial version.
- The migration mapping for Material → Designsystemet will be maintained as a structured data file within the server, not auto-generated.
- The server targets MCP protocol version compatible with Claude Code and Cursor as primary consumers.
- Norwegian documentation content will be served as-is; translation is not in scope.
