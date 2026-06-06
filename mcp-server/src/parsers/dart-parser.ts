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
 * Locate the named-parameter `{...}` block of the constructor `const ClassName(`
 * using a depth counter so embedded braces (e.g. a `const <int>{}` default or a
 * nested record/map literal) do not terminate the block prematurely. Returns the
 * block body (between the outermost `{` and its matching `}`) or null.
 */
function extractConstructorBody(
  source: string,
  className: string,
): string | null {
  const headRe = new RegExp(`const\\s+${className}\\s*\\(`);
  const head = headRe.exec(source);
  if (!head) return null;

  // Find the opening brace of the named-parameter block after the `(`.
  const braceStart = source.indexOf("{", head.index + head[0].length);
  if (braceStart === -1) return null;

  let depth = 0;
  for (let i = braceStart; i < source.length; i++) {
    const ch = source[i];
    if (ch === "{") {
      depth++;
    } else if (ch === "}") {
      depth--;
      if (depth === 0) {
        return source.slice(braceStart + 1, i);
      }
    }
  }
  return null;
}

/**
 * Split a constructor parameter block on TOP-LEVEL commas only — commas where
 * paren, brace and angle-bracket depth are all zero — so default values that
 * themselves contain commas (e.g. `EdgeInsets.symmetric(horizontal: 8, vertical: 4)`)
 * are kept intact.
 */
function splitTopLevelParams(body: string): string[] {
  const params: string[] = [];
  let depthParen = 0;
  let depthBrace = 0;
  let depthAngle = 0;
  let current = "";

  for (const ch of body) {
    switch (ch) {
      case "(":
        depthParen++;
        break;
      case ")":
        depthParen--;
        break;
      case "{":
        depthBrace++;
        break;
      case "}":
        depthBrace--;
        break;
      case "<":
        depthAngle++;
        break;
      case ">":
        depthAngle--;
        break;
    }

    if (
      ch === "," &&
      depthParen === 0 &&
      depthBrace === 0 &&
      depthAngle === 0
    ) {
      params.push(current);
      current = "";
    } else {
      current += ch;
    }
  }

  if (current.trim().length > 0) params.push(current);
  return params;
}

/**
 * Parse constructor parameters from the constructor block.
 * Returns an array of { name, required, defaultValue } objects.
 */
