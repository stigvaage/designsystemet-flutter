# Om Flutter-biblioteket

`komponentbibliotek_flutter` er en fullstendig Flutter-implementasjon av [Designsystemet](https://designsystemet.no) fra Digitaliseringsdirektoratet. Biblioteket gir deg 40 ferdige, tilgjengelige og tokendrevne UI-komponenter — klare til bruk i offentlige digitale tjenester.

## 40 komponenter i fire kategorier

Komponentene er organisert i fire hovedkategorier:

| Kategori | Eksempler |
|---|---|
| **Knapper og handlinger** | `DsButton`, `DsIconButton`, `DsToggleButton`, `DsChip` m.fl. |
| **Skjema og inndata** | `DsTextField`, `DsTextArea`, `DsCheckbox`, `DsRadio`, `DsSwitch`, `DsSelect` m.fl. |
| **Navigasjon og struktur** | `DsTabs`, `DsBreadcrumbs`, `DsPagination`, `DsAccordion`, `DsCard` m.fl. |
| **Tilbakemelding og informasjon** | `DsAlert`, `DsTag`, `DsBadge`, `DsTooltip`, `DsSpinner`, `DsDialog` m.fl. |

## Tokendrevet temaarkitektur

Alle visuelle egenskaper — farger, typografi, avstander, avrundinger og størrelser — styres gjennom **designtokens**. Ingen verdier er hardkodet i komponentene.

Arkitekturen er bygget rundt to hovedelementer:

- **`DsThemeData`** — En uforanderlig dataklasse som samler alle tokens for et komplett tema (farger, typografi, avstander osv.).
- **`DsTheme`** — En `InheritedWidget` som gjør `DsThemeData` tilgjengelig for hele widgettreet. Komponenter henter sine visuelle verdier herfra.

```dart
DsTheme(
  data: DsThemeData.digdirLight(),
  child: MyApp(),
)
```

## Innebygd Digdir-tema

Biblioteket leveres med Digitaliseringsdirektoratets offisielle tema i to varianter:

- **`DsThemeData.digdirLight()`** — Lyst modus
- **`DsThemeData.digdirDark()`** — Mørkt modus

Temaene er generert direkte fra de offisielle designtokens og er alltid oppdatert med siste versjon av Designsystemet.

## Egendefinerte temaer

Virksomheter som har sitt eget tema i Designsystemet kan importere det via den innebygde **kodegeneratoren**. Verktøyet leser tokenfiler fra Designsystemets CLI og genererer en ferdig `DsThemeData`-klasse for din virksomhet.

## Lokale overstyringer

For tilfeller der deler av grensesnittet trenger avvikende farger eller størrelser, tilbyr biblioteket to scope-widgets:

- **`DsColorScope`** — Overstyrer fargeskalaen for en del av widgettreet (f.eks. en kontrastrik seksjon).
- **`DsSizeScope`** — Overstyrer størrelsesnivå (`sm`, `md`, `lg`) for en del av widgettreet.

```dart
DsColorScope(
  colorScale: DsColorScales.blue,
  child: DsButton(label: 'Blå knapp'),
)
```

## Ingen Material- eller Cupertino-avhengigheter

Alle komponenter er bygget fra bunnen av med `package:flutter/widgets.dart` og `package:flutter/rendering.dart`. Biblioteket har **ingen visuelle avhengigheter til Material eller Cupertino**, noe som betyr:

- Ingen uventede visuelle konflikter med plattformtemaer.
- Full kontroll over utseendet i henhold til Designsystemets spesifikasjoner.
- Komponentene ser identiske ut på alle plattformer.

## Innebygd Inter-font

Designsystemet bruker fonten **Inter** som standardskrifttype. Fonten er pakket som en del av biblioteket, slik at du slipper å installere den separat. Den registreres automatisk når `DsTheme` brukes.

## Universell utforming (WCAG 2.1 AA)

Alle komponenter er utviklet med universell utforming som grunnleggende krav:

- **Semantikk** — Riktig bruk av `Semantics`-widgeten for skjermlesere.
- **Tastaturnavigasjon** — Alle interaktive komponenter kan betjenes med tastatur og har synlige fokusindikatorer.
- **Fargekontrast** — Alle tekst- og ikonfarger oppfyller WCAG 2.1 AA kontrastkrav (minimum 4.5:1 for normal tekst, 3:1 for stor tekst).
- **Berøringsmål** — Interaktive elementer har minimumsstørrelse på 44x44 piksler.

## Alle Flutter-plattformer

Biblioteket støtter samtlige plattformer som Flutter dekker:

- Android
- iOS
- Web
- macOS
- Linux
- Windows

Komponentene tilpasser seg automatisk plattformspesifikke konvensjoner der det er relevant (f.eks. scrollfysikk), men beholder Designsystemets visuelle identitet.
