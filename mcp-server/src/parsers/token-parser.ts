import { readFileSync } from "node:fs";
import { join } from "node:path";
import { resolveThemePath, resolveUtilsPath } from "../utils/paths.js";

export interface DesignToken {
  name: string;
  category: string;
  value: string;
  context: string;
}

/**
 * Parse `final Color fieldName;` declarations from DsColorScale
 * and `static const` color names from DsColor sealed class.
 */
function parseColorTokens(repoRoot: string): DesignToken[] {
  const tokens: DesignToken[] = [];

  // Parse color scale fields from ds_color_scale.dart
  const scalePath = join(resolveThemePath(repoRoot), "ds_color_scale.dart");
  const scaleSource = readFileSync(scalePath, "utf-8");
  const fieldRe = /final\s+Color\s+(\w+)\s*;/g;
  let m: RegExpExecArray | null;

  while ((m = fieldRe.exec(scaleSource)) !== null) {
    tokens.push({
      name: m[1],
      category: "colors",
      value: "Color",
      context: `DsColorScale.${m[1]} — resolved per color type (accent, neutral, etc.)`,
    });
  }

  // Parse the 9 named color types from ds_enums.dart
  const enumPath = join(resolveUtilsPath(repoRoot), "ds_enums.dart");
  const enumSource = readFileSync(enumPath, "utf-8");
  const colorConstRe = /static\s+const\s+\w+\s*=\s*DsColor(\w+)\(\)/g;

  while ((m = colorConstRe.exec(enumSource)) !== null) {
    const name = m[1].charAt(0).toLowerCase() + m[1].slice(1);
    tokens.push({
      name,
      category: "colors",
      value: `DsColor.${name}`,
      context: `Named color type — use with DsColorScope or colorScheme.resolve()`,
    });
  }

  return tokens;
}

/**
 * Parse `final TextStyle fieldName;` declarations from DsTypography.
 */
function parseTypographyTokens(repoRoot: string): DesignToken[] {
  const tokens: DesignToken[] = [];
  const filePath = join(resolveThemePath(repoRoot), "ds_typography.dart");
  const source = readFileSync(filePath, "utf-8");
  const fieldRe = /final\s+TextStyle\s+(\w+)\s*;/g;
  let m: RegExpExecArray | null;

  while ((m = fieldRe.exec(source)) !== null) {
    const name = m[1];
    let context: string;

    if (name.startsWith("heading")) {
      context = "Heading style (weight 500, line-height 1.3)";
    } else if (name.startsWith("bodyShort")) {
      context = "Body short style (weight 400, line-height 1.3)";
    } else if (name.startsWith("bodyLong")) {
      context = "Body long style (weight 400, line-height 1.7)";
    } else if (name.startsWith("body")) {
      context = "Body default style (weight 400, line-height 1.5)";
    } else {
      context = "Typography token";
    }

    tokens.push({
      name,
      category: "typography",
      value: "TextStyle",
      context: `DsTypography.${name} — ${context}`,
    });
  }

  return tokens;
}

/**
 * Parse DsSizeTokens fields and static size modes (sm, md, lg).
 */
function parseSizeTokens(repoRoot: string): DesignToken[] {
  const tokens: DesignToken[] = [];
  const filePath = join(resolveThemePath(repoRoot), "ds_size_tokens.dart");
  const source = readFileSync(filePath, "utf-8");

  // Extract static size modes with their doc comments
  const modeCommentRe = /\/\/\/\s*(.+)\n\s*static\s+final\s+(\w+)/g;
  let m: RegExpExecArray | null;

  // Parse modes with their doc comments
  while ((m = modeCommentRe.exec(source)) !== null) {
    tokens.push({
      name: m[2],
      category: "sizes",
      value: m[1].trim(),
      context: `DsSizeTokens.${m[2]} — size mode preset`,
    });
  }

  // Parse all size step fields
  const fieldRe = /final\s+double\s+(size\d+|sizeUnit|base|step)\s*;/g;

  while ((m = fieldRe.exec(source)) !== null) {
    const name = m[1];
    let context: string;

    if (name === "base") {
      context = "Base font size for the size mode";
    } else if (name === "step") {
      context = "Step increment (default 4px)";
    } else if (name === "sizeUnit") {
      context = "Alias for step — base spacing unit";
    } else {
      const idx = name.replace("size", "");
      context = `step * ${idx} spacing value`;
    }

    tokens.push({
      name,
      category: "sizes",
      value: "double",
      context: `DsSizeTokens.${name} — ${context}`,
    });
  }

  return tokens;
}