function parseConstructorParams(
  source: string,
  className: string
): { name: string; required: boolean; defaultValue: string | null }[] {
  const body = extractConstructorBody(source, className);
  if (body === null) return [];

  const params: { name: string; required: boolean; defaultValue: string | null }[] = [];
  const segments = splitTopLevelParams(body);

  const paramRe = /^\s*(required\s+)?(?:super|this)\.(\w+)(?:\s*=\s*([\s\S]+))?\s*$/;

  for (const segment of segments) {
    const trimmed = segment.trim();
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
 *
 * The type capture is deliberately broad (everything between `final ` and the
 * trailing `<name>;`) so it also matches inline function types such as
 * `void Function(int index)?` and qualified/nested generic types. The capture
 * is single-line by default, so it never crosses a statement boundary. The
 * first declaration for a given name wins, so a same-named private helper-class
 * field cannot clobber the public widget's field.
 */
function parseFieldTypes(source: string): Map<string, string> {
  const fieldRe = /\bfinal\s+(.+?)\s+(\w+)\s*;/g;
  const fields = new Map<string, string>();
  let m: RegExpExecArray | null;

  while ((m = fieldRe.exec(source)) !== null) {
    const type = m[1].trim();
    // Skip initialized/late-with-default fields that aren't a plain type decl.
    if (type.includes("=")) continue;
    if (!fields.has(m[2])) fields.set(m[2], type);
  }

  return fields;
}

/**
 * Extract the dartdoc comment that immediately precedes each `final Type name;`
 * field declaration. Returns a map from field name to its (joined) doc text.
 */
function parseFieldDocs(source: string): Map<string, string> {
  const lines = source.split("\n");
  const docs = new Map<string, string>();
  const fieldRe = /^\s*final\s+[\w.<>?, ]+\s+(\w+)\s*;/;

  for (let i = 0; i < lines.length; i++) {
    const m = fieldRe.exec(lines[i]);
    if (!m) continue;

    const doc: string[] = [];
    for (let j = i - 1; j >= 0; j--) {
      const trimmed = lines[j].trim();
      if (trimmed.startsWith("///")) {
        doc.unshift(trimmed.replace(/^\/\/\/\s?/, ""));
      } else {
        break; // dartdoc must be contiguous and directly above the field
      }
    }

    if (doc.length) docs.set(m[1], doc.join(" ").trim());
  }

  return docs;
}

/**
 * Extract the primary public widget class name from a Dart source file.
 * Looks for `class DsXxx extends StatelessWidget` or `StatefulWidget`.
 */
function extractClassName(source: string): string | null {
  const classRe = /class\s+(Ds\w+)(?:<[^>]+>)?\s+extends\s+(?:Stateless|Stateful)Widget/;
  const m = classRe.exec(source);
  return m ? m[1] : null;
}

/**
 * Extract the contiguous `///` dartdoc block directly above the public widget
 * class declaration and return it as the component description. Walks upward
 * from the `class DsX ... extends Stateless/StatefulWidget` line, collecting
 * doc lines (skipping any annotations like `@immutable`) until a non-doc,
 * non-annotation line is reached.
 */
function extractClassDoc(source: string, className: string): string {
  const lines = source.split("\n");
  const re = new RegExp(
    `^\\s*class\\s+${className}(?:<[^>]+>)?\\s+extends\\s+(?:Stateless|Stateful)Widget`,
  );

  for (let i = 0; i < lines.length; i++) {
    if (!re.test(lines[i])) continue;

    const doc: string[] = [];
    for (let j = i - 1; j >= 0; j--) {
      const t = lines[j].trim();
      if (t.startsWith("///")) {
        doc.unshift(t.replace(/^\/\/\/\s?/, ""));
      } else if (t.startsWith("@")) {
        // Skip annotations between the doc block and the class declaration.
        continue;
      } else {
        break;
      }
    }
    return doc.join("\n").trim();
  }

  return "";
}

/**
 * Parse a single Dart file into a Component descriptor.
 *
 * `source` may be passed in to reuse a file already read by the caller (e.g.
 * parseAllComponents' skip-filter), avoiding a redundant second read.
 */
export function parseComponent(
  filePath: string,
  repoRoot: string,
  source?: string,
): Component {
  source ??= fs.readFileSync(filePath, "utf-8");
  const className = extractClassName(source);

  if (!className) {
    throw new Error(`No public widget class found in ${filePath}`);
  }

  // Pass 1: constructor parameters
  const ctorParams = parseConstructorParams(source, className);

  // Pass 2: field types
  const fieldTypes = parseFieldTypes(source);

  // Pass 3: dartdoc descriptions
  const fieldDocs = parseFieldDocs(source);

  // Pass 4: correlate
  const properties: Property[] = ctorParams.map((param) => {
    const type = fieldTypes.get(param.name) ?? "dynamic";
    return {
      name: param.name,
      type,
      required: param.required,
      defaultValue: param.defaultValue,
      isNullable: type.endsWith("?"),
      description: fieldDocs.get(param.name) ?? null,
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
    description: extractClassDoc(source, className),
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
    if (!/class\s+Ds\w+(?:<[^>]+>)?\s+extends\s+(?:Stateless|Stateful)Widget/.test(source)) {
      continue;
    }

    try {
      // Reuse the source already read for the skip-filter above.
      components.push(parseComponent(filePath, repoRoot, source));
    } catch {
      // Skip files that fail to parse (e.g. helper classes without constructors)
    }
  }

  return components;
}
