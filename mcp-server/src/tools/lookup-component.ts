import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { parseAllComponents } from "../parsers/dart-parser.js";
import { parseDocPage, extractCodeExamples } from "../parsers/markdown-parser.js";
import { formatComponentSummary } from "../utils/format.js";
import { resolveComponentDocsPath } from "../utils/paths.js";

interface CategoryMap {
  [category: string]: string[];
}

export function registerLookupComponent(
  server: McpServer,
  repoRoot: string,
): void {
  // Parse all components and assign their categories ONCE at registration time
  // (mirrors search-docs.ts's build-index-once pattern). The MCP server runs
  // against a fixed checkout, so caching is safe and avoids re-reading and
  // re-parsing all ~40 Dart files plus categories.json on every invocation.
  const categoriesPath = join(
    import.meta.dirname,
    "..",
    "data",
    "categories.json",
  );
  const categories: CategoryMap = JSON.parse(
    readFileSync(categoriesPath, "utf-8"),
  );
  const components = parseAllComponents(repoRoot);
  for (const component of components) {
    for (const [cat, names] of Object.entries(categories)) {
      if (names.includes(component.name)) {
        component.category = cat;
        break;
      }
    }
  }

  server.tool(
    "lookup_component",
    "Look up a Designsystemet Flutter component by name. Returns properties, usage examples, and import statement.",
    { name: z.string().describe("Component name, e.g. 'DsButton' or 'button'") },
    async ({ name }) => {
      // Normalize the search term
      const searchTerm = name.trim();
      const searchLower = searchTerm.toLowerCase();
      const searchWithoutPrefix = searchLower.replace(/^ds/, "");

      // Try exact match first
      let found = components.find(
        (c) => c.name.toLowerCase() === searchLower,
      );

      // Try matching without "Ds" prefix (e.g. "button" matches "DsButton")
      if (!found) {
        found = components.find(
          (c) => c.name.toLowerCase().replace(/^ds/, "") === searchWithoutPrefix,
        );
      }

      // Try case-insensitive partial match
      if (!found) {
        found = components.find(
          (c) =>
            c.name.toLowerCase().includes(searchWithoutPrefix) ||
            c.name.toLowerCase().replace(/^ds/, "").includes(searchWithoutPrefix),
        );
      }

      if (!found) {
        // Suggest similar names using simple prefix matching
        const suggestions = components
          .filter((c) => {
            const componentName = c.name.toLowerCase().replace(/^ds/, "");
            return (
              componentName.startsWith(searchWithoutPrefix.slice(0, 3)) ||
              searchWithoutPrefix.startsWith(componentName.slice(0, 3))
            );
          })
          .map((c) => c.name);

        const suggestionText =
          suggestions.length > 0
            ? `\n\nDid you mean one of these?\n${suggestions.map((s) => `  - ${s}`).join("\n")}`
            : `\n\nAvailable components:\n${components.map((c) => `  - ${c.name}`).join("\n")}`;

        return {
          content: [
            {
              type: "text" as const,
              text: `Component "${searchTerm}" not found.${suggestionText}`,
            },
          ],
        };
      }

      // Load documentation page if it exists. The doc files are ds-prefixed,
      // e.g. site/nb/komponenter/ds-button.md, ds-error-summary.md. Some files
      // collapse the name (DsTextField -> ds-textfield.md), so we also try a
      // flat (no-hyphen) variant in addition to the kebab-case one.
      const docsDir = resolveComponentDocsPath(repoRoot);
      const baseSlug = found.name.replace(/^Ds/, ""); // "ErrorSummary"
      const kebab = baseSlug
        .replace(/([a-z])([A-Z])/g, "$1-$2")
        .toLowerCase(); // "error-summary"
      const flat = baseSlug.toLowerCase(); // "errorsummary" / "textfield"

      const possibleDocPaths = [
        join(docsDir, `ds-${kebab}.md`), // ds-error-summary.md, ds-button.md
        join(docsDir, `ds-${flat}.md`), // ds-textfield.md (no hyphen)
        join(docsDir, `ds-${kebab}`, "index.md"),
        join(docsDir, `${kebab}.md`), // legacy fallbacks
        join(docsDir, kebab, "index.md"),
      ];

      for (const docPath of possibleDocPaths) {
        if (existsSync(docPath)) {
          const docPage = parseDocPage(docPath, repoRoot);
          found.docPath = docPage.path;
          found.description =
            found.description || docPage.title || found.name;
          const examples = extractCodeExamples(docPage.content);
          if (examples.length > 0) {
            found.examples = examples;
          }
          break;
        }
      }

      const summary = formatComponentSummary(found);

      return {
        content: [{ type: "text" as const, text: summary }],
      };
    },
  );
}
