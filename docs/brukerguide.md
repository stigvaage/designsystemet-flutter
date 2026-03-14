# Brukerguide for komponentbibliotek_flutter

## Innledning

[Designsystemet](https://designsystemet.no) er det norske offentlige designsystemet, utviklet og vedlikeholdt av Digitaliseringsdirektoratet (Digdir). Det tilbyr et helhetlig sett med designtokens, komponenter og retningslinjer for a bygge tilgjengelige, konsistente digitale tjenester i offentlig sektor.

`komponentbibliotek_flutter` er en fullstendig Flutter-implementasjon av Designsystemet. Biblioteket gir deg 40 ferdige komponenter, et tokendrevet temasystem, og full stotte for egendefinerte temaer -- alt uten avhengigheter til Material eller Cupertino.

Denne brukerguiden dekker alt du trenger for a ta biblioteket i bruk, fra oppsett og temahaandtering til detaljert bruk av komponenter og tilgjengelighet.

---

## Kom i gang

### Systemkrav

- Flutter 3.19 eller nyere
- Dart 3.3 eller nyere
- Alle Flutter-plattformer stottet: Android, iOS, Web, macOS, Linux, Windows

### Installer pakken

Legg til pakken i `pubspec.yaml`:

```yaml
dependencies:
  komponentbibliotek_flutter: ^1.0.0
```

Kjor installasjonen:

```bash
flutter pub get
```

### Importer biblioteket

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
```

For mer granulerte importer (bedre tree-shaking) kan du bruke separate inngangspunkter:

```dart
// Kun tema-infrastruktur
import 'package:komponentbibliotek_flutter/theme.dart';

// Kun komponenter
import 'package:komponentbibliotek_flutter/components.dart';

// Kun typografi-komponenter
import 'package:komponentbibliotek_flutter/typography.dart';
```

### Pakk inn applikasjonen

Pakk inn rotwidgeten din med `DsTheme` for a gjore temaet tilgjengelig for alle komponenter:

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    DsTheme(
      data: DsThemeData.digdir(), // Innebygd Digdir-tema, lyst modus
      child: const MinApp(),
    ),
  );
}
```

> **Viktig:** Alle Designsystemet-komponenter krever en `DsTheme`-ancestor i widgettreet. Dersom `DsTheme` mangler, vil komponentene kaste en beskrivende feilmelding.

---

## Temaarkitektur

Bibliotekets temasystem er bygget rundt designtokens som styrer alle visuelle egenskaper. Arkitekturen bestar av flere lag som samarbeider for a gi en fleksibel og konsistent temaopplevelse.

### DsThemeData

`DsThemeData` er den sentrale temaklassen som inneholder alle designtokens:

| Felt | Type | Beskrivelse |
|------|------|-------------|
| `brightness` | `Brightness` | Lyst eller morkt modus |
| `colorScheme` | `DsColorScheme` | Alle fargeskalaer (9 semantiske + egendefinerte) |
| `sizeTokens` | `DsSizeTokens` | Storrelsestokens for aktiv storrelsesmodus |
| `typography` | `DsTypography` | Tekststilar med skriftfamilie og alle nivaer |
| `borderRadius` | `DsBorderRadiusTokens` | Hjorneavrundingstokens |
| `shadows` | `DsShadowTokens` | Skyggetokens |
| `disabledOpacity` | `double` | Gjennomsiktighet for deaktivert tilstand (standard: 0.3) |

**Fabrikkmetoder:**

```dart
// Innebygd Digdir-tema
final lystTema = DsThemeData.digdir(); // lyst modus (standard)
final morktTema = DsThemeData.digdir(brightness: Brightness.dark);

// Fra JSON-tokens (brukes av kodegeneratoren)
final egendefinertTema = DsThemeData.fromTokens(jsonMap);
```

### DsTheme (InheritedWidget)

`DsTheme` er en `InheritedWidget` som gjor temaet tilgjengelig i hele widgettreet:

```dart
// Sett tema pa rotniva
DsTheme(
  data: DsThemeData.digdir(),
  child: MinApp(),
)

// Hent tema i en komponent
final tema = DsTheme.of(context);
final farger = tema.colorScheme;
final typografi = tema.typography;
```

**API:**

| Metode | Beskrivelse |
|--------|-------------|
| `DsTheme.of(context)` | Returnerer naermeste `DsThemeData`, eller kaster feil |
| `DsTheme.maybeOf(context)` | Returnerer naermeste `DsThemeData`, eller `null` |

### ThemeExtension-integrasjon med MaterialApp

`DsThemeData` implementerer `ThemeExtension<DsThemeData>`, noe som gjor det mulig a integrere med eksisterende `MaterialApp`-applikasjoner:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [DsThemeData.digdir()],
  ),
  home: DsTheme(
    data: DsThemeData.digdir(),
    child: const MinApp(),
  ),
)

