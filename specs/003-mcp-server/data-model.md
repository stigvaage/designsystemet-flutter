# Data Model: Komponentbibliotek MCP Server

**Date**: 2026-03-14
**Feature**: 003-mcp-server

## Entities

### Component

Represents a Flutter widget in the library.

| Field | Type | Description |
|-------|------|-------------|
| name | string | Widget class name (e.g., "DsButton") |
| category | string | Grouping: "form", "navigation", "layout", "content", "interactive", "typography" |
| importPath | string | Dart import statement (e.g., "package:komponentbibliotek_flutter/components.dart") |
| sourcePath | string | Relative path to source file (e.g., "lib/src/components/button/ds_button.dart") |
| properties | Property[] | Constructor parameters (see below) |
| description | string | Extracted from documentation or dartdoc comment |
| examples | CodeExample[] | Usage examples from documentation |
| docPath | string \| null | Relative path to documentation markdown (e.g., "site/nb/komponenter/ds-button.md") |

### Property

A constructor parameter of a component widget.

| Field | Type | Description |
|-------|------|-------------|
| name | string | Parameter name (e.g., "variant") |
| type | string | Dart type (e.g., "DsButtonVariant") |
| required | boolean | Whether marked `required` in constructor |
| defaultValue | string \| null | Default value expression (e.g., "DsButtonVariant.primary") |
| isNullable | boolean | Whether type ends with `?` |
| description | string \| null | Extracted from property table in docs or dartdoc |

### MigrationMapping

Maps a Material/Cupertino widget to its Designsystemet equivalent.

| Field | Type | Description |
|-------|------|-------------|
| materialWidget | string | Material widget name (e.g., "ElevatedButton") |
| dsComponent | string | Target Ds component name (e.g., "DsButton") |
| notes | string | Migration notes and caveats |
| propertyMappings | PropertyMapping[] | Per-property correspondences |
| beforeCode | string | Example Material code snippet |
| afterCode | string | Equivalent Designsystemet code snippet |

### PropertyMapping

Maps a Material property to its Designsystemet equivalent.

| Field | Type | Description |
|-------|------|-------------|
| materialProp | string | Material property path (e.g., "decoration.errorText") |
| dsProp | string | Ds property name (e.g., "error") |
| transform | string \| null | Transformation note (e.g., "Use DsButtonVariant enum instead of ButtonStyle") |

### DesignToken

A named value in the theme system.

| Field | Type | Description |
|-------|------|-------------|
| name | string | Token name (e.g., "backgroundDefault") |
| category | string | "colors", "typography", "sizes", "border-radius", "shadows", "icons" |
| value | string | Human-readable value description |
| context | string | Usage context (e.g., "16 stops per color scale") |

### DocumentationPage

An indexed documentation page.

| Field | Type | Description |
|-------|------|-------------|
| title | string | Page title (e.g., "DsButton") |
| path | string | Relative file path |
| content | string | Full markdown content |
| sections | string[] | Section headings for filtering |
| keywords | string[] | Extracted terms for search indexing |

## Relationships

```
Component 1──* Property          (a component has many constructor parameters)
Component 1──1 DocumentationPage (a component may have one doc page)
MigrationMapping *──1 Component  (many Material widgets map to one Ds component)
MigrationMapping 1──* PropertyMapping (a mapping has many property correspondences)
DesignToken *──1 Category        (tokens are grouped by category)
```

## Data Sources

| Entity | Source | Parse Strategy |
|--------|--------|----------------|
| Component | `lib/src/components/**/*.dart` | Two-pass regex (constructor + fields) |
| Component.examples | `site/nb/komponenter/*.md` | Extract fenced code blocks |
| MigrationMapping | `mcp-server/data/migrations.json` | Curated JSON file |
| DesignToken | `lib/src/theme/*.dart`, `lib/src/utils/ds_enums.dart` | Regex on class fields and enum values |
| DocumentationPage | `site/nb/**/*.md` | Read and index markdown files |
