import fs from "node:fs";
import path from "node:path";

export interface Property {
  name: string;
  type: string;
  required: boolean;
  defaultValue: string | null;
  isNullable: boolean;
  description: string | null;
}

export interface Component {
  name: string;
  category: string;
  importPath: string;
  sourcePath: string;
  properties: Property[];
  description: string;
  examples: string[];
  docPath: string | null;
}

/**
 * Parse constructor parameters from the constructor block.
 * Returns an array of { name, required, defaultValue } objects.
 */
function parseConstructorParams(
  source: string,
  className: string
): { name: string; required: boolean; defaultValue: string | null }[] {
  // Match the constructor block: const ClassName({...})
  const constructorRe = new RegExp(
    `const\\s+${className}\\s*\\(\\s*\\{([^}]*)\\}`,
    "s"
  );
  const match = constructorRe.exec(source);
  if (!match) return [];

  const body = match[1];
  const params: { name: string; required: boolean; defaultValue: string | null }[] = [];
  const lines = body.split(",");

  const paramRe = /^\s*(required\s+)?(?:super|this)\.(\w+)(?:\s*=\s*(.+))?\s*$/;

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) continue;

    const m = paramRe.exec(trimmed);
    if (!m) continue;

    const name = m[2];
    // Skip super.key parameters
    if (name === "key") continue;

    params.push({
      name,
      required: m[1] !== undefined,
      defaultValue: m[3]?.trim() ?? null,
    });
  }

  return params;
}

/**
 * Parse field type declarations from `final Type name;` lines.
 * Returns a map from field name to type string.
 */
function parseFieldTypes(source: string): Map<string, string> {
  const fieldRe = /final\s+((?:[\w.]+(?:<[^;]+?>)?)\??)\s+(\w+)\s*;/g;
  const fields = new Map<string, string>();
  let m: RegExpExecArray | null;

  while ((m = fieldRe.exec(source)) !== null) {
    fields.set(m[2], m[1]);
  }

  return fields;
}

/**
 * Extract the primary public widget class name from a Dart source file.
 * Looks for `class DsXxx extends StatelessWidget` or `StatefulWidget`.
 */
function extractClassName(source: string): string | null {
  const classRe = /class\s+(Ds\w+)\s+extends\s+(?:Stateless|Stateful)Widget/;
  const m = classRe.exec(source);
  return m ? m[1] : null;
}

/**
 * Parse a single Dart file into a Component descriptor.
 */
export function parseComponent(filePath: string, repoRoot: string): Component {
  const source = fs.readFileSync(filePath, "utf-8");
  const className = extractClassName(source);

  if (!className) {
    throw new Error(`No public widget class found in ${filePath}`);
  }

  // Pass 1: constructor parameters
  const ctorParams = parseConstructorParams(source, className);

  // Pass 2: field types
  const fieldTypes = parseFieldTypes(source);

  // Pass 3: correlate
  const properties: Property[] = ctorParams.map((param) => {
    const type = fieldTypes.get(param.name) ?? "dynamic";
    return {
      name: param.name,
      type,
      required: param.required,
      defaultValue: param.defaultValue,
      isNullable: type.endsWith("?"),
      description: null,
    };
  });

  // Determine import path based on directory
  const relativePath = path.relative(repoRoot, filePath);
  const isTypography = relativePath.includes(
    path.join("lib", "src", "typography")
  );
  const importPath = isTypography
    ? "package:designsystemet_flutter/typography.dart"
    : "package:designsystemet_flutter/components.dart";

  return {
    name: className,
    category: "",
    importPath,
    sourcePath: relativePath,
    properties,
    description: "",
    examples: [],
    docPath: null,
  };
}

/**
 * Recursively find all .dart files under a directory.
 */
function findDartFiles(dir: string): string[] {
  const results: string[] = [];

  if (!fs.existsSync(dir)) return results;

  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...findDartFiles(fullPath));
    } else if (entry.name.endsWith(".dart")) {
      results.push(fullPath);
    }
  }

  return results;
}

/**
 * Parse all component and typography Dart files under the repo root.
 * Skips files that don't contain a public widget class (no `class Ds` prefix).
 */
export function parseAllComponents(repoRoot: string): Component[] {
  const componentsDir = path.join(repoRoot, "lib", "src", "components");
  const typographyDir = path.join(repoRoot, "lib", "src", "typography");

  const dartFiles = [
    ...findDartFiles(componentsDir),
    ...findDartFiles(typographyDir),
  ];

  const components: Component[] = [];

  for (const filePath of dartFiles) {
    const source = fs.readFileSync(filePath, "utf-8");
    // Skip files without a public Ds* widget class
    if (!/class\s+Ds\w+\s+extends\s+(?:Stateless|Stateful)Widget/.test(source)) {
      continue;
    }

    try {
      components.push(parseComponent(filePath, repoRoot));
    } catch {
      // Skip files that fail to parse (e.g. helper classes without constructors)
    }
  }

  return components;
}
