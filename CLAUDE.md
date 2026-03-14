# komponentbibliotek.flutter Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-03-14

## Active Technologies
- Dart 3.3+ / Flutter 3.19+ (matches library) + `widgetbook` (latest stable), `widgetbook_annotation`, `widgetbook_generator` (for code-gen approach), `build_runner` (002-widgetbook-docs-site)
- N/A (static web app) (002-widgetbook-docs-site)
- TypeScript 5.x / Node.js >= 18 + `@modelcontextprotocol/sdk` v1.x, `zod` v3, `minisearch` (doc search indexing) (003-mcp-server)
- Filesystem (read-only) + pre-processed JSON bundles in `dist/data/` (003-mcp-server)

- Dart 3.3+ (null-safe, pattern matching, sealed classes) + `package:flutter/widgets.dart`, `package:flutter/rendering.dart` (no Material/Cupertino visual deps); Inter font bundled as package asse (001-designsystemet-flutter-lib)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Dart 3.3+ (null-safe, pattern matching, sealed classes)

## Code Style

Dart 3.3+ (null-safe, pattern matching, sealed classes): Follow standard conventions

## Recent Changes
- 003-mcp-server: Added TypeScript 5.x / Node.js >= 18 + `@modelcontextprotocol/sdk` v1.x, `zod` v3, `minisearch` (doc search indexing)
- 002-widgetbook-docs-site: Added Dart 3.3+ / Flutter 3.19+ (matches library) + `widgetbook` (latest stable), `widgetbook_annotation`, `widgetbook_generator` (for code-gen approach), `build_runner`

- 001-designsystemet-flutter-lib: Added Dart 3.3+ (null-safe, pattern matching, sealed classes) + `package:flutter/widgets.dart`, `package:flutter/rendering.dart` (no Material/Cupertino visual deps); Inter font bundled as package asse

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
