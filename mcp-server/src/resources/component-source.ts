import { McpServer, ResourceTemplate } from "@modelcontextprotocol/sdk/server/mcp.js";
import { readFileSync, existsSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import {
  resolveComponentsPath,
  resolveTypographyPath,
} from "../utils/paths.js";

/**
 * Recursively find all .dart files under a directory.
 */
function findDartFiles(dir: string): string[] {
  const results: string[] = [];

  if (!existsSync(dir)) return results;

  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...findDartFiles(fullPath));
    } else if (entry.name.endsWith(".dart")) {
      results.push(fullPath);
    }
  }

  return results;
}

export function registerComponentResources(
  server: McpServer,
  repoRoot: string,
): void {
  const template = new ResourceTemplate("component:///{path}", {
    list: async () => {
      const componentsDir = resolveComponentsPath(repoRoot);
      const typographyDir = resolveTypographyPath(repoRoot);

      const dartFiles = [
        ...findDartFiles(componentsDir),
        ...findDartFiles(typographyDir),
      ];

      const resources = dartFiles.map((filePath) => {
        const relativePath = relative(repoRoot, filePath);
        return {
          uri: `component:///${relativePath}`,
          name: relativePath,
          mimeType: "text/x-dart",
        };
      });

      return { resources };
    },
  });

  server.resource(
    "component-source",
    template,
    { description: "Dart source files for Designsystemet Flutter components" },
    async (uri, variables) => {
      const filePath = join(repoRoot, variables.path as string);

      if (!existsSync(filePath)) {
        return {
          contents: [
            {
              uri: uri.href,
              mimeType: "text/x-dart",
              text: `// File not found: ${variables.path}`,
            },
          ],
        };
      }

      const content = readFileSync(filePath, "utf-8");

      return {
        contents: [
          {
            uri: uri.href,
            mimeType: "text/x-dart",
            text: content,
          },
        ],
      };
    },
  );
}
