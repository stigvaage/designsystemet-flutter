import type { Property, Component } from "../parsers/dart-parser.js";

export function errorResult(tool: string, error: unknown): { content: Array<{ type: "text"; text: string }> } {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`[${tool}] Error: ${message}`);
  return {
    content: [{ type: "text" as const, text: `Error in ${tool}: ${message}` }],
  };
}

export function formatPropertyTable(properties: Property[]): string {
  if (properties.length === 0) return "No properties found.";

  const header = "| Property | Type | Required | Default |";
  const separator = "|----------|------|----------|---------|";
  const rows = properties.map(
    (p) =>
      `| ${p.name} | \`${p.type}\` | ${p.required ? "yes" : "no"} | ${p.defaultValue ?? "—"} |`,
  );
  return [header, separator, ...rows].join("\n");
}

export function formatCodeBlock(code: string, language = "dart"): string {
  return `\`\`\`${language}\n${code}\n\`\`\``;
}

export function formatComponentSummary(component: Component): string {
  const lines: string[] = [
    `# ${component.name}`,
    "",
    component.description || "",
    "",
    `**Category**: ${component.category}`,
    `**Import**: \`${component.importPath}\``,
    `**Source**: \`${component.sourcePath}\``,
    "",
    "## Properties",
    "",
    formatPropertyTable(component.properties),
  ];

  if (component.examples.length > 0) {
    lines.push("", "## Examples", "");
    for (const ex of component.examples) {
      lines.push(formatCodeBlock(ex));
    }
  }

  return lines.join("\n");
}

export function formatMigrationMapping(mapping: {
  materialWidget: string;
  dsComponent: string;
  notes: string;
  propertyMappings: Array<{
    materialProp: string;
    dsProp: string | null;
    transform: string | null;
  }>;
  beforeCode: string;
  afterCode: string;
}): string {
  const lines: string[] = [
    `# Migrate ${mapping.materialWidget} → ${mapping.dsComponent}`,
    "",
    mapping.notes,
    "",
    "## Property Mapping",
    "",
    "| Material | Designsystemet | Notes |",
    "|----------|---------------|-------|",
    ...mapping.propertyMappings.map(
      (pm) =>
        `| \`${pm.materialProp}\` | ${pm.dsProp ? `\`${pm.dsProp}\`` : "—"} | ${pm.transform ?? "—"} |`,
    ),
    "",
    "## Before (Material)",
    "",
    formatCodeBlock(mapping.beforeCode),
    "",
    "## After (Designsystemet)",
    "",
    formatCodeBlock(mapping.afterCode),
  ];
  return lines.join("\n");
}
