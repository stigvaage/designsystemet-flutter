import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { formatMigrationMapping } from "../utils/format.js";

interface PropertyMapping {
  materialProp: string;
  dsProp: string | null;
  transform: string | null;
}

interface MigrationMapping {
  materialWidget: string;
  dsComponent: string;
  notes: string;
  propertyMappings: PropertyMapping[];
  beforeCode: string;
  afterCode: string;
}

export function registerGetMigrationMapping(
  server: McpServer,
  repoRoot: string,
): void {
  server.tool(
    "get_migration_mapping",
    "Get the Designsystemet equivalent of a Material Flutter widget, with property mapping and code examples.",
    {
      widget: z
        .string()
        .describe("Material widget name, e.g. 'ElevatedButton', 'TextField'"),
    },
    async ({ widget }) => {
      const migrationsPath = join(
        import.meta.dirname,
        "..",
        "data",
        "migrations.json",
      );
      const migrations: MigrationMapping[] = JSON.parse(
        readFileSync(migrationsPath, "utf-8"),
      );

      const searchTerm = widget
        .trim()
        .replace(/^Material/i, "")
        .replace(/^Cupertino/i, "");
      const searchLower = searchTerm.toLowerCase();

      // Try exact match first
      let found = migrations.find(
        (m) => m.materialWidget.toLowerCase() === widget.trim().toLowerCase(),
      );

      // Try without Material/Cupertino prefix
      if (!found) {
        found = migrations.find(
          (m) => m.materialWidget.toLowerCase() === searchLower,
        );
      }

      // Try case-insensitive partial match. Collect ALL candidates so we do
      // not silently hide alternatives (e.g. "Button" matching several widgets).
      if (!found) {
        const partial = migrations.filter(
          (m) =>
            m.materialWidget.toLowerCase().includes(searchLower) ||
            searchLower.includes(m.materialWidget.toLowerCase()),
        );
        if (partial.length === 1) {
          found = partial[0];
        } else if (partial.length > 1) {
          const list = partial
            .map((m) => `  - ${m.materialWidget} → ${m.dsComponent}`)
            .join("\n");
          return {
            content: [
              {
                type: "text" as const,
                text: `Flere mulige treff for "${widget}":\n${list}\n\nKjør på nytt med et eksakt komponentnavn.`,
              },
            ],
          };
        }
      }

      if (!found) {
        const available = migrations
          .map((m) => `  - ${m.materialWidget} → ${m.dsComponent}`)
          .join("\n");

        return {
          content: [
            {
              type: "text" as const,
              text: `No migration mapping found for "${widget}".\n\nAvailable mappings:\n${available}`,
            },
          ],
        };
      }

      const formatted = formatMigrationMapping(found);

      return {
        content: [{ type: "text" as const, text: formatted }],
      };
    },
  );
}
