# Implementation Plan: Komponentbibliotek MCP Server

**Branch**: `003-mcp-server` | **Date**: 2026-03-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/003-mcp-server/spec.md`

## Summary

Build an MCP server (TypeScript/Node.js) that exposes the Komponentbibliotek-Flutter component library's APIs, design tokens, documentation, and Material-to-Designsystemet migration mappings as MCP tools and resources. The server parses Dart source files and markdown documentation at build time, serves structured responses via stdio transport, and runs via npm or Docker.

## Technical Context

**Language/Version**: TypeScript 5.x / Node.js >= 18
**Primary Dependencies**: `@modelcontextprotocol/sdk` v1.x, `zod` v3, `minisearch` (doc search indexing)
**Storage**: Filesystem (read-only) + pre-processed JSON bundles in `dist/data/`
**Testing**: `vitest` (fast, TypeScript-native, no config overhead)
**Target Platform**: macOS / Linux / Windows (any Node.js environment)
**Project Type**: CLI tool (MCP server over stdio)
**Performance Goals**: <5s startup, <2s search response, <100ms tool responses
**Constraints**: No runtime Dart SDK dependency; all parsing done in TypeScript via regex
**Scale/Scope**: ~43 widgets (components + typography), ~40 doc pages, ~20 migration mappings

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Applies? | Status | Notes |
|-----------|----------|--------|-------|
| I. Designsystemet Fidelity | Indirect | Pass | Server must accurately describe components; it doesn't create them |
| II. Token-Driven Architecture | Indirect | Pass | Server describes the token system; doesn't use tokens itself |
| III. Theme Portability | No | N/A | Not a Flutter component |
| IV. CLI-First Tooling | Yes | Pass | The MCP server itself is CLI tooling; `build-data` script follows this principle |
| V. Flutter-Idiomatic API | No | N/A | TypeScript project, not a Flutter widget |
| VI. Test-First Development | Partial | Pass | Spirit followed (tests for parser, tools, integration); golden/widget tests N/A for a CLI tool |
| VII. Accessibility Compliance | No | N/A | Not a UI; the server *serves* accessibility documentation |

**Gate result**: PASS — no violations. Principles V/VI/VII don't apply to an adjacent TypeScript CLI tool.

## Project Structure

### Documentation (this feature)

```text
specs/003-mcp-server/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 research findings
├── data-model.md        # Entity definitions
├── quickstart.md        # Setup guide
├── contracts/
│   └── mcp-tools.md     # Tool and resource API contracts
└── checklists/
    └── requirements.md  # Spec quality checklist
```

### Source Code (repository root)

```text
mcp-server/
├── package.json
├── tsconfig.json
├── Dockerfile
├── src/
│   ├── index.ts              # Entry point: create server, connect stdio
│   ├── server.ts             # McpServer setup, tool/resource registration
│   ├── tools/
│   │   ├── lookup-component.ts
│   │   ├── list-components.ts
│   │   ├── get-migration-mapping.ts
│   │   ├── get-theme-setup.ts
│   │   ├── list-tokens.ts
│   │   └── search-docs.ts
│   ├── resources/
│   │   ├── component-source.ts   # component:/// resource template
│   │   └── documentation.ts      # docs:/// resource template
│   ├── parsers/
│   │   ├── dart-parser.ts        # Two-pass regex Dart constructor parser
│   │   ├── markdown-parser.ts    # Extract sections, examples, property tables
│   │   └── token-parser.ts       # Parse theme token classes and enums
│   ├── data/
│   │   ├── migrations.json       # Curated Material → Ds mapping data
│   │   ├── categories.json       # Component category assignments
│   │   └── theme-setup.md        # Theme setup instructions template
│   ├── search/
│   │   └── doc-index.ts          # MiniSearch indexing and query logic
│   └── utils/
│       ├── paths.ts              # Resolve repo root, lib paths, doc paths
│       └── format.ts             # Response formatting helpers
├── scripts/
│   └── build-data.ts            # Pre-process components + docs → dist/data/
└── tests/
    └── parsers/
        └── dart-parser.test.ts   # Critical parser correctness tests
```

**Structure Decision**: Single project under `mcp-server/` directory in the monorepo. TypeScript source in `src/`, tests co-located in `tests/`, curated data in `src/data/`, build output in `dist/`.

## Complexity Tracking

No constitution violations requiring justification. The MCP server is an adjacent tool, not a Flutter component, so Flutter-specific principles (V, VI golden tests, VII) don't apply.
