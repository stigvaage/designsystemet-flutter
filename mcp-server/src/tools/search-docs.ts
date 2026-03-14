import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { buildIndex, searchDocs } from "../search/doc-index.js";
import { resolveDocsPath } from "../utils/paths.js";

export function registerSearchDocs(
  server: McpServer,
  repoRoot: string,
): void {
  // Build the index once at registration time
  const docsDir = resolveDocsPath(repoRoot);
  const index = buildIndex(docsDir, repoRoot);

  server.tool(
    "search_docs",
    "Search across all Designsystemet documentation and return relevant excerpts.",
    {
      query: z.string().describe("Search query"),
    },
    async ({ query }) => {
      const results = searchDocs(index, query, repoRoot);

      if (results.length === 0) {
        return {
          content: [
            {
              type: "text" as const,
              text: `No results found for "${query}".`,
            },
          ],
        };
      }

      const lines: string[] = [
        `# Search results for "${query}"`,
        "",
        `Found ${results.length} result(s).`,
        "",
      ];

      for (const result of results) {
        lines.push(
          `## ${result.title}`,
          `**Path**: \`${result.path}\`  `,
          `**Score**: ${result.score.toFixed(2)}`,
          "",
          `> ${result.excerpt}`,
          "",
        );
      }

      return {
        content: [{ type: "text" as const, text: lines.join("\n") }],
      };
    },
  );
}
