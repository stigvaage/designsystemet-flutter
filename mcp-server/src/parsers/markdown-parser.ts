import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative, extname } from "node:path";

export interface DocumentationPage {
  title: string;
  path: string;
  content: string;
  sections: string[];
  keywords: string[];
}

export interface CodeExample {
  language: string;
  code: string;
}

/**
 * Read a markdown file and extract structured documentation information.
 */
export function parseDocPage(
  filePath: string,
  repoRoot: string,
): DocumentationPage {
  const content = readFileSync(filePath, "utf-8");
  const relativePath = relative(repoRoot, filePath);

  // Extract first # heading as title
  const titleMatch = content.match(/^# (.+)$/m);
  const title = titleMatch ? titleMatch[1].trim() : "";

  // Extract all heading texts (lines starting with #, ##, ###)
  const sections: string[] = [];
  for (const match of content.matchAll(/^#{1,3} (.+)$/gm)) {
    sections.push(match[1].trim());
  }

  // Build keywords from title + sections + component names found in content
  const keywordSource = [title, ...sections].join(" ");
  const wordSet = new Set<string>();

  // Extract meaningful words (3+ chars, lowercased) from title and sections
  for (const word of keywordSource.split(/[\s,;:.()\[\]{}"'`|/\\]+/)) {
    const cleaned = word.replace(/[^a-zA-Z\u00C0-\u024F]/g, "");
    if (cleaned.length >= 3) {
      wordSet.add(cleaned.toLowerCase());
    }
  }

  // Extract component names matching /Ds[A-Z]\w+/
  for (const match of content.matchAll(/Ds[A-Z]\w+/g)) {
    wordSet.add(match[0]);
  }

  return {
    title,
    path: relativePath,
    content,
    sections,
    keywords: [...wordSet],
  };
}

/**
 * Extract all fenced Dart code blocks from markdown content.
 * Returns the code inside each ```dart ... ``` block.
 */
export function extractCodeExamples(content: string): string[] {
  const examples: string[] = [];
  const pattern = /```dart\s*\n([\s\S]*?)```/g;

  for (const match of content.matchAll(pattern)) {
    const code = match[1].trimEnd();
    if (code.length > 0) {
      examples.push(code);
    }
  }

  return examples;
}

/**
 * Recursively find all .md files under a directory.
 */
function findMarkdownFiles(dir: string): string[] {
  const results: string[] = [];

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

/**
 * Recursively find all .md files under the docs directory,
 * parse each, and return an array of DocumentationPage objects.
 */
export function parseAllDocs(
  docsDir: string,
  repoRoot: string,
): DocumentationPage[] {
  const files = findMarkdownFiles(docsDir);
  return files.map((filePath) => parseDocPage(filePath, repoRoot));
}

/**
 * Parse markdown tables with Norwegian property columns:
 * "Egenskap | Type | Standard | Beskrivelse"
 *
 * Returns parsed rows with name, type, default, and description.
 */
export function extractPropertyTable(
  content: string,
): Array<{ name: string; type: string; default: string; description: string }> {
  const results: Array<{
    name: string;
    type: string;
    default: string;
    description: string;
  }> = [];

  const lines = content.split("\n");

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();

    // Look for a header row containing the Norwegian column names
    if (
      !line.startsWith("|") ||
      !line.includes("Egenskap") ||
      !line.includes("Type") ||
      !line.includes("Standard") ||
      !line.includes("Beskrivelse")
    ) {
      continue;
    }

    // Parse header to find column indices
    const headerCells = line
      .split("|")
      .map((c) => c.trim())
      .filter((c) => c.length > 0);

    const egenskapIdx = headerCells.findIndex((c) => c === "Egenskap");
    const typeIdx = headerCells.findIndex((c) => c === "Type");
    const standardIdx = headerCells.findIndex((c) => c === "Standard");
    const beskrivelseIdx = headerCells.findIndex((c) => c === "Beskrivelse");

    if (
      egenskapIdx === -1 ||
      typeIdx === -1 ||
      standardIdx === -1 ||
      beskrivelseIdx === -1
    ) {
      continue;
    }

    // Skip the separator row (e.g. |---|---|---|---|)
    let j = i + 1;
    if (j < lines.length && /^\s*\|[\s\-:|]+\|\s*$/.test(lines[j])) {
      j++;
    }

    // Parse data rows
    for (; j < lines.length; j++) {
      const row = lines[j].trim();
      if (!row.startsWith("|")) break;

      const cells = row
        .split("|")
        .map((c) => c.trim())
        .filter((c) => c.length > 0);

      if (cells.length < headerCells.length) break;

      results.push({
        name: cells[egenskapIdx] ?? "",
        type: cells[typeIdx] ?? "",
        default: cells[standardIdx] ?? "",
        description: cells[beskrivelseIdx] ?? "",
      });
    }
  }

  return results;
}
