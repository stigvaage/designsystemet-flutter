import { resolve, join } from "node:path";
import { existsSync } from "node:fs";

export function resolveRepoRoot(): string {
  if (process.env.REPO_ROOT) {
    return resolve(process.env.REPO_ROOT);
  }
  // Walk up from this file's directory looking for pubspec.yaml
  let dir = import.meta.dirname;
  for (let i = 0; i < 6; i++) {
    const candidate = resolve(dir, "..");
    if (existsSync(join(candidate, "pubspec.yaml"))) {
      return candidate;
    }
    dir = candidate;
  }
  throw new Error(
    "Cannot resolve repo root. Set REPO_ROOT environment variable or run from the mcp-server/ directory inside the repository.",
  );
}

export function resolveLibPath(repoRoot: string): string {
  return join(repoRoot, "lib");
}

export function resolveComponentsPath(repoRoot: string): string {
  return join(repoRoot, "lib", "src", "components");
}

export function resolveTypographyPath(repoRoot: string): string {
  return join(repoRoot, "lib", "src", "typography");
}

export function resolveThemePath(repoRoot: string): string {
  return join(repoRoot, "lib", "src", "theme");
}

export function resolveUtilsPath(repoRoot: string): string {
  return join(repoRoot, "lib", "src", "utils");
}

export function resolveDocsPath(repoRoot: string): string {
  return join(repoRoot, "site", "nb");
}

export function resolveComponentDocsPath(repoRoot: string): string {
  return join(repoRoot, "site", "nb", "komponenter");
}