// Tilgang via Material Theme:
final dsTheme = Theme.of(context).extension<DsThemeData>()!;
```

`DsThemeData` implementerer bade `copyWith` og `lerp` for a stotte temanimasjoner og delvis temaoverskrivning.

> **Merk:** Bibliotekkomponentene bruker alltid `DsTheme.of(context)` internt. `ThemeExtension`-integrasjonen er et valgfritt tillegg for utviklere som bruker `MaterialApp`.

---

## Fargesystemet

Designsystemets fargesystem er bygget rundt semantiske fargeskalaer som sikrer kontrast og tilgjengelighet.

### DsColorScheme -- 9 semantiske fargeskalaer

`DsColorScheme` inneholder 9 navngitte fargeskalaer pluss stotte for egendefinerte skalaer:

| Fargeskala | Beskrivelse |
|------------|-------------|
| `accent` | Primaer interaksjonsfarge (standardfarge for komponenter) |
| `neutral` | Noytral/gra fargeskala |
| `brand1` | Forste merkevare-farge |
| `brand2` | Andre merkevare-farge |
| `brand3` | Tredje merkevare-farge |
| `success` | Suksess / positivt semantisk farge |
| `danger` | Feil / destruktivt semantisk farge |
| `warning` | Advarsel / forsiktighet |
| `info` | Informasjonsfarge |

Tilgang til en fargeskala:

```dart
final tema = DsTheme.of(context);
final accentFarger = tema.colorScheme.accent;
final fareFarger = tema.colorScheme.danger;
```

### DsColorScale -- 16 tokens per fargeskala

Hver fargeskala inneholder 16 farge-tokens fordelt pa 5 grupper:

#### Bakgrunn (2 tokens)

| Token | Beskrivelse |
|-------|-------------|
| `backgroundDefault` | Standard bakgrunnsfarge for store flater |
| `backgroundTinted` | Tonet variant av bakgrunnsfargen |

#### Overflate (4 tokens)

| Token | Beskrivelse |
|-------|-------------|
| `surfaceDefault` | Standard overflate for kort og paneler |
| `surfaceTinted` | Tonet variant av overflaten |
| `surfaceHover` | Overflatefarge ved pekerhover |
| `surfaceActive` | Overflatefarge ved trykk/aktiv tilstand |

#### Kantlinje (3 tokens)

| Token | Beskrivelse |
|-------|-------------|
| `borderSubtle` | Lavintensitets kantlinje |
| `borderDefault` | Standard kantlinje (minst 3:1 kontrast mot bakgrunn) |
| `borderStrong` | Hoyintensitets kantlinje (minst 3:1 mot alle overflater) |

#### Tekst (2 tokens)

| Token | Beskrivelse |
|-------|-------------|
| `textSubtle` | Sekundaertekst (minst 4.5:1 mot bakgrunn og standard overflate) |
| `textDefault` | Primaertekst (minst 4.5:1 mot alle bakgrunner og overflater) |

#### Base (5 tokens)

| Token | Beskrivelse |
|-------|-------------|
| `baseDefault` | Solid fyll for knapper, merker etc. |
| `baseHover` | Solid fyll ved hover |
| `baseActive` | Solid fyll ved trykk |
| `baseContrastSubtle` | Tekst pa `baseDefault` (minst 4.5:1) |
| `baseContrastDefault` | Tekst pa `baseDefault` OG `baseHover` (minst 4.5:1) |

### DsColorScope -- lokal fargeoverstyring

`DsColorScope` lar deg overstyre den aktive fargeskalaen for et undertree:

```dart
// Standard: komponenter bruker accent-fargeskalaen
DsButton(
  onPressed: () {},
  child: Text('Standard accent-knapp'),
)

