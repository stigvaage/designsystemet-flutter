# Quickstart: Komponentbibliotek MCP Server

**Date**: 2026-03-14
**Feature**: 003-mcp-server

## Prerequisites

- Node.js >= 18
- npm >= 9
- (Optional) Docker for container-based usage

## Option A: Run from repo checkout

```bash
# From the repository root
cd mcp-server
npm install
npm run build
npm start
```

The server reads component source and documentation directly from the repository filesystem.

## Option B: Run standalone (with bundled data)

```bash
cd mcp-server
npm install
npm run build
npm run build-data   # pre-processes components and docs into dist/data/
npm start
```

## Option C: Docker

```bash
cd mcp-server
docker build -t komponentbibliotek-mcp .
docker run -i komponentbibliotek-mcp
```

The Docker image includes bundled data — no repo checkout needed at runtime.

## Connect to Claude Code

Add to your Claude Code MCP configuration (`.mcp.json` or settings):

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "node",
      "args": ["/path/to/komponentbibliotek.flutter/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "/path/to/komponentbibliotek.flutter"
      }
    }
  }
}
```

Or with npx (after npm publish):

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "npx",
      "args": ["@komponentbibliotek/mcp-server"]
    }
  }
}
```

## Verify

Once connected, ask your AI assistant:
- "List all Designsystemet components"
- "How do I replace Material's ElevatedButton?"
- "Show me the theme setup"

## Available Tools

| Tool | Description |
|------|-------------|
| `lookup_component` | Get full API details for a component |
| `list_components` | List all components, optionally by category |
| `get_migration_mapping` | Map Material widgets to Ds equivalents |
| `get_theme_setup` | Get theme setup instructions |
| `list_tokens` | List design tokens by category |
| `search_docs` | Search documentation content |

## Available Resources

| Resource | Description |
|----------|-------------|
| `component:///{path}` | Read raw Dart source files |
| `docs:///{path}` | Read raw documentation markdown |
