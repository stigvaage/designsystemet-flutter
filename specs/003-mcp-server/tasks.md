# Tasks: Komponentbibliotek MCP Server

**Input**: Design documents from `/specs/003-mcp-server/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Included for critical parsers only (Dart parser correctness is essential for FR-008: derive from actual source code).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize the mcp-server project with dependencies and basic structure

- [x] T001 Create mcp-server/ directory with package.json (name: @komponentbibliotek/mcp-server, type: module) and tsconfig.json (target: ES2022, module: Node16, outDir: dist) in mcp-server/
- [x] T002 Install production dependencies: @modelcontextprotocol/sdk, zod, minisearch in mcp-server/
- [x] T003 Install dev dependencies: typescript, vitest, @types/node in mcp-server/
- [x] T004 [P] Create utility modules: src/utils/paths.ts (resolveRepoRoot, resolveLibPath, resolveDocsPath using REPO_ROOT env var with fallback to `../../`) and src/utils/format.ts (formatPropertyTable, formatCodeBlock, formatComponentSummary helpers) in mcp-server/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core parsers and server skeleton that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 Create src/parsers/dart-parser.ts in mcp-server/ — implement two-pass regex parser: Pass 1 extracts constructor parameters via `/const\s+\w+\(\{([^}]+)\}\)/s`, Pass 2 extracts field types via `/final\s+([\w<>,?\s]+\??)\s+(\w+)\s*;/g`, correlate by name, skip `super.key`. Export `parseComponent(filePath): Component` and `parseAllComponents(libDir): Component[]`
- [x] T006 [P] Create src/parsers/markdown-parser.ts in mcp-server/ — parse documentation markdown files to extract title, sections (by heading), fenced code blocks as examples, and property tables. Export `parseDocPage(filePath): DocumentationPage` and `extractCodeExamples(content): CodeExample[]`
- [x] T007 [P] Create src/data/categories.json in mcp-server/ — map each of the 42 components to a category: form (DsInput, DsTextfield, DsTextarea, DsCheckbox, DsRadio, DsSwitch, DsSelect, DsDropdown, DsField, DsFieldset, DsErrorSummary), navigation (DsButton, DsLink, DsBreadcrumbs, DsPagination, DsSkipLink, DsTabs), layout (DsCard, DsCardHeader, DsCardBlock, DsCardFooter, DsDialog, DsPopover, DsDivider), content (DsAlert, DsBadge, DsTag, DsChip, DsAvatar, DsAvatarStack, DsSpinner, DsSkeleton), interactive (DsToggleGroup, DsTooltip, DsDetails, DsSearch, DsSuggestion, DsList, DsTable), typography (DsHeading, DsParagraph, DsLabel, DsValidationMessage)
- [x] T008 Create src/index.ts and src/server.ts in mcp-server/ — index.ts: instantiate McpServer({name: "komponentbibliotek", version: from package.json}), connect StdioServerTransport; server.ts: export createServer() that creates McpServer and registers all tools and resources (initially empty, tools added in later phases)
- [x] T009 [P] Write parser tests in mcp-server/tests/parsers/dart-parser.test.ts — test parseComponent against actual lib/src/components/button/ds_button.dart: verify name="DsButton", verify properties include variant (type DsButtonVariant, default DsButtonVariant.primary), onPressed (required, VoidCallback?), child (required, Widget). Test parseComponent against lib/src/components/alert/ds_alert.dart for a second component

**Checkpoint**: Foundation ready — parsers work, server starts on stdio, user story implementation can begin

---

## Phase 3: User Story 1 — Look Up Component API (Priority: P1) 🎯 MVP

**Goal**: AI assistants can look up any component by name and list all components by category

**Independent Test**: Call `lookup_component` with "DsButton" and verify response contains all 10 properties, import statement, and code examples. Call `list_components` and verify all 42 components appear grouped by 6 categories.

### Implementation for User Story 1

- [x] T010 [P] [US1] Create src/tools/lookup-component.ts in mcp-server/ — register tool "lookup_component" with input schema {name: z.string()}, handler: find component by exact name or case-insensitive partial match, return formatted property table + import statement + code examples from docs. On not-found: return similar name suggestions using Levenshtein or prefix match
- [x] T011 [P] [US1] Create src/tools/list-components.ts in mcp-server/ — register tool "list_components" with input schema {category: z.string().optional()}, handler: return all components grouped by category (from categories.json), each with name and one-line description. If category filter provided, return only that group
- [x] T012 [US1] Create src/resources/component-source.ts in mcp-server/ — register ResourceTemplate "component:///{path}" that lists all .dart files under lib/src/components/ and lib/src/typography/, reads file content on demand with mimeType "text/x-dart"
- [x] T013 [US1] Wire US1 tools and resources into src/server.ts in mcp-server/ — import and call registration functions from lookup-component.ts, list-components.ts, component-source.ts inside createServer()

**Checkpoint**: `lookup_component` and `list_components` tools work. Component source files readable as resources. This is the MVP — test by starting server and calling tools.

---

## Phase 4: User Story 2 — Get Migration Mapping (Priority: P1)

**Goal**: AI assistants can query Material widget names and receive Designsystemet equivalents with property mappings and before/after code

**Independent Test**: Call `get_migration_mapping` with "ElevatedButton" and verify response contains DsButton as target, property mapping table, and before/after code snippets. Call with "AppBar" and verify "no direct mapping" response with suggestions.

### Implementation for User Story 2

- [x] T014 [US2] Create src/data/migrations.json in mcp-server/ — curated JSON file with mappings for 20+ Material widgets: ElevatedButton→DsButton, OutlinedButton→DsButton(secondary), TextButton→DsButton(tertiary), TextField→DsTextfield, Checkbox→DsCheckbox, Radio→DsRadio, Switch→DsSwitch, AlertDialog→DsDialog, Card→DsCard, Tab/TabBar→DsTabs, Tooltip→DsTooltip, DropdownButton→DsSelect, Chip→DsChip, Badge→DsBadge, Divider→DsDivider, CircularProgressIndicator→DsSpinner, LinearProgressIndicator→DsSkeleton, ListTile→DsList, DataTable→DsTable, SearchBar→DsSearch. Each entry: materialWidget, dsComponent, notes, propertyMappings[], beforeCode, afterCode
- [x] T015 [US2] Create src/tools/get-migration-mapping.ts in mcp-server/ — register tool "get_migration_mapping" with input schema {widget: z.string()}, handler: look up widget name (case-insensitive, also match without "Material" prefix), return formatted migration guide with target component, property mapping table, notes, and before/after code. On not-found: return message with list of available mappings
- [x] T016 [US2] Wire US2 tool into src/server.ts in mcp-server/

**Checkpoint**: Migration tool works. Combined with US1, an AI assistant can now look up components AND get migration guidance.

---

## Phase 5: User Story 3 — Query Theme and Token Reference (Priority: P2)

**Goal**: AI assistants can get theme setup instructions and browse all design tokens by category

**Independent Test**: Call `get_theme_setup` and verify response includes DsTheme wrapping, DsThemeDigdir.light()/dark() usage, and imports. Call `list_tokens` with "colors" and verify all 9 color types with 16 scale stops returned.

### Implementation for User Story 3

- [x] T017 [P] [US3] Create src/parsers/token-parser.ts in mcp-server/ — parse lib/src/theme/ds_color_scale.dart (extract 16 color scale fields), lib/src/theme/ds_typography.dart (extract heading and body style names), lib/src/theme/ds_size_tokens.dart (extract size scale), lib/src/theme/ds_border_radius_tokens.dart (extract radius values), lib/src/theme/ds_shadow_tokens.dart (extract shadow names), lib/src/utils/ds_icons.dart (extract DsIcons constants). Export `parseTokens(category, repoRoot): DesignToken[]`
- [x] T018 [P] [US3] Create src/data/theme-setup.md in mcp-server/ — markdown template with step-by-step theme setup: 1) add dependency, 2) import theme.dart, 3) wrap app with DsTheme(data: DsThemeDigdir.light()), 4) use DsColorScope/DsSizeScope for scoping, 5) access tokens via DsTheme.of(context). Include complete code example
- [x] T019 [US3] Create src/tools/get-theme-setup.ts in mcp-server/ — register tool "get_theme_setup" with no input params, handler: read and return theme-setup.md content
- [x] T020 [US3] Create src/tools/list-tokens.ts in mcp-server/ — register tool "list_tokens" with input schema {category: z.enum(["colors", "typography", "sizes", "border-radius", "shadows", "icons"])}, handler: call parseTokens for the category, return formatted token list with names, descriptions, and usage context
- [x] T021 [US3] Wire US3 tools into src/server.ts in mcp-server/

**Checkpoint**: Theme setup and token reference tools work. Developers can now understand the full design system.

---

## Phase 6: User Story 4 — Search Documentation (Priority: P2)

**Goal**: AI assistants can search across all documentation and get relevant excerpts

**Independent Test**: Call `search_docs` with "form validation" and verify results include DsField, DsFieldset, DsErrorSummary docs. Call with "tastatur" (Norwegian for keyboard) and verify accessibility docs returned.

### Implementation for User Story 4

- [x] T022 [US4] Create src/search/doc-index.ts in mcp-server/ — build MiniSearch index over all markdown files in site/nb/ at startup: index on title, content, section headings, and component names (DsButton, DsAlert, etc.) to support both English and Norwegian queries. Export `buildIndex(docsDir): MiniSearch`, `searchDocs(index, query): SearchResult[]` with title, path, excerpt (surrounding matched text), section heading. Handle empty results with helpful message
- [x] T023 [US4] Create src/tools/search-docs.ts in mcp-server/ — register tool "search_docs" with input schema {query: z.string()}, handler: search the pre-built index, return top 10 results formatted with title, path, relevant excerpt, and section
- [x] T024 [US4] Create src/resources/documentation.ts in mcp-server/ — register ResourceTemplate "docs:///{path}" that lists all .md files under site/nb/, reads file content on demand with mimeType "text/markdown"
- [x] T025 [US4] Wire US4 tool and resource into src/server.ts in mcp-server/

**Checkpoint**: Documentation search works. All 6 tools and 2 resource templates are now functional.

---

## Phase 7: User Story 5 — npm and Docker Distribution (Priority: P3)

**Goal**: Server runs via npm start and Docker, with configuration examples for AI assistants

**Independent Test**: Run `npm start` from mcp-server/ and verify server responds to a tool call. Build Docker image and verify same. Follow config example to connect to Claude Code.

### Implementation for User Story 5

- [x] T026 [US5] Create mcp-server/scripts/build-data.ts — script that runs all parsers (dart-parser on lib/src/components/, markdown-parser on site/nb/, token-parser on lib/src/theme/) and writes pre-processed JSON to dist/data/components.json, dist/data/docs.json, dist/data/tokens.json. Update src/server.ts to check for bundled data in dist/data/ before falling back to live filesystem parsing
- [x] T027 [P] [US5] Create mcp-server/Dockerfile — multi-stage: build stage (node:18-alpine, copy repo, npm ci, npm run build, npm run build-data), runtime stage (node:18-alpine, copy dist/ only, ENTRYPOINT ["node", "dist/index.js"])
- [x] T028 [US5] Add npm scripts to mcp-server/package.json — "build": "tsc", "start": "node dist/index.js", "build-data": "tsx scripts/build-data.ts", "dev": "tsx src/index.ts"
- [x] T029 [US5] Create MCP configuration examples — add Claude Code config snippet to mcp-server/README.md showing both local (node dist/index.js with REPO_ROOT) and npx usage. Include Cursor and generic MCP client examples

**Checkpoint**: Server distributable via npm and Docker. Configuration documented.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Error handling, validation, and final verification

- [x] T030 Add error handling and graceful degradation across all tools in mcp-server/src/tools/ — wrap each handler in try/catch, return helpful error messages for missing files, parse failures, and invalid inputs. Log errors to stderr
- [x] T031 [P] End-to-end verification: start mcp-server via `npm start`, call each of the 6 tools with sample inputs from spec acceptance scenarios, verify responses match expected format and content. Confirm startup completes within 5 seconds (SC-003) and search responds within 2 seconds (SC-004)
- [x] T032 Validate quickstart.md — follow the setup instructions from specs/003-mcp-server/quickstart.md end-to-end, verify server starts and tools respond correctly

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3–7)**: All depend on Foundational phase completion
  - US1 (Phase 3) and US2 (Phase 4) can proceed in parallel after Foundation
  - US3 (Phase 5) and US4 (Phase 6) can proceed in parallel after Foundation
  - US5 (Phase 7) depends on all tools being implemented (Phases 3–6)
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 — no dependencies on other stories
- **US2 (P1)**: Can start after Phase 2 — no dependencies on other stories (uses its own curated data)
- **US3 (P2)**: Can start after Phase 2 — no dependencies on other stories
- **US4 (P2)**: Can start after Phase 2 — no dependencies on other stories
- **US5 (P3)**: Depends on US1–US4 being complete (build-data must process all tools' data)

### Within Each User Story

- Parsers/data before tools
- Tools before server registration
- All tasks within a story are sequential unless marked [P]

### Parallel Opportunities

- T002 + T003 (install deps) can run as single command
- T004 (utils) can run in parallel with T005–T007 (parsers/data)
- T010 + T011 (lookup + list tools) can run in parallel
- T017 + T018 (token parser + theme-setup.md) can run in parallel
- US1 + US2 can run in parallel (different tools, different data)
- US3 + US4 can run in parallel (different tools, different data)
- T027 (Dockerfile) can run in parallel with T028 (npm scripts)

---

## Parallel Example: User Story 1

```bash
# After Phase 2 Foundation is complete, launch US1 tools in parallel:
Task T010: "Create lookup-component.ts in mcp-server/src/tools/"
Task T011: "Create list-components.ts in mcp-server/src/tools/"

# Then sequentially:
Task T012: "Create component-source.ts in mcp-server/src/resources/"
Task T013: "Wire into server.ts"
```

## Parallel Example: US1 + US2 simultaneously

```bash
# Both are P1 priority and can start after Foundation:
# Developer A: US1 (T010 → T011 → T012 → T013)
# Developer B: US2 (T014 → T015 → T016)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (parsers, server skeleton)
3. Complete Phase 3: User Story 1 (lookup_component + list_components)
4. **STOP and VALIDATE**: Start server, call `lookup_component` with "DsButton", verify response
5. This MVP alone provides significant value — AI assistants can browse the full component library

### Incremental Delivery

1. Setup + Foundation → Server skeleton running
2. Add US1 → Component lookup works → **MVP!**
3. Add US2 → Migration guidance works → Primary use case complete
4. Add US3 → Theme/tokens work → Full design system reference
5. Add US4 → Search works → Documentation discoverable
6. Add US5 → Distributable via npm/Docker → Team adoption ready
7. Each story adds value without breaking previous stories

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- The migrations.json (T014) is the largest single task — 20+ curated entries with property mappings and code examples
- Parser tests (T009) cover the most fragile code — run them after any dart-parser.ts changes
