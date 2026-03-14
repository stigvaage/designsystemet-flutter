# Research: Komponentbibliotek MCP Server

**Date**: 2026-03-14
**Feature**: 003-mcp-server

## Decision 1: MCP SDK

**Decision**: Use `@modelcontextprotocol/sdk` v1.x (latest: 1.27.1) with `zod` v3 for schema validation.

**Rationale**: v1.x is the production-stable SDK. v2 is pre-alpha. The v1 API provides `McpServer`, `StdioServerTransport`, `ResourceTemplate`, and `registerTool`/`registerResource` methods — covering all our needs (tools, resources, stdio transport).

**Alternatives considered**:
- v2 SDK (`@modelcontextprotocol/server`) — rejected; pre-alpha, API unstable
- Building on raw protocol — rejected; unnecessary complexity when official SDK exists

**Key API patterns**:
- `McpServer` from `@modelcontextprotocol/sdk/server/mcp.js`
- `StdioServerTransport` from `@modelcontextprotocol/sdk/server/stdio.js`
- `ResourceTemplate` for dynamic file-based resources
- Tool input schemas defined via Zod, auto-converted to JSON Schema on the wire

## Decision 2: Dart Source Parsing

**Decision**: Two-pass regex approach in TypeScript — no external Dart parser needed.

**Rationale**: No production-grade Dart AST parser exists on npm. The codebase's 30+ widget constructors follow a highly consistent pattern (`const ClassName({this.param, required this.param, this.param = default})`), making regex reliable. The two-pass strategy (constructor params → field types → correlate) captures name, type, required flag, default value, and nullability.

**Alternatives considered**:
- `flutter-ast` (npm) — rejected; experimental, pre-release, 11 weekly downloads
- `@nx-dart/dart-parser` (npm) — rejected; parses pubspec.yaml not Dart source
- Dart SDK `package:analyzer` — rejected; requires Dart runtime, adds build dependency
- `dartdoc_json` (pub.dev) — rejected; requires Dart SDK installed

**Parsing strategy**:
- Pass 1: Extract constructor parameters via `/const\s+ClassName\(\{([^}]+)\}\)/s`, then parse each param with `/(required\s+)?(?:super|this)\.(\w+)(?:\s*=\s*(.+))?/`
- Pass 2: Extract field types via `/final\s+([\w<>,?\s]+)\s+(\w+);/g`
- Pass 3: Correlate by name, skip `super.key`

## Decision 3: Documentation Search

**Decision**: Keyword-based search with simple TF-IDF-style relevance ranking over pre-indexed markdown content.

**Rationale**: The documentation corpus is small (~40 markdown files). Full-text search libraries like Lunr.js or MiniSearch provide keyword search with relevance scoring, are lightweight (no external service), and work offline. This is sufficient for the use case — AI assistants will refine queries themselves.

**Alternatives considered**:
- Embedding-based semantic search — rejected; requires external API or model, over-engineered for ~40 docs
- Simple `grep`-style matching — rejected; no relevance ranking
- Full Elasticsearch — rejected; massive overkill for the corpus size

## Decision 4: Build & Distribution

**Decision**: TypeScript compiled with `tsc`, bundled data via a `build-data` script that runs the Dart parser and markdown indexer, output to `dist/data/`.

**Rationale**: TypeScript is standard for MCP servers. The `build-data` script pre-processes Dart source files and markdown docs into JSON, enabling standalone distribution. When running from the repo, the server can read live from the filesystem as a fallback.

**Alternatives considered**:
- esbuild/rollup bundling — deferred; tsc is sufficient for a CLI tool
- Runtime-only parsing (no build-data) — rejected; conflicts with standalone npm distribution requirement

## Decision 5: Docker

**Decision**: Multi-stage Dockerfile — build stage compiles TypeScript + runs build-data, runtime stage is a slim Node.js alpine image.

**Rationale**: Standard pattern for Node.js CLI tools in Docker. Multi-stage keeps the image small. The build-data output is included in the image, so no repo checkout needed at runtime.

**Alternatives considered**:
- Single-stage Dockerfile — rejected; larger image with dev dependencies
- Distroless — considered but alpine is simpler and well-understood
