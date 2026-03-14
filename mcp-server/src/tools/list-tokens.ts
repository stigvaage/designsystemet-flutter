import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { parseTokens } from "../parsers/token-parser.js";

export function registerListTokens(
  server: McpServer,
  repoRoot: string,
): void {
  server.tool(
    "list_tokens",
    "List design tokens by category (colors, typography, sizes, border-radius, shadows, icons).",
    {
      category: z
        .enum([
          "colors",
          "typography",
          "sizes",
          "border-radius",
          "shadows",
          "icons",
        ])
        .describe("Token category"),
    },
    async ({ category }) => {
      const tokens = parseTokens(category, repoRoot);

      if (tokens.length === 0) {
        return {
          content: [
            {
              type: "text" as const,
              text: `No tokens found for category "${category}".`,
            },
          ],
        };
      }

      const lines: string[] = [
        `# ${category} tokens`,
        "",
        `Found ${tokens.length} token(s).`,
        "",
        "| Name | Value | Context |",
        "|------|-------|---------|",
        ...tokens.map(
          (t) => `| ${t.name} | \`${t.value}\` | ${t.context} |`,
        ),
      ];

      return {
        content: [{ type: "text" as const, text: lines.join("\n") }],
      };
    },
  );
}