/**
 * Parse DsBorderRadiusTokens fields.
 */
function parseBorderRadiusTokens(repoRoot: string): DesignToken[] {
  const tokens: DesignToken[] = [];
  const filePath = join(
    resolveThemePath(repoRoot),
    "ds_border_radius_tokens.dart",
  );
  const source = readFileSync(filePath, "utf-8");
  const fieldRe = /final\s+double\s+(\w+)\s*;/g;
  let m: RegExpExecArray | null;

  const descriptions: Record<string, string> = {
    sm: "base / 2",
    md: "base",
    lg: "base * 2",
    xl: "base * 3",
    defaultRadius: "alias for md (base)",
    full: "9999 (pill shape)",
  };

  while ((m = fieldRe.exec(source)) !== null) {
    const name = m[1];
    tokens.push({
      name,
      category: "border-radius",
      value: "double",
      context: `DsBorderRadiusTokens.${name} — ${descriptions[name] ?? "border radius value"}`,
    });
  }

  return tokens;
}

/**
 * Parse DsShadowTokens fields.
 */
function parseShadowTokens(repoRoot: string): DesignToken[] {
  const tokens: DesignToken[] = [];
  const filePath = join(resolveThemePath(repoRoot), "ds_shadow_tokens.dart");
  const source = readFileSync(filePath, "utf-8");
  const fieldRe = /final\s+List<BoxShadow>\s+(\w+)\s*;/g;
  let m: RegExpExecArray | null;

  const descriptions: Record<string, string> = {
    xs: "Extra-small shadow (subtle elevation)",
    sm: "Small shadow",
    md: "Medium shadow",
    lg: "Large shadow",
    xl: "Extra-large shadow (highest elevation)",
  };

  while ((m = fieldRe.exec(source)) !== null) {
    const name = m[1];
    tokens.push({
      name,
      category: "shadows",
      value: "List<BoxShadow>",
      context: `DsShadowTokens.${name} — ${descriptions[name] ?? "shadow preset"}`,
    });
  }

  return tokens;
}

/**
 * Parse `static const IconData fieldName` from DsIcons class.
 */
function parseIconTokens(repoRoot: string): DesignToken[] {
  const tokens: DesignToken[] = [];
  const filePath = join(resolveUtilsPath(repoRoot), "ds_icons.dart");
  const source = readFileSync(filePath, "utf-8");
  const fieldRe = /static\s+const\s+IconData\s+(\w+)\s*=\s*LucideIcons\.(\w+)\s*;/g;
  let m: RegExpExecArray | null;

  while ((m = fieldRe.exec(source)) !== null) {
    tokens.push({
      name: m[1],
      category: "icons",
      value: `LucideIcons.${m[2]}`,
      context: `DsIcons.${m[1]} — mapped to Lucide icon "${m[2]}"`,
    });
  }

  return tokens;
}

/**
 * Parse design tokens for a given category from the Dart source files.
 */
export function parseTokens(
  category: string,
  repoRoot: string,
): DesignToken[] {
  switch (category) {
    case "colors":
      return parseColorTokens(repoRoot);
    case "typography":
      return parseTypographyTokens(repoRoot);
    case "sizes":
      return parseSizeTokens(repoRoot);
    case "border-radius":
      return parseBorderRadiusTokens(repoRoot);
    case "shadows":
      return parseShadowTokens(repoRoot);
    case "icons":
      return parseIconTokens(repoRoot);
    default:
      return [];
  }
}
