import MiniSearch from "minisearch";
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative, extname } from "node:path";

export interface SearchResult {
  title: string;
  path: string;
  excerpt: string;
  score: number;
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
 * Extract the first # heading from markdown content as the title.
 */
function extractTitle(content: string): string {
  const match = content.match(/^# (.+)$/m);
  return match ? match[1].trim() : "";
}

/**
 * Extract all heading texts from markdown content.
 */
function extractSections(content: string): string[] {
  const sections: string[] = [];
  for (const match of content.matchAll(/^#{1,3} (.+)$/gm)) {
    sections.push(match[1].trim());
  }
  return sections;
}

/**
 * Build a full-text search index from all .md files in the docs directory.
 */
export function buildIndex(docsDir: string, repoRoot: string): MiniSearch {
  const index = new MiniSearch<{
    id: string;
    title: string;
    content: string;
    sections: string;
    path: string;
  }>({
    fields: ["title", "content", "sections"],
    storeFields: ["title", "path"],
    searchOptions: {
      boost: { title: 3, sections: 2 },
      fuzzy: 0.2,
      prefix: true,
    },
  });

  const files = findMarkdownFiles(docsDir);

  const documents = files.map((filePath) => {
    const content = readFileSync(filePath, "utf-8");
    const relativePath = relative(repoRoot, filePath);
    const title = extractTitle(content);
    const sections = extractSections(content);

    return {
      id: relativePath,
      title,
      content,
      sections: sections.join(" "),
      path: relativePath,
    };
  });

  index.addAll(documents);

  return index;
}

/**
 * Search the index and return the top 10 results with excerpts.
 */
export function searchDocs(
  index: MiniSearch,
  query: string,
  repoRoot: string,
): SearchResult[] {
  const results = index.search(query).slice(0, 10);

  return results.map((result) => {
    // Build excerpt from matched terms context
    const storedTitle = (result as Record<string, unknown>).title as string;
    const storedPath = (result as Record<string, unknown>).path as string;

    // Try to extract an excerpt around the first matching term
    let excerpt = "";
    if (result.terms.length > 0) {
      // Re-read the file to find context around the match
      try {
        const content = readFileSync(
          join(repoRoot, storedPath),
          "utf-8",
        );
        const term = result.terms[0];
        const termIdx = content.toLowerCase().indexOf(term.toLowerCase());
        if (termIdx >= 0) {
          const start = Math.max(0, termIdx - 50);
          const end = Math.min(content.length, termIdx + 150);
          excerpt = content.slice(start, end).replace(/\n/g, " ").trim();
          if (start > 0) excerpt = "..." + excerpt;
          if (end < content.length) excerpt = excerpt + "...";
        } else {
          excerpt = content.slice(0, 200).replace(/\n/g, " ").trim();
          if (content.length > 200) excerpt += "...";
        }
      } catch {
        excerpt = storedTitle || "(no excerpt available)";
      }
    }

    return {
      title: storedTitle || "(untitled)",
      path: storedPath,
      excerpt,
      score: result.score,
    };
  });
}
