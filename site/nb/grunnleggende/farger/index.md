# Farger

Fargesystemet bygger pa semantiske fargeskalaer som sikrer konsistent bruk og tilstrekkelig kontrast.

## DsColorScheme

`DsColorScheme` inneholder ni semantiske fargeskalaer:

| Skala | Bruksomrade |
|---|---|
| `accent` | Primaerhandlinger og fremhevinger |
| `neutral` | Noytralt innhold, bakgrunner og skillelinjer |
| `brand1` | Forste merkevarefargen |
| `brand2` | Andre merkevarefargen |
| `brand3` | Tredje merkevarefargen |
| `success` | Bekreftelser og suksessmeldinger |
| `danger` | Feil og destruktive handlinger |
| `warning` | Advarsler |
| `info` | Informasjonsmeldinger |

## DsColorScale

Hver fargeskala bestar av 16 tokens fordelt i fem grupper.

### Bakgrunn (2 tokens)

| Token | Bruk | Kontrast |
|---|---|---|
| `backgroundDefault` | Standard sidebakgrunn | -- |
| `backgroundTinted` | Tonet bakgrunn for seksjoner | -- |

### Overflate (4 tokens)

| Token | Bruk | Kontrast |
|---|---|---|
| `surfaceDefault` | Kort, boks, standard overflate | -- |
| `surfaceTinted` | Tonet overflate | -- |
| `surfaceHover` | Hover-tilstand pa overflate | -- |
| `surfaceActive` | Aktiv-tilstand pa overflate | -- |

### Kantlinje (3 tokens)

| Token | Bruk | Kontrast |
|---|---|---|
| `borderSubtle` | Subtile skillelinjer | -- |
| `borderDefault` | Standard kantlinjer | >=3:1 mot bakgrunn |
| `borderStrong` | Tydelige kantlinjer, fokusindikatorer | >=3:1 mot bakgrunn |

### Tekst (2 tokens)

| Token | Bruk | Kontrast |
|---|---|---|
| `textSubtle` | Sekundaer tekst, hjelpetekst | >=4.5:1 mot bakgrunn |
| `textDefault` | Brodtekst og overskrifter | >=4.5:1 mot bakgrunn |

### Base (5 tokens)

| Token | Bruk | Kontrast |
|---|---|---|
| `baseDefault` | Fylte knapper, aktive elementer | -- |
| `baseHover` | Hover-tilstand pa base | -- |
| `baseActive` | Aktiv-tilstand pa base | -- |
| `baseContrastSubtle` | Subtil tekst pa base | >=3:1 mot base |
| `baseContrastDefault` | Tekst og ikoner pa base | >=4.5:1 mot base |

## DsColorScope

`DsColorScope` lar deg overstyre fargeskalaen for et undertreav widgeter:

```dart
DsColorScope(
  color: DsColor.danger,
  child: DsButton(
    variant: DsButtonVariant.primary,
    onPressed: () => slett(),
    child: Text('Slett'),
  ),
)
```

Alle komponenter inne i `DsColorScope` bruker den angitte fargeskalaen i stedet for standard.

## DsColor

`DsColor`-enumen representerer de tilgjengelige fargeskalaene:

```dart
DsColor.accent
DsColor.neutral
DsColor.brand1
DsColor.brand2
DsColor.brand3
DsColor.success
DsColor.danger
DsColor.warning
DsColor.info
DsColor.custom('minFarge')  // Egendefinert fargeskala fra tema
```

## Bruke fargetokens direkte

```dart
Widget build(BuildContext context) {
  final farger = DsTheme.of(context).colorScheme;
  final accent = farger.accent;

  return Container(
    color: accent.surfaceDefault,
    child: Text(
      'Eksempel',
      style: TextStyle(color: accent.textDefault),
    ),
  );
}
```

## Kontrastgarantier

Fargesystemet garanterer folgende kontrastniva i bade lyst og morkt modus:

- **Tekst mot bakgrunn**: `textDefault` og `textSubtle` har minst 4.5:1 kontrast
- **Kantlinjer mot bakgrunn**: `borderDefault` har minst 3:1 kontrast
- **Tekst pa base**: `baseContrastDefault` har minst 4.5:1 kontrast mot `baseDefault`
