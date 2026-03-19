# MCP-server

Komponentbiblioteket inkluderer en MCP-server (Model Context Protocol) som gjør at AI-kodeassistenter kan slå opp komponenter, hente migrasjonsråd fra Material, og søke i dokumentasjonen -- direkte fra editoren din.

## Hva er MCP?

[Model Context Protocol](https://modelcontextprotocol.io) er en åpen standard som lar AI-assistenter koble seg til eksterne datakilder og verktøy. MCP-serveren i dette biblioteket gir AI-assistenten din tilgang til:

- Alle 40 komponenter (43 inkludert underkomponenter) med egenskaper, typer og eksempler
- Migrasjonsråd fra Material-widgets til Designsystemet-ekvivalenter
- Komplette designtokens (farger, typografi, størrelser, skygger)
- Dokumentasjonssøk på tvers av alle sider
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
    "designsystemet-flutter": {
      "command": "node",
      "args": ["/sti/til/designsystemet-flutter/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "/sti/til/designsystemet-flutter"
      }
    }
  }
}
```

For utvikling kan du bruke `tsx` i stedet:

```json
{
  "mcpServers": {
    "designsystemet-flutter": {
      "command": "npx",
      "args": ["tsx", "/sti/til/designsystemet-flutter/mcp-server/src/index.ts"],
      "env": {
        "REPO_ROOT": "/sti/til/designsystemet-flutter"
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
    "designsystemet-flutter": {
      "command": "node",
      "args": ["/sti/til/designsystemet-flutter/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "/sti/til/designsystemet-flutter"
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
    "designsystemet-flutter": {
      "command": "node",
      "args": ["/sti/til/designsystemet-flutter/mcp-server/dist/index.js"],
      "env": {
        "REPO_ROOT": "/sti/til/designsystemet-flutter"
      }
    }
  }
}
```

## Tilgjengelige verktøy

Når MCP-serveren er koblet til, får AI-assistenten din tilgang til disse verktøyene:

### `lookup_component`

Slå opp en komponent etter navn. Returnerer alle egenskaper med typer, standardverdier, import-setning og kodeeksempler.

**Eksempel:** «Slå opp DsButton» gir:
- 10 egenskaper med typer og standardverdier
- Import-setning
- Kodeeksempler fra dokumentasjonen

### `list_components`

List alle tilgjengelige komponenter, valgfritt filtrert på kategori: form, navigation, layout, content, interactive eller typography.

### `get_migration_mapping`

Få migrasjonsråd fra en Material-widget til Designsystemet-ekvivalenten. Inkluderer:
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

Få trinnvis veiledning for å sette opp Designsystemet-temaet i Flutter-appen din, inkludert DsTheme-wrapping, lys/mørk modus og farge-/størrelsesscoping.

### `list_tokens`

List designtokens etter kategori:
- **colors** -- 9 fargeskalaer med 16 trinn hver
- **typography** -- 7 overskriftnivåer + 15 brødtekststiler
- **sizes** -- Størrelsestokens (sm/md/lg)
- **border-radius** -- Avrundingsverdier
- **shadows** -- Skyggedefinisjoner (xs--xl)
- **icons** -- Lucide-ikoner tilgjengelig via DsIcons

### `search_docs`

Søk på tvers av all dokumentasjon -- komponentsider, kom-i-gang-guider og god praksis. Returnerer relevante utdrag med kildeangivelse.

## Tilgjengelige ressurser

MCP-serveren eksponerer også rådata som AI-assistenten kan lese direkte:

| Ressurs | Beskrivelse |
|---------|-------------|
| `component:///{sti}` | Les Dart-kildefiler for komponenter |
| `docs:///{sti}` | Les dokumentasjonssider (Markdown) |

## Docker

For teambruk kan serveren også kjøres som Docker-container:

```bash
# Fra repositoryets rotmappe
docker build -t designsystemet-flutter-mcp -f mcp-server/Dockerfile .
docker run -i designsystemet-flutter-mcp
```

## Feilsøking

### Serveren starter ikke

Sjekk at `REPO_ROOT` peker på riktig mappe:

```bash
REPO_ROOT=/sti/til/repo node mcp-server/dist/index.js
```

### Verktøy returnerer tomme resultater

Sjekk at biblioteket er bygget og at kildefilene finnes under `lib/src/components/`.

### Dokumentasjonssøk gir ingen treff

Sjekk at `site/nb/`-mappen finnes med Markdown-filer.
