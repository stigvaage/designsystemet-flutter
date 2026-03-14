#!/usr/bin/env tsx
/**
 * Pre-processes component metadata, documentation, and tokens into
 * bundled JSON files for standalone distribution.
 *
 * Usage: npm run build-data
 * Output: dist/data/components.json, dist/data/docs.json, dist/data/tokens.json
 */
import { mkdirSync, writeFileSync } from "node:fs";
import { resolve, join } from "node:path";
import { parseAllComponents } from "../src/parsers/dart-parser.js";
import { parseAllDocs } from "../src/parsers/markdown-parser.js";
import { parseTokens } from "../src/parsers/token-parser.js";

const repoRoot = resolve(import.meta.dirname, "..", "..");
const outDir = resolve(import.meta.dirname, "..", "dist", "data");

mkdirSync(outDir, { recursive: true });

console.error("Building component data...");
const components = parseAllComponents(repoRoot);
writeFileSync(join(outDir, "components.json"), JSON.stringify(components, null, 2));
console.error(`  → ${components.length} components`);

console.error("Building documentation index...");
const docs = parseAllDocs(join(repoRoot, "site", "nb"), repoRoot);
writeFileSync(join(outDir, "docs.json"), JSON.stringify(docs, null, 2));
console.error(`  → ${docs.length} pages`);

console.error("Building token data...");
const categories = ["colors", "typography", "sizes", "border-radius", "shadows", "icons"] as const;
const tokens: Record<string, unknown[]> = {};
for (const cat of categories) {
  tokens[cat] = parseTokens(cat, repoRoot);
}
writeFileSync(join(outDir, "tokens.json"), JSON.stringify(tokens, null, 2));
console.error(`  → ${Object.values(tokens).flat().length} tokens`);

console.error("Build data complete.");
