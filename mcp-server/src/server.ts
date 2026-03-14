import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { resolveRepoRoot } from "./utils/paths.js";
import { registerLookupComponent } from "./tools/lookup-component.js";
import { registerListComponents } from "./tools/list-components.js";
import { registerGetMigrationMapping } from "./tools/get-migration-mapping.js";
import { registerGetThemeSetup } from "./tools/get-theme-setup.js";
import { registerListTokens } from "./tools/list-tokens.js";
import { registerSearchDocs } from "./tools/search-docs.js";
import { registerComponentResources } from "./resources/component-source.js";
import { registerDocResources } from "./resources/documentation.js";

export async function createServer(): Promise<McpServer> {
  const pkgPath = resolve(import.meta.dirname, "..", "package.json");
  const pkg = JSON.parse(readFileSync(pkgPath, "utf-8"));

  const server = new McpServer({
    name: "komponentbibliotek",
    version: pkg.version,
  });

  const repoRoot = resolveRepoRoot();

  // US1: Component Lookup
  registerLookupComponent(server, repoRoot);
  registerListComponents(server, repoRoot);

  // US1: Component Source Resources
  registerComponentResources(server, repoRoot);

  // US2: Migration Mapping
  registerGetMigrationMapping(server, repoRoot);

  // US3: Theme & Tokens
  registerGetThemeSetup(server, repoRoot);
  registerListTokens(server, repoRoot);

  // US4: Documentation Search & Resources
  registerSearchDocs(server, repoRoot);
  registerDocResources(server, repoRoot);

  return server;
}
