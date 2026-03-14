# MCP-server

Komponentbiblioteket inkluderer en MCP-server (Model Context Protocol) som gjor at AI-kodeassistenter kan sla opp komponenter, hente migrasjonsrad fra Material, og soke i dokumentasjonen -- direkte fra editoren din.

## Hva er MCP?

[Model Context Protocol](https://modelcontextprotocol.io) er en apen standard som lar AI-assistenter koble seg til eksterne datkilder og verktoy. MCP-serveren i dette biblioteket gir AI-assistenten din tilgang til:

- Alle 43 komponent-APIer med egenskaper, typer og eksempler
- Migrasjonsrad fra Material-widgets til Designsystemet-ekvivalenter
- Komplette designtokens (farger, typografi, storrelser, skygger)
- Dokumentasjonssok pa tvers av alle sider
- Trinnvis veiledning for temaoppsett

## Forutsetninger

- Node.js >= 18
- npm >= 9

## Bygg serveren

```bash
cd mcp-server
npm install
npm run build
```

## Koble til AI-assistenten din

### Claude Code

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

For utvikling kan du bruke `tsx` i stedet:

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

### VS Code (GitHub Copilot)

Legg til i `.vscode/mcp.json` i prosjektmappen din:

```json
{
  "servers": {
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

### Cursor

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

## Tilgjengelige verktoy

Nar MCP-serveren er koblet til, far AI-assistenten din tilgang til disse verktoyene:

### `lookup_component`

Sla opp en komponent etter navn. Returnerer alle egenskaper med typer, standardverdier, import-setning og kodeeksempler.

**Eksempel:** «Sla opp DsButton» gir:
- 10 egenskaper med typer og standardverdier
- Import-setning
- Kodeeksempler fra dokumentasjonen

### `list_components`

List alle tilgjengelige komponenter, valgfritt filtrert pa kategori: form, navigation, layout, content, interactive eller typography.

### `get_migration_mapping`

Fa migrasjonsrad fra en Material-widget til Designsystemet-ekvivalenten. Inkluderer:
- Egenskapsmapping (Material-egenskap → Ds-egenskap)
- For/etter-kodeeksempler
- Migreringsnotater

Dekker 20+ Material-widgets:

| Material | Designsystemet |
|----------|---------------|
| ElevatedButton | DsButton (primary) |
| OutlinedButton | DsButton (secondary) |
| TextButton | DsButton (tertiary) |
| TextField | DsTextfield |
| Checkbox | DsCheckbox |
| Radio | DsRadio |
| Switch | DsSwitch |
| AlertDialog | DsDialog |
| Card | DsCard |
| TabBar | DsTabs |
| Tooltip | DsTooltip |
| DropdownButton | DsSelect |
| Chip | DsChip |
| Badge | DsBadge |
| Divider | DsDivider |
| CircularProgressIndicator | DsSpinner |
| DataTable | DsTable |
| SearchBar | DsSearch |

### `get_theme_setup`

Fa trinnvis veiledning for a sette opp Designsystemet-temaet i Flutter-appen din, inkludert DsTheme-wrapping, lys/mork modus og farge-/storrelsesscoping.

### `list_tokens`

List designtokens etter kategori:
- **colors** -- 9 fargeskalaer med 16 trinn hver
- **typography** -- 7 overskriftnivaer + 15 brodtekststiler
- **sizes** -- Storrelsestokens (sm/md/lg)
- **border-radius** -- Avrundingsverdier
- **shadows** -- Skyggedefinisjoner (xs--xl)
- **icons** -- Lucide-ikoner tilgjengelig via DsIcons

### `search_docs`

Sok pa tvers av all dokumentasjon -- komponentsider, kom-i-gang-guider og god praksis. Returnerer relevante utdrag med kildeangivelse.

## Tilgjengelige ressurser

MCP-serveren eksponerer ogsa radata som AI-assistenten kan lese direkte:

| Ressurs | Beskrivelse |
|---------|-------------|
| `component:///{sti}` | Les Dart-kildefiler for komponenter |
| `docs:///{sti}` | Les dokumentasjonssider (Markdown) |

## Docker

For teambruk kan serveren ogsa kjores som Docker-container:

```bash
# Fra repositoryets rotmappe
docker build -t komponentbibliotek-mcp -f mcp-server/Dockerfile .
docker run -i komponentbibliotek-mcp
```

## Feilsoking

### Serveren starter ikke

Sjekk at `REPO_ROOT` peker pa riktig mappe:

```bash
REPO_ROOT=/sti/til/repo node mcp-server/dist/index.js
```

### Verktoy returnerer tomme resultater

Sjekk at biblioteket er bygget og at kildefilene finnes under `lib/src/components/`.

### Dokumentasjonssok gir ingen treff

Sjekk at `site/nb/`-mappen finnes med Markdown-filer.
