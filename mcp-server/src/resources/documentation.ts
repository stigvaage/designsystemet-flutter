import {
  McpServer,
  ResourceTemplate,
} from "@modelcontextprotocol/sdk/server/mcp.js";
import {
  readFileSync,
  readdirSync,
  statSync,
  existsSync,
} from "node:fs";
import { join, relative, extname } from "node:path";
import { resolveDocsPath } from "../utils/paths.js";

/**
 * Recursively find all .md files under a directory.
 */
function findMarkdownFiles(dir: string): string[] {
  const results: string[] = [];

  if (!existsSync(dir)) return results;

  let entries: string[];
  try {
    entries = readdirSync(dir);
  } catch {
    return results;
  }

  for (const entry of entries) {
    const fullPath = join(dir, entry);
    let stat;
    try {
      stat = statSync(fullPath);
    } catch {
      continue;
    }

    if (stat.isDirectory()) {
      results.push(...findMarkdownFiles(fullPath));
    } else if (stat.isFile() && extname(entry) === ".md") {
      results.push(fullPath);
    }
  }

  return results;
}

export function registerDocResources(
  server: McpServer,
  repoRoot: string,
): void {
  const docsDir = resolveDocsPath(repoRoot);

  // Register a template-based resource for individual doc files
  server.resource(
    "documentation",
    new ResourceTemplate("docs:///{path}", { list: undefined }),
    {
      description:
        "Designsystemet documentation files in Norwegian (markdown)",
      mimeType: "text/markdown",
    },
    async (uri, variables) => {
      const docPath = typeof variables.path === "string"
        ? variables.path
        : Array.isArray(variables.path)
          ? variables.path.join("/")
          : uri.pathname.replace(/^\/+/, "");

      // Resolve to an absolute path within the docs directory
      let filePath = join(docsDir, docPath);

      // If the path doesn't end in .md, try appending it
      if (!filePath.endsWith(".md")) {
        filePath += ".md";
      }

      if (!existsSync(filePath)) {
        throw new Error(`Documentation file not found: ${docPath}`);
      }

      const content = readFileSync(filePath, "utf-8");

      return {
        contents: [
          {
            uri: uri.href,
            mimeType: "text/markdown" as const,
            text: content,
          },
        ],
      };
    },
  );

  // Register a static resource for the documentation index
  server.resource(
    "documentation-index",
    "docs:///index",
    {
      description: "Index of all available documentation files",
      mimeType: "text/markdown",
    },
    async (uri) => {
      const files = findMarkdownFiles(docsDir);
      const lines: string[] = [
        "# Documentation Index",
        "",
        `Found ${files.length} documentation file(s).`,
        "",
      ];

      for (const file of files) {
        const relativePath = relative(docsDir, file);
        const content = readFileSync(file, "utf-8");
        const titleMatch = content.match(/^# (.+)$/m);
        const title = titleMatch ? titleMatch[1].trim() : relativePath;
        lines.push(`- [${title}](docs:///${relativePath})`);
      }

      return {
        contents: [
          {
            uri: uri.href,
            mimeType: "text/markdown" as const,
            text: lines.join("\n"),
          },
        ],
      };
    },
  );
}
