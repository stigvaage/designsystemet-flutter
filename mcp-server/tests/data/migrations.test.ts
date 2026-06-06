import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dataDir = path.resolve(__dirname, "../../src/data");

interface Mapping {
  materialWidget: string;
  dsComponent: string;
  notes: string;
  propertyMappings: unknown[];
  beforeCode: string;
  afterCode: string;
}

describe("migrations coverage", () => {
  const migrations: Mapping[] = JSON.parse(
    readFileSync(path.join(dataDir, "migrations.json"), "utf-8"),
  );
  const categories: Record<string, string[]> = JSON.parse(
    readFileSync(path.join(dataDir, "categories.json"), "utf-8"),
  );

  // All public Ds components, excluding Card sub-components (covered by DsCard).
  const cardSubs = new Set(["DsCardBlock", "DsCardHeader", "DsCardFooter"]);
  const allComponents = [
    ...new Set(Object.values(categories).flat()),
  ].filter((c) => !cardSubs.has(c));

  const covered = new Set(migrations.map((m) => m.dsComponent));

  it("covers every one of the 40 Ds components", () => {
    const missing = allComponents.filter((c) => !covered.has(c));
    expect(
      missing,
      `Missing migration mappings for: ${missing.join(", ")}`,
    ).toEqual([]);
    expect(allComponents.length).toBe(40);
  });

  it("every mapping has the required shape", () => {
    for (const m of migrations) {
      expect(m.materialWidget.length).toBeGreaterThan(0);
      expect(m.dsComponent).toMatch(/^Ds/);
      expect(Array.isArray(m.propertyMappings)).toBe(true);
      expect(typeof m.afterCode).toBe("string");
    }
  });
});
