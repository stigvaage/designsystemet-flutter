import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { readFileSync } from "node:fs";
import { join } from "node:path";

interface CategoryMap {
  [category: string]: string[];
}

const VALID_CATEGORIES = [
  "form",
  "navigation",
  "layout",
  "content",
  "interactive",
  "typography",
];

export function registerListComponents(
  server: McpServer,
  repoRoot: string,
): void {
  server.tool(
    "list_components",
    "List all available Designsystemet Flutter components, optionally filtered by category.",
    {
      category: z
        .string()
        .optional()
        .describe(
          "Optional filter: form, navigation, layout, content, interactive, typography",
        ),
    },
    async ({ category }) => {
      const categoriesPath = join(
        import.meta.dirname,
        "..",
        "data",
        "categories.json",
      );
      const categories: CategoryMap = JSON.parse(
        readFileSync(categoriesPath, "utf-8"),
      );

      if (category) {
        const categoryLower = category.toLowerCase();

        if (!VALID_CATEGORIES.includes(categoryLower)) {
          return {
            content: [
              {
                type: "text" as const,
                text: `Unknown category "${category}". Valid categories: ${VALID_CATEGORIES.join(", ")}`,
              },
            ],
          };
        }

        const components = categories[categoryLower];
        if (!components || components.length === 0) {
          return {
            content: [
              {
                type: "text" as const,
                text: `No components found in category "${categoryLower}".`,
              },
            ],
          };
        }

        const lines = [
          `# ${categoryLower.charAt(0).toUpperCase() + categoryLower.slice(1)} Components`,
          "",
          ...components.map((name) => `- ${name}`),
        ];

        return {
          content: [{ type: "text" as const, text: lines.join("\n") }],
        };
      }

      // Return all groups
      const lines: string[] = [
        "# Designsystemet Flutter Components",
        "",
      ];

      for (const cat of VALID_CATEGORIES) {
        const components = categories[cat];
        if (!components || components.length === 0) continue;

        lines.push(
          `## ${cat.charAt(0).toUpperCase() + cat.slice(1)}`,
          "",
          ...components.map((name) => `- ${name}`),
          "",
        );
      }

      return {
        content: [{ type: "text" as const, text: lines.join("\n") }],
      };
    },
  );
}
