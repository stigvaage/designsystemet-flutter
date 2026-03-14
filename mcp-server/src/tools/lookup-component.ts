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
  server.tool(
    "lookup_component",
    "Look up a Designsystemet Flutter component by name. Returns properties, usage examples, and import statement.",
    { name: z.string().describe("Component name, e.g. 'DsButton' or 'button'") },
    async ({ name }) => {
      const components = parseAllComponents(repoRoot);

      // Load categories and assign them
      const categoriesPath = join(
        import.meta.dirname,
        "..",
        "data",
        "categories.json",
      );
      const categories: CategoryMap = JSON.parse(
        readFileSync(categoriesPath, "utf-8"),
      );

      for (const component of components) {
        for (const [cat, names] of Object.entries(categories)) {
          if (names.includes(component.name)) {
            component.category = cat;
            break;
          }
        }
      }

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

      // Load documentation page if it exists
      const docsDir = resolveComponentDocsPath(repoRoot);
      const componentSlug = found.name
        .replace(/^Ds/, "")
        .replace(/([a-z])([A-Z])/g, "$1-$2")
        .toLowerCase();

      const possibleDocPaths = [
        join(docsDir, componentSlug, "index.md"),
        join(docsDir, `${componentSlug}.md`),
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
