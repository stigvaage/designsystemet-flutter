# Komponentbibliotek MCP-server

MCP-server som gjør komponentbiblioteket tilgjengelig for AI-kodeassistenter. Tilbyr oppslag av komponent-API-er, migreringsmapping fra Material til Designsystemet, tema-/tokenreferanse og dokumentasjonssøk.

## Installasjon via GitHub Packages

Pakken publiseres til [GitHub Packages](https://github.com/stigvaage/komponentbibliotek-flutter/packages).

Konfigurer npm til å hente `@stigvaage`-pakker fra GitHub Packages ved å legge til i `.npmrc`:

```
@stigvaage:registry=https://npm.pkg.github.com
```

Installer deretter:

```bash
npm install @stigvaage/komponentbibliotek-flutter-mcp
```

## Koble til Claude Code

Legg til i prosjektets `.mcp.json`:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "npx",
      "args": ["-y", "@stigvaage/komponentbibliotek-flutter-mcp"],
      "env": {
        "REPO_ROOT": "/sti/til/komponentbibliotek.flutter"
      }
    }
  }
}
```

Eller fra en lokal klon:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "node",
      "args": ["mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "."
      }
    }
  }
}
```

## Koble til Cursor

Legg til i `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "npx",
      "args": ["-y", "@stigvaage/komponentbibliotek-flutter-mcp"],
      "env": {
        "REPO_ROOT": "/sti/til/komponentbibliotek.flutter"
      }
    }
  }
}
```

## Lokal utvikling

```bash
cd mcp-server
npm install
npm run build
npm start
```

Utviklingsmodus (auto-reload):

```bash
npm run dev
```

## Verktøy

| Verktøy | Beskrivelse |
|---------|-------------|
| `lookup_component` | Slå opp en komponent etter navn — returnerer egenskaper, eksempler og import |
| `list_components` | List alle komponenter, valgfritt filtrert på kategori |
| `get_migration_mapping` | Kartlegg en Material-widget til dens Designsystemet-ekvivalent |
| `get_theme_setup` | Få trinnvis veiledning for temaoppsett |
| `list_tokens` | List designtokens etter kategori (farger, typografi, størrelser m.m.) |
| `search_docs` | Søk på tvers av all dokumentasjon |

## Ressurser

| Ressurs | Beskrivelse |
|---------|-------------|
| `component:///{sti}` | Les Dart-kildefiler for komponenter |
| `docs:///{sti}` | Les markdown-dokumentasjonsfiler |

## Docker

```bash
docker build -t komponentbibliotek-mcp -f mcp-server/Dockerfile .
docker run -i komponentbibliotek-mcp
```
