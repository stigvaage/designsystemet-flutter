# MCP Tool Contracts

**Date**: 2026-03-14
**Feature**: 003-mcp-server

## Tool 1: `lookup_component`

Look up a component by name, returning its full API details.

**Input Schema**:
```json
{
  "name": { "type": "string", "description": "Component name, e.g. 'DsButton' or 'button'" }
}
```

**Output**: Text content with component name, category, import statement, property table (name, type, required, default), and code examples. If not found, returns similar component suggestions.

---

## Tool 2: `list_components`

List all available components, optionally filtered by category.

**Input Schema**:
```json
{
  "category": { "type": "string", "description": "Optional filter: form, navigation, layout, content, interactive, typography", "optional": true }
}
```

**Output**: Text content with components grouped by category — each entry has name and one-line description.

---

## Tool 3: `get_migration_mapping`

Get the Designsystemet equivalent of a Material/Cupertino widget.

**Input Schema**:
```json
{
  "widget": { "type": "string", "description": "Material or Cupertino widget name, e.g. 'ElevatedButton', 'TextField'" }
}
```

**Output**: Text content with target Ds component, property mapping table (Material prop → Ds prop + transform notes), and before/after code snippets. If no mapping exists, returns message with closest alternatives.

---

## Tool 4: `get_theme_setup`

Get instructions for setting up the Designsystemet theme in a Flutter app.

**Input Schema**: (none — no parameters)

**Output**: Text content with step-by-step theme setup: import statements, `DsTheme` wrapping, `DsThemeDigdir.light()`/`dark()` usage, `DsColorScope`/`DsSizeScope` examples.

---

## Tool 5: `list_tokens`

List design tokens by category.

**Input Schema**:
```json
{
  "category": { "type": "string", "description": "Token category: colors, typography, sizes, border-radius, shadows, icons" }
}
```

**Output**: Text content with all tokens in the requested category — names, descriptions, and usage context.

---

## Tool 6: `search_docs`

Search across all documentation content.

**Input Schema**:
```json
{
  "query": { "type": "string", "description": "Search query, e.g. 'form validation', 'keyboard navigation'" }
}
```

**Output**: Text content with ranked results — each result has document title, path, relevant excerpt, and section heading. Returns empty set message if no matches.

---

# MCP Resource Contracts

## Resource Template: `component:///{path}`

Exposes component Dart source files as readable resources.

**URI pattern**: `component:///lib/src/components/button/ds_button.dart`

**List**: Returns all component source file URIs.

**Read**: Returns the raw Dart source content with `text/x-dart` MIME type.

---

## Resource Template: `docs:///{path}`

Exposes documentation markdown files as readable resources.

**URI pattern**: `docs:///site/nb/komponenter/ds-button.md`

**List**: Returns all documentation file URIs.

**Read**: Returns the raw markdown content with `text/markdown` MIME type.
