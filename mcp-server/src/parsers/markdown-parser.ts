import { readFileSync } from "node:fs";
import { relative } from "node:path";

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