// Overstyr til danger-fargeskalaen
DsColorScope(
  color: DsColor.danger,
  child: DsButton(
    onPressed: () => slett(),
    child: Text('Slett-knapp i fare-farge'),
  ),
)

// Kan ogsa settes per komponent
DsButton(
  color: DsColor.success,
  onPressed: () => lagre(),
  child: Text('Lagre-knapp i suksessfarge'),
)
```

Nar en komponent har bade en lokal `color`-parameter og en `DsColorScope`-ancestor, har den lokale parameteren forrang.

### DsColor-verdier

`DsColor` identifiserer hvilken fargeskala som skal brukes:

| Verdi | Fargeskala |
|-------|------------|
| `DsColor.accent` | Accent (standard) |
| `DsColor.neutral` | Noytral |
| `DsColor.brand1` | Merkevare 1 |
| `DsColor.brand2` | Merkevare 2 |
| `DsColor.brand3` | Merkevare 3 |
| `DsColor.success` | Suksess |
| `DsColor.danger` | Fare |
| `DsColor.warning` | Advarsel |
| `DsColor.info` | Informasjon |
| `DsColor.custom('key')` | Egendefinert fargeskala |

---

## Storrelsessystem

Designsystemet tilbyr tre storrelsesmoduser som pavirker alle komponenter.

### DsSize-verdier

| Verdi | Basisskrift | Steg | Typisk komponenthoyde |
|-------|-------------|------|-----------------------|
| `DsSize.sm` | 16px | 4px | ca. 36px |
| `DsSize.md` | 18px | 4px | ca. 48px (standard) |
| `DsSize.lg` | 21px | 4px | ca. 56px |

### DsSizeTokens

`DsSizeTokens` inneholder beregnet storrelsesdata for den aktive storelssesmodusen, inkludert 31 nummererte verdier (`size0` til `size30`) beregnet fra basisstorrelsen og stegverdien.

```dart
final tema = DsTheme.of(context);
final storrelse = tema.sizeTokens;
final basisskrift = storrelse.base; // 18.0 for md
```

### DsSizeScope -- lokal storrelsesoverstyring

`DsSizeScope` lar deg overstyre den aktive storrelsesmodusen for et undertree:

```dart
// Stort skjema
DsSizeScope(
  size: DsSize.lg,
  child: Column(
    children: [
      DsField(
        label: 'Fornavn',
        child: DsTextfield(controller: fornavnController),
      ),
      DsField(
        label: 'Etternavn',
        child: DsTextfield(controller: etternavnController),
      ),
      DsButton(
        onPressed: () => send(),
        child: Text('Send inn'),
      ),
    ],
  ),
)

