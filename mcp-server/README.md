# Komponentbibliotek MCP-server

MCP-server som gjør komponentbiblioteket tilgjengelig for AI-kodeassistenter. Tilbyr oppslag av komponent-API-er, migreringsmapping fra Material til Designsystemet, tema-/tokenreferanse og dokumentasjonssøk.

## Hurtigstart

```bash
cd mcp-server
npm install
npm run build
npm start
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

## Koble til Claude Code

Legg til i prosjektets `.mcp.json`:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "node",
      "args": ["/sti/til/komponentbibliotek.flutter/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "/sti/til/komponentbibliotek.flutter"
      }
    }
  }
}
```

Eller kjør i utviklingsmodus:

```json
{
  "mcpServers": {
    "komponentbibliotek": {
      "command": "npx",
      "args": ["tsx", "/sti/til/komponentbibliotek.flutter/mcp-server/src/index.ts"],
      "env": {
        "REPO_ROOT": "/sti/til/komponentbibliotek.flutter"
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
      "command": "node",
      "args": ["/sti/til/komponentbibliotek.flutter/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "/sti/til/komponentbibliotek.flutter"
      }
    }
  }
}
```

## Docker

```bash
cd /sti/til/komponentbibliotek.flutter
docker build -t komponentbibliotek-mcp -f mcp-server/Dockerfile .
docker run -i komponentbibliotek-mcp
```

## Frittstående distribusjon

For å kjøre uten en repo-checkout, forhåndsbygg dataene:

```bash
npm run build
npm run build-data
# dist/ inneholder nå alt som trengs
```
