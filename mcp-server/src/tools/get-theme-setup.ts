import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

export function registerGetThemeSetup(
  server: McpServer,
  _repoRoot: string,
): void {
  server.tool(
    "get_theme_setup",
    "Get step-by-step instructions for setting up the Designsystemet theme in a Flutter app.",
    {},
    async () => {
      const mdPath = resolve(
        import.meta.dirname,
        "..",
        "data",
        "theme-setup.md",
      );
      const content = readFileSync(mdPath, "utf-8");

      return {
        content: [{ type: "text" as const, text: content }],
      };
    },
  );
}