// Kompakt sidefelt
DsSizeScope(
  size: DsSize.sm,
  child: Column(
    children: [
      DsHeading(text: 'Filtre', level: DsHeadingLevel.sm),
      DsCheckbox(value: true, onChanged: (_) {}, label: Text('Aktiv')),
      DsCheckbox(value: false, onChanged: (_) {}, label: Text('Arkivert')),
    ],
  ),
)
```

Nar en komponent har bade en lokal `size`-parameter og en `DsSizeScope`-ancestor, har den lokale parameteren forrang. Nar ingen `DsSizeScope` er satt, brukes `DsSize.md` som standard.

---

## Typografi

Bibliotekets typografikomponenter folger Designsystemets typografisystem med Inter-fonten.

### DsHeading -- overskrifter

7 overskriftnivaer med fontvekt 500 og linjehoyde 1.3:

| Niva | Enum-verdi |
|------|-----------|
| 2xl (storst) | `DsHeadingLevel.xxl` |
| xl | `DsHeadingLevel.xl` |
| lg | `DsHeadingLevel.lg` |
| md | `DsHeadingLevel.md` |
| sm | `DsHeadingLevel.sm` |
| xs | `DsHeadingLevel.xs` |
| 2xs (minst) | `DsHeadingLevel.xxs` |

```dart
DsHeading(text: 'Hovedoverskrift', level: DsHeadingLevel.xl)
DsHeading(text: 'Underoverskrift', level: DsHeadingLevel.md)
DsHeading(text: 'Seksjonstittel', level: DsHeadingLevel.sm)
```

### DsParagraph -- brodtekst

5 storrelsesnivaer (xs--xl) i tre varianter med ulik linjehoyde:

| Variant | Linjehoyde | Bruksomrade |
|---------|-----------|-------------|
| `DsBodyVariant.standard` | 1.5 | Vanlig brodtekst |
| `DsBodyVariant.short` | 1.3 | Kompakt tekst, tabeller |
| `DsBodyVariant.long` | 1.7 | Lang lesbar tekst, artikler |

```dart
DsParagraph(
  text: 'Dette er vanlig brodtekst.',
  bodySize: DsBodySize.md,
  variant: DsBodyVariant.standard,
)

DsParagraph(
  text: 'Denne teksten er mer kompakt.',
  bodySize: DsBodySize.sm,
  variant: DsBodyVariant.short,
)
```

### DsLabel

Etikett for skjemaelementer:

```dart
DsLabel(text: 'E-postadresse', size: DsSize.md)
```

### DsValidationMessage

Valideringsmelding som vises under skjemafelt:

```dart
DsValidationMessage(text: 'E-postadressen er ugyldig')
```

---

## Skjemakomponenter

Designsystemets skjemakomponenter gir deg alt du trenger for a bygge tilgjengelige skjemaer.

### DsField og DsTextfield

`DsField` er en wrapper som gir etikett, beskrivelse og feilmelding rundt et inndatafelt:

```dart
DsField(
  label: 'E-postadresse',
  description: 'Vi deler ikke e-postadressen din med andre.',
  error: epostFeil, // null nar gyldig, feilmelding nar ugyldig
  child: DsTextfield(
    controller: epostController,
    error: epostFeil,
    keyboardType: TextInputType.emailAddress,
    onChanged: (verdi) => validerEpost(verdi),
  ),
)
```

### DsTextarea

For flerlinjes tekst:

```dart
DsField(
  label: 'Kommentar',
  child: DsTextarea(
    controller: kommentarController,
    maxLength: 500,
  ),
)
```

### DsCheckbox

Avkrysningsboks med stotte for ubestemt tilstand:

```dart
DsCheckbox(
  value: godkjent,
  onChanged: (verdi) => setState(() => godkjent = verdi),
  label: Text('Jeg godtar vilkarene'),
)

