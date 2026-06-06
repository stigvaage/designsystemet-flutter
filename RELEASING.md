# Slippe en ny versjon

Denne guiden beskriver hvordan du gir ut en ny versjon av begge pakkene i dette
repoet:

- **Flutter-biblioteket** `designsystemet_flutter` → publiseres til
  [pub.dev](https://pub.dev/packages/designsystemet_flutter)
- **MCP-serveren** `@stigvaage/designsystemet-flutter-mcp` → publiseres til
  GitHub Packages (npm)

Begge pakkene slippes samtidig fra én enkelt GitHub Release, og versjonsnumrene
holdes synkronisert.

## Engangsoppsett: pålitelig publisering (trusted publishing) på pub.dev

Dette må gjøres **én gang** av en bruker med opplaster-rettigheter (uploader) på
pakken. Etterpå publiseres alle nye versjoner automatisk via OIDC — uten
API-token eller hemmeligheter i repoet.

1. Logg inn på [pub.dev](https://pub.dev) og åpne pakken
   `designsystemet_flutter`.
2. Gå til **Admin** → **Automated publishing**.
3. Aktiver **Enable publishing from GitHub Actions**.
4. Sett **Repository** til `stigvaage/designsystemet-flutter`.
5. Sett **Tag pattern** til `v{{version}}` (eller `v*`).

Workflowen [`publish-pub.yml`](.github/workflows/publish-pub.yml) har
`permissions: id-token: write`, slik at `dart pub publish` automatisk plukker opp
OIDC-tokenet når pakken er konfigurert for automatisert publisering.

> **Status:** Inntil engangsoppsettet over er gjort, kjører `publish-pub.yml` kun
> via `workflow_dispatch` (release-triggeren er kommentert ut), og biblioteket
> publiseres manuelt med `flutter pub publish`. Når trusted publishing er
> aktivert: legg tilbake `release: [published]`-triggeren, så publiseres
> biblioteket automatisk fra en GitHub Release igjen. MCP-serveren publiseres
> uansett automatisk fra GitHub Release via `publish-mcp.yml`.

## Slik gir du ut en versjon

1. **Oppdater versjonsnummer** (hold dem synkronisert) til samme `X.Y.Z`:
   - `pubspec.yaml` → feltet `version:`
   - `mcp-server/package.json` → feltet `"version"`

2. **Legg til endringsloggoppføring** øverst i `CHANGELOG.md` med dato:

   ```markdown
   ## X.Y.Z — YYYY-MM-DD
   ```

   (Bruk tankestrek `—` mellom versjon og dato, slik resten av loggen gjør.)

3. **Commit** endringene:

   ```bash
   git add pubspec.yaml mcp-server/package.json CHANGELOG.md
   git commit -m "chore: bump version to X.Y.Z"
   git push
   ```

4. **Opprett en git-tag og en GitHub Release** med taggen `vX.Y.Z`:

   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   gh release create vX.Y.Z --title "vX.Y.Z" --notes "Se CHANGELOG.md"
   ```

   Du kan også opprette releasen via GitHub-grensesnittet.

Når releasen **publiseres**, trigges begge workflowene:

| Workflow                                                       | Pakke                  | Mål              |
| ------------------------------------------------------------- | ---------------------- | ---------------- |
| [`publish-pub.yml`](.github/workflows/publish-pub.yml)        | `designsystemet_flutter` | pub.dev          |
| [`publish-mcp.yml`](.github/workflows/publish-mcp.yml)        | MCP-server             | GitHub Packages  |

## Beta / forhåndsutgivelser

Forhåndsutgivelser bruker et SemVer pre-release-suffiks, f.eks. `0.3.0-beta.1`
(neste blir `0.3.0-beta.2`, deretter `0.3.0` for den stabile utgaven). Både
pub.dev og npm behandler `-beta.N`-versjoner som forhåndsutgivelser: de vises
ikke som «latest stable», og brukere må be om dem eksplisitt
(`designsystemet_flutter: ^0.3.0-beta.1`).

- Bruk samme `-beta.N`-versjon i `pubspec.yaml`, `mcp-server/package.json` og
  `CHANGELOG.md`.
- Tag og GitHub Release: `v0.3.0-beta.1`. **Huk av «Set as a pre-release»** når
  du oppretter releasen (eller `gh release create v0.3.0-beta.1 --prerelease`).
- `dart pub publish` og `npm publish` markerer automatisk utgivelsen som
  forhåndsutgivelse basert på `-beta.N`-suffikset.

## Manuell reserveløsning

Hvis automatisk publisering til pub.dev ikke er tilgjengelig, kan biblioteket
publiseres manuelt. Kjør først en tørrkjøring og rett opp eventuelle advarsler:

```bash
flutter pub publish --dry-run
```

Når tørrkjøringen er ren (0 advarsler):

```bash
flutter pub publish
```

## Sjekkliste før release

Kjør gjennom denne før du oppretter releasen:

- [ ] **Flutter-bibliotek:** `flutter analyze --no-fatal-infos` → 0 problemer
- [ ] **Flutter-bibliotek:** `flutter test` → grønt
- [ ] **Flutter-bibliotek:** `flutter pub publish --dry-run` → 0 advarsler
- [ ] **MCP-server:** `cd mcp-server && npm test` → grønt
- [ ] **MCP-server:** `cd mcp-server && npm audit` → 0 sårbarheter
- [ ] **Dokumentasjonsside:** `cd site && npm ci && npm run build` → bygger uten feil
- [ ] Versjon synkronisert i `pubspec.yaml` og `mcp-server/package.json`
- [ ] `CHANGELOG.md` har en datert oppføring for den nye versjonen
