# Om Flutter-biblioteket

`designsystemet_flutter` er en fullstendig Flutter-implementasjon av [Designsystemet](https://designsystemet.no) fra Digitaliseringsdirektoratet. Biblioteket gir deg 40 ferdige, tilgjengelige og tokendrevne UI-komponenter — klare til bruk i offentlige digitale tjenester.

## 40 komponenter i fire kategorier

Komponentene er organisert i fire hovedkategorier:

| Kategori | Eksempler |
|---|---|
| **Knapper og handlinger** | `DsButton`, `DsToggleGroup`, `DsChip` m.fl. |
| **Skjema og inndata** | `DsTextfield`, `DsTextarea`, `DsCheckbox`, `DsRadio`, `DsSwitch`, `DsSelect`, `DsField` m.fl. |
| **Navigasjon og struktur** | `DsTabs`, `DsBreadcrumbs`, `DsPagination`, `DsDetails`, `DsCard` m.fl. |
| **Tilbakemelding og informasjon** | `DsAlert`, `DsTag`, `DsBadge`, `DsTooltip`, `DsSpinner`, `DsDialog` m.fl. |

## Tokendrevet temaarkitektur

Alle visuelle egenskaper — farger, typografi, avstander, avrundinger og størrelser — styres gjennom **designtokens**. Ingen verdier er hardkodet i komponentene.

Arkitekturen er bygget rundt to hovedelementer:

- **`DsThemeData`** — En uforanderlig dataklasse som samler alle tokens for et komplett tema (farger, typografi, avstander osv.).
- **`DsTheme`** — En `InheritedWidget` som gjør `DsThemeData` tilgjengelig for hele widgettreet. Komponenter henter sine visuelle verdier herfra.

```dart
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';

DsTheme(
  data: DsThemeDigdir.light(),
  child: MyApp(),
)
```

## Innebygd tema

Biblioteket leveres med et innebygd tema i to varianter:

- **`DsThemeDigdir.light()`** — Lyst modus
- **`DsThemeDigdir.dark()`** — Mørkt modus

Temaet bruker Designsystemets token-arkitektur, men standard accent-basefarge er mørkeblå `#003087` (se [Tema-siden](../kom-i-gang/tema/)). Vil du bruke Digitaliseringsdirektoratets offisielle accent eller en annen merkevarefarge, genererer du egne tokens med kodegeneratoren.

## Egendefinerte temaer

Virksomheter som har sitt eget tema i Designsystemet kan importere det via den innebygde **kodegeneratoren**. Verktøyet leser tokenfiler fra Designsystemets CLI og genererer en ferdig `DsThemeData`-klasse for din virksomhet.

## Lokale overstyringer

For tilfeller der deler av grensesnittet trenger avvikende farger eller størrelser, tilbyr biblioteket to scope-widgets:

- **`DsColorScope`** — Overstyrer fargeskalaen for en del av widgettreet (f.eks. en kontrastrik seksjon).
- **`DsSizeScope`** — Overstyrer størrelsesnivå (`sm`, `md`, `lg`) for en del av widgettreet.

```dart
DsColorScope(
  color: DsColor.brand1,
  child: DsButton(
    onPressed: () {},
    child: Text('Knapp med merkevarefarge'),
  ),
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