// Ubestemt tilstand (delvis valgt)
DsCheckbox(
  value: false,
  indeterminate: true,
  onChanged: (verdi) {},
  label: Text('Velg alle'),
)
```

### DsRadio

Radioknapp for enkeltvalg:

```dart
Column(
  children: [
    DsRadio(
      value: true,
      groupValue: valgtVerdi == 'ja',
      onChanged: (_) => setState(() => valgtVerdi = 'ja'),
      label: Text('Ja'),
    ),
    DsRadio(
      value: true,
      groupValue: valgtVerdi == 'nei',
      onChanged: (_) => setState(() => valgtVerdi = 'nei'),
      label: Text('Nei'),
    ),
  ],
)
```

### DsSwitch

Av/pa-bryter:

```dart
DsSwitch(
  value: varslingerAktivert,
  onChanged: (verdi) => setState(() => varslingerAktivert = verdi),
  label: Text('Aktiver varslinger'),
)
```

### DsButton

Knapp med tre varianter:

```dart
// Primaerknapp (solid fyll)
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () => send(),
  child: Text('Send inn'),
)

// Sekundaerknapp (kantlinje)
DsButton(
  variant: DsButtonVariant.secondary,
  onPressed: () => avbryt(),
  child: Text('Avbryt'),
)

// Tertiaerknapp (kun tekst)
DsButton(
  variant: DsButtonVariant.tertiary,
  onPressed: () => lesmer(),
  child: Text('Les mer'),
)

// Med ikon
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () => last(),
  icon: Icon(Icons.download),
  iconPosition: DsIconPosition.left,
  child: Text('Last ned'),
)

// Lastetilstand
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () {},
  loading: true,
  child: Text('Sender...'),
)

// Deaktivert
DsButton(
  variant: DsButtonVariant.primary,
  onPressed: () {},
  disabled: true,
  child: Text('Ikke tilgjengelig'),
)
```

### Validering og feiltilstander

Skjemakomponenter stotter feiltilstander gjennom `error`-parameteren:

```dart
class MittSkjema extends StatefulWidget {
  @override
  State<MittSkjema> createState() => _MittSkjemaState();
}

class _MittSkjemaState extends State<MittSkjema> {
  final _navnController = TextEditingController();
  final _epostController = TextEditingController();
  String? _navnFeil;
  String? _epostFeil;

