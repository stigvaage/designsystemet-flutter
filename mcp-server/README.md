# Komponentbibliotek MCP Server

MCP server that exposes the Komponentbibliotek-Flutter component library to AI coding assistants. Provides component API lookup, Material-to-Designsystemet migration mappings, theme/token reference, and documentation search.

## Quick Start

```bash
cd mcp-server
npm install
npm run build
npm start
```

## Tools

| Tool | Description |
|------|-------------|
| `lookup_component` | Look up a component by name — returns properties, examples, imports |
| `list_components` | List all components, optionally filtered by category |
| `get_migration_mapping` | Map a Material widget to its Designsystemet equivalent |
| `get_theme_setup` | Get step-by-step theme setup instructions |
| `list_tokens` | List design tokens by category (colors, typography, sizes, etc.) |
| `search_docs` | Search across all documentation content |

## Resources

| Resource | Description |
|----------|-------------|
| `component:///{path}` | Read component Dart source files |
| `docs:///{path}` | Read documentation markdown files |

## Connect to Claude Code

Add to your project's `.mcp.json`:

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

Or run in dev mode:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "npx",
      "args": ["tsx", "/path/to/komponentbibliotek.flutter/mcp-server/src/index.ts"],
      "env": {
        "REPO_ROOT": "/path/to/komponentbibliotek.flutter"
      }
    }
  }
}
```

## Connect to Cursor

Add to `.cursor/mcp.json`:

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

## Docker

```bash
cd /path/to/komponentbibliotek.flutter
docker build -t komponentbibliotek-mcp -f mcp-server/Dockerfile .
docker run -i komponentbibliotek-mcp
```

## Standalone Distribution

To run without a repo checkout, pre-bundle the data:

```bash
npm run build
npm run build-data
# dist/ now contains everything needed
```