  void _valider() {
    setState(() {
      _navnFeil = _navnController.text.isEmpty ? 'Navn er pakrevd' : null;
      _epostFeil = _epostController.text.contains('@')
          ? null
          : 'Ugyldig e-postadresse';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DsField(
          label: 'Navn',
          error: _navnFeil,
          child: DsTextfield(
            controller: _navnController,
            error: _navnFeil,
          ),
        ),
        DsField(
          label: 'E-post',
          error: _epostFeil,
          child: DsTextfield(
            controller: _epostController,
            error: _epostFeil,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        DsButton(
          variant: DsButtonVariant.primary,
          onPressed: _valider,
          child: Text('Send inn'),
        ),
      ],
    );
  }
}
```

### DsFieldset

For a gruppere relaterte skjemaelementer:

```dart
DsFieldset(
  legend: 'Kontaktinformasjon',
  children: [
    DsField(
      label: 'Telefon',
      child: DsTextfield(controller: telefonController),
    ),
    DsField(
      label: 'E-post',
      child: DsTextfield(controller: epostController),
    ),
  ],
)
```

### DsErrorSummary

Viser en oppsummering av alle skjemafeil:

```dart
DsErrorSummary(
  errors: [
    DsErrorEntry(field: 'Navn', message: 'Navn er pakrevd'),
    DsErrorEntry(field: 'E-post', message: 'Ugyldig e-postadresse'),
  ],
)
```

---

## Visningskomponenter

### DsCard

Kort med valgfrie underseksjoner:

```dart
// Enkelt kort
DsCard(
  child: DsCardBlock(
    child: DsParagraph(text: 'Innhold i kortet.'),
  ),
)

// Kort med header, innhold og bunntekst
DsCard(
  child: Column(
    children: [
      DsCardHeader(child: DsHeading(text: 'Tittel', level: DsHeadingLevel.sm)),
      DsCardBlock(child: DsParagraph(text: 'Kortets innhold.')),
      DsCardFooter(child: DsButton(onPressed: () {}, child: Text('Handling'))),
    ],
  ),
)

// Klikkbart kort med skygge
DsCard(
  elevated: true,
  onTap: () => naviger(),
  child: DsCardBlock(
    child: DsParagraph(text: 'Klikk pa dette kortet.'),
  ),
)
```

### DsAlert

Varselboks med fire alvorlighetsgrader:

```dart
DsAlert(
  severity: DsSeverity.info,
  title: Text('Informasjon'),
  child: Text('Dette er en informasjonsmelding.'),
)

DsAlert(
  severity: DsSeverity.warning,
  title: Text('Advarsel'),
  child: Text('Vaer oppmerksom pa dette.'),
)

DsAlert(
  severity: DsSeverity.success,
  title: Text('Suksess'),
  child: Text('Operasjonen var vellykket.'),
)

DsAlert(
  severity: DsSeverity.danger,
  title: Text('Feil'),
  closable: true,
  onClose: () => skjulVarsel(),
  child: Text('Noe gikk galt.'),
)
```

### DsTag og DsChip

Etiketter for kategorisering og filtrering:

```dart
// Tag
DsTag(
  child: Text('Ny'),
  color: DsColor.success,
  size: DsSize.sm,
)

// Chip
DsChip(
  child: Text('Flutter'),
  selected: true,
  onSelected: (valgt) => oppdater(valgt),
)
```

### DsBadge

Merke for telling eller status:

```dart
DsBadge(
  child: Text('3'),
  color: DsColor.danger,
)
```

### DsTabs

Fanenavigasjon med tastaturstotte (roving focus):

```dart
DsTabs(
  tabs: [
    DsTab(label: Text('Oversikt'), child: OversiktPanel()),
    DsTab(label: Text('Detaljer'), child: DetaljerPanel()),
    DsTab(label: Text('Historikk'), child: HistorikkPanel()),
  ],
)
```

### DsTable

Datatabell:

```dart
DsTable(
  columns: [
    DsTableColumn(header: Text('Navn')),
    DsTableColumn(header: Text('E-post')),
    DsTableColumn(header: Text('Rolle')),
  ],
  rows: brukere.map((bruker) => DsTableRow(
    cells: [
      Text(bruker.navn),
      Text(bruker.epost),
      Text(bruker.rolle),
    ],
  )).toList(),
)
```

### DsPagination

Sidenavigasjon:

```dart
DsPagination(
  currentPage: gjeldendeSide,
  totalPages: totalSider,
  onPageChanged: (side) => setState(() => gjeldendeSide = side),
)
```

---

## Navigasjonskomponenter

### DsDialog

Dialogvindu (modal):

```dart
DsDialog(
  title: Text('Bekreft sletting'),
  child: Text('Er du sikker pa at du vil slette dette elementet?'),
  actions: [
    DsButton(
      variant: DsButtonVariant.secondary,
      onPressed: () => Navigator.pop(context),
      child: Text('Avbryt'),
    ),
    DsButton(
      variant: DsButtonVariant.primary,
      color: DsColor.danger,
      onPressed: () => slett(),
      child: Text('Slett'),
    ),
  ],
)
```

### DsDropdown og DsSelect

Nedtrekksmeny og velger:

```dart
// Dropdown
DsDropdown(
  trigger: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () {},
    child: Text('Handlinger'),
  ),
  items: [
    DsDropdownItem(child: Text('Rediger'), onTap: () => rediger()),
    DsDropdownItem(child: Text('Kopier'), onTap: () => kopier()),
    DsDropdownItem(child: Text('Slett'), onTap: () => slett()),
  ],
)

// Select
DsSelect(
  label: 'Fylke',
  items: fylker.map((f) => DsSelectItem(value: f.id, label: f.navn)).toList(),
  value: valgtFylke,
  onChanged: (verdi) => setState(() => valgtFylke = verdi),
)
```

### DsBreadcrumbs

Brodsmulessti:

```dart
DsBreadcrumbs(
  items: [
    DsBreadcrumbItem(label: Text('Hjem'), onTap: () => gaTilHjem()),
    DsBreadcrumbItem(label: Text('Tjenester'), onTap: () => gaTilTjenester()),
    DsBreadcrumbItem(label: Text('Soknad')), // Gjeldende side, ingen onTap
  ],
)
```

### DsSearch

Sokefelt:

```dart
DsSearch(
  controller: sokeController,
  onSubmitted: (sokeord) => sok(sokeord),
  placeholder: 'Sok etter tjenester...',
)
```

### DsTooltip og DsPopover

Verktoyshjelp og innholdsboble:

```dart
// Tooltip
DsTooltip(
  message: 'Dette er et hjelpetekst',
  child: Icon(Icons.info_outline),
)

// Popover med rikt innhold
DsPopover(
  trigger: DsButton(
    variant: DsButtonVariant.secondary,
    onPressed: () {},
    child: Text('Vis detaljer'),
  ),
  child: Column(
    children: [
      DsHeading(text: 'Detaljer', level: DsHeadingLevel.xs),
      DsParagraph(text: 'Her er mer informasjon.'),
    ],
  ),
)
```

### DsAvatar og DsAvatarStack

Avatarbilder:

```dart
// Enkelt avatar
DsAvatar(
  child: Text('ON'),
  size: DsSize.md,
)

// Stablet gruppe
DsAvatarStack(
  avatars: [
    DsAvatar(child: Text('AB')),
    DsAvatar(child: Text('CD')),
    DsAvatar(child: Text('EF')),
  ],
  maxVisible: 3,
)
```

### Andre komponenter

```dart
// ToggleGroup -- vekslegruppe
DsToggleGroup(
  items: [
    DsToggleItem(value: 'liste', child: Text('Liste')),
    DsToggleItem(value: 'rutenett', child: Text('Rutenett')),
  ],
  value: visning,
  onChanged: (verdi) => setState(() => visning = verdi),
)

// Suggestion -- forslagskomponent
DsSuggestion(
  controller: sokeController,
  suggestions: forslag,
  onSelected: (valgt) => brukForslag(valgt),
)

// Details -- sammenleggbar seksjon
DsDetails(
  summary: Text('Vis mer informasjon'),
  child: DsParagraph(text: 'Her er den skjulte informasjonen.'),
)

// List -- stilisert liste
DsList(
  items: [
    Text('Forste element'),
    Text('Andre element'),
    Text('Tredje element'),
  ],
)

// Skeleton -- lasteindikator
DsSkeleton(
  width: 200,
  height: 20,
)

// SkipLink -- hopp-til-innhold
DsSkipLink(
  label: 'Hopp til hovedinnhold',
  targetId: 'hovedinnhold',
)

// Spinner -- lastespinner
DsSpinner(size: DsSize.md)

// Divider -- skillelinje
DsDivider()

// Link -- lenke
DsLink(
  text: 'Les mer om Designsystemet',
  onTap: () => apneLenke(),
)
```

---

## Kodegenerator

Biblioteket inkluderer en kodegenerator som lar deg importere egendefinerte temaer fra Designsystemet CLI.

### Forutsetninger

Du trenger `@digdir/designsystemet` CLI installert (krever Node.js):

```bash
npx @digdir/designsystemet --version
```

### Steg 1: Opprett konfigurasjon

Opprett `designsystemet.config.json` med dine merkevareverdier:

```json
{
  "$schema": "node_modules/@digdir/designsystemet/dist/config.schema.json",
  "outDir": "./design-tokens",
  "themes": {
    "min-organisasjon": {
      "colors": {
        "main": { "primary": "#0062BA", "accent": "#1E98F5" },
        "neutral": "#1E2B3C",
        "support": { "extra1": "#F45F63", "extra2": "#E5AA20" }
      },
      "borderRadius": 4,
      "typography": { "fontFamily": "Inter" }
    }
  }
}
```

### Steg 2: Generer designtokens

```bash
npx @digdir/designsystemet tokens create --config designsystemet.config.json
```

Dette oppretter en `design-tokens/`-mappe med W3C DTCG-format JSON-filer.

### Steg 3: Generer Dart-temafil

```bash
dart run komponentbibliotek_flutter:generate \
  --tokens-dir ./design-tokens \
  --output lib/generated/
```

### Steg 4: Bruk det genererte temaet

```dart
import 'package:min_app/generated/ds_theme_min_organisasjon.dart';

void main() {
  runApp(
    DsTheme(
      data: DsThemeMinOrganisasjon.light(),
      child: const MinApp(),
    ),
  );
}
```

Den genererte temafilen inneholder bade `light()` og `dark()` fabrikkmetoder.

### Avslutningskoder

| Kode | Betydning |
|------|-----------|
| 0 | Suksess |
| 1 | Ugyldige argumenter |
| 2 | Token-mappe ikke funnet eller tom |
| 3 | JSON-parsefeil i tokenfiler |

---

## Tilgjengelighet

Alle komponenter i biblioteket er designet med universell utforming som grunnprinsipp, i trad med Designsystemets krav og norsk lovgivning.

### Fargekontrast

Fargesystemets tokens garanterer WCAG 2.1 AA-kontrast:

- `textDefault`: minst 4.5:1 kontrast mot alle bakgrunns- og overflatefarger
- `textSubtle`: minst 4.5:1 mot bakgrunn og standard overflate
- `borderDefault`: minst 3:1 mot bakgrunner og standard overflater
- `baseContrastDefault`: minst 4.5:1 mot `baseDefault` og `baseHover`

### Semantikk

Alle interaktive komponenter inkluderer riktige `Semantics`-widgeter:

- Knapper har `button`-semantikk
- Tekstfelt har `textField`-semantikk
- Avkrysningsbokser har `checked`-semantikk
- Deaktiverte komponenter markeres med `enabled: false`

### Tastaturnavigasjon

- Alle interaktive komponenter er fokuserbare med Tab
- Fokusindikatorer bruker `borderStrong`-fargen med tilstrekkelig kontrast
- Fanegrupper, radiogrupper og vekslegrupper implementerer roving focus (piltaster)
- Dialoger fanger fokus innenfor dialogen

### Bevegelsesreduksjon

Komponenter respekterer `MediaQuery.disableAnimations` og demper animasjoner for brukere som foretrekker redusert bevegelse.

### Beste praksis

1. Bruk alltid `DsField` rundt tekstfelt for a koble etikett og feilmelding korrekt
2. Gi beskrivende etiketter til alle skjemaelementer
3. Bruk `DsErrorSummary` for a vise en oppsummering av skjemafeil
4. Test med skjermleser pa malplattformen
5. Test tastaturnavigasjon gjennom hele skjemaet
6. Bruk `DsSkipLink` for a la brukere hoppe over navigasjonen

---

## Plattformstotte

Biblioteket stotter alle plattformer som Flutter stotter:

| Plattform | Status |
|-----------|--------|
| Android | Full stotte |
| iOS | Full stotte |
| Web | Full stotte |
| macOS | Full stotte |
| Linux | Full stotte |
| Windows | Full stotte |

### Plattformspesifikke hensyn

- **Inter-font**: Levert som pakkeressurs (TTF-filer). Ingen nettverkstilgang kreves.
- **Hover-effekter**: Bruker `MouseRegion` som kun aktiveres pa pekerenheter, ikke beroring.
- **Fokusindikatorer**: Tilpasset plattformens fokuskonvensjoner.
- **Minste Flutter-versjon**: 3.19+ (kreves for Dart 3.3-funksjoner som monstermatching og forseglede klasser).
