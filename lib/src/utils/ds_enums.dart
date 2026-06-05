import 'package:flutter/widgets.dart' show FontWeight;

/// Størrelsesskala for komponenter (knapp, input, avkrysningsboks osv.).
///
/// Speiler Designsystemets `data-size`-verdier `'sm' | 'md' | 'lg'`. Brukes
/// til å velge størrelseskeyede token-verdier, ofte via [DsSizePick.pick].
enum DsSize {
  /// Liten størrelse (`sm`).
  sm,

  /// Mellomstor størrelse (`md`) — standard i de fleste komponenter.
  md,

  /// Stor størrelse (`lg`).
  lg,
}

/// Selects one of three size-keyed values based on this [DsSize].
///
/// A concise replacement for the repeated `switch (size)` blocks across
/// components: `size.pick(sm: 14.0, md: 16.0, lg: 18.0)` returns the value
/// matching the current size. Works for any type [T] (doubles, paddings,
/// widgets, etc.).
extension DsSizePick on DsSize {
  /// Returns [sm], [md] or [lg] depending on this [DsSize].
  T pick<T>({required T sm, required T md, required T lg}) => switch (this) {
    DsSize.sm => sm,
    DsSize.md => md,
    DsSize.lg => lg,
  };
}

/// Fargerolle for en komponent — velger hvilken fargeskala (`DsColorScale`)
/// komponenten løses mot via [DsColorScheme].
///
/// Forseglet klasse med ni navngitte roller (`accent`, `neutral`, `brand1-3`,
/// `success`, `danger`, `warning`, `info`) pluss [DsColorCustom] for
/// egendefinerte skalaer. Speiler Designsystemets `data-color`-attributt.
sealed class DsColor {
  /// Konstant konstruktør for underklassene.
  const DsColor();

  /// Aksentfargen — systemets primære interaktive farge.
  static const accent = DsColorAccent();

  /// Nøytral farge — grå skala for tekst, kanter og overflater.
  static const neutral = DsColorNeutral();

  /// Første merkevarefarge (`brand1`).
  static const brand1 = DsColorBrand1();

  /// Andre merkevarefarge (`brand2`).
  static const brand2 = DsColorBrand2();

  /// Tredje merkevarefarge (`brand3`).
  static const brand3 = DsColorBrand3();

  /// Suksessfarge — grønn skala for positiv tilbakemelding.
  static const success = DsColorSuccess();

  /// Farefarge — rød skala for feil og destruktive handlinger.
  static const danger = DsColorDanger();

  /// Advarselsfarge — gul/oransje skala for advarsler.
  static const warning = DsColorWarning();

  /// Informasjonsfarge — blå skala for nøytral informasjon.
  static const info = DsColorInfo();

  /// Returnerer en egendefinert fargerolle identifisert med [key].
  static DsColorCustom custom(String key) => DsColorCustom(key);
}

/// Aksentfargen — se [DsColor.accent].
class DsColorAccent extends DsColor {
  /// Oppretter aksentfargerollen.
  const DsColorAccent();
}

/// Nøytral farge — se [DsColor.neutral].
class DsColorNeutral extends DsColor {
  /// Oppretter den nøytrale fargerollen.
  const DsColorNeutral();
}

/// Første merkevarefarge — se [DsColor.brand1].
class DsColorBrand1 extends DsColor {
  /// Oppretter merkevarefargerollen `brand1`.
  const DsColorBrand1();
}

/// Andre merkevarefarge — se [DsColor.brand2].
class DsColorBrand2 extends DsColor {
  /// Oppretter merkevarefargerollen `brand2`.
  const DsColorBrand2();
}

/// Tredje merkevarefarge — se [DsColor.brand3].
class DsColorBrand3 extends DsColor {
  /// Oppretter merkevarefargerollen `brand3`.
  const DsColorBrand3();
}

/// Suksessfarge — se [DsColor.success].
class DsColorSuccess extends DsColor {
  /// Oppretter suksessfargerollen.
  const DsColorSuccess();
}

/// Farefarge — se [DsColor.danger].
class DsColorDanger extends DsColor {
  /// Oppretter farefargerollen.
  const DsColorDanger();
}

/// Advarselsfarge — se [DsColor.warning].
class DsColorWarning extends DsColor {
  /// Oppretter advarselsfargerollen.
  const DsColorWarning();
}

/// Informasjonsfarge — se [DsColor.info].
class DsColorInfo extends DsColor {
  /// Oppretter informasjonsfargerollen.
  const DsColorInfo();
}

/// En egendefinert fargerolle identifisert med en [key], for skalaer som
/// ikke er en av de ni innebygde rollene. Opprettes via [DsColor.custom].
class DsColorCustom extends DsColor {
  /// Nøkkelen som identifiserer den egendefinerte fargeskalaen.
  final String key;

  /// Oppretter en egendefinert fargerolle med nøkkelen [key].
  const DsColorCustom(this.key);
  @override
  bool operator ==(Object other) => other is DsColorCustom && other.key == key;
  @override
  int get hashCode => key.hashCode;
}

/// Alvorlighetsgrad for tilbakemeldingskomponenter (f.eks. `DsAlert`).
///
/// Speiler Designsystemets `data-color`-bruk for varsler.
enum DsSeverity {
  /// Informasjon — nøytral melding.
  info,

  /// Advarsel — krever oppmerksomhet, men ikke kritisk.
  warning,

  /// Suksess — bekrefter at en handling lyktes.
  success,

  /// Fare — feil eller kritisk tilstand.
  danger,
}

/// Skriftvekt for tekstkomponenter, avgrenset til vektene som finnes i
/// Designsystemet (og som leveres som Inter-fontfiler: 400/500/600).
///
/// Speiler den offisielle `weight`-egenskapen på `Label`
/// (`"regular" | "medium" | "semibold"`, standard `medium`). Bruk denne i
/// stedet for en rå [FontWeight] for å unngå vekter som ikke finnes i
/// systemet.
enum DsFontWeight {
  /// Vanlig vekt (`FontWeight.w400`).
  regular,

  /// Medium vekt (`FontWeight.w500`) — standard for etiketter.
  medium,

  /// Halvfet vekt (`FontWeight.w600`).
  semibold,
}

/// Konverterer en [DsFontWeight] til Flutters [FontWeight].
extension DsFontWeightValue on DsFontWeight {
  /// Returnerer [FontWeight] som svarer til denne [DsFontWeight].
  FontWeight toFontWeight() => switch (this) {
    DsFontWeight.regular => FontWeight.w400,
    DsFontWeight.medium => FontWeight.w500,
    DsFontWeight.semibold => FontWeight.w600,
  };
}

/// Visuell variant for `DsButton`. Speiler Designsystemets knappe-`variant`.
enum DsButtonVariant {
  /// Primær knapp — fylt, mest fremtredende handling.
  primary,

  /// Sekundær knapp — kantet/utlinjet, mindre fremtredende.
  secondary,

  /// Tertiær knapp — minimal, uten fyll eller kant.
  tertiary,
}

/// Hvor et ikon plasseres i forhold til knappeteksten.
enum DsIconPosition {
  /// Ikonet vises til venstre for teksten.
  left,

  /// Ikonet vises til høyre for teksten.
  right,
}

/// Overskriftsnivå for `DsHeading`, fra størst (`xxl`) til minst (`xxs`).
///
/// Speiler Designsystemets `Heading`-størrelser. Nivået styrer kun
/// typografien; semantisk overskriftsnivå settes separat.
enum DsHeadingLevel {
  /// Ekstra ekstra stor overskrift.
  xxl,

  /// Ekstra stor overskrift.
  xl,

  /// Stor overskrift.
  lg,

  /// Mellomstor overskrift.
  md,

  /// Liten overskrift.
  sm,

  /// Ekstra liten overskrift.
  xs,

  /// Ekstra ekstra liten overskrift.
  xxs,
}

/// Størrelse for brødtekst (`DsParagraph`/`DsBody`).
enum DsBodySize {
  /// Ekstra stor brødtekst.
  xl,

  /// Stor brødtekst.
  lg,

  /// Mellomstor brødtekst — standard.
  md,

  /// Liten brødtekst.
  sm,

  /// Ekstra liten brødtekst.
  xs,
}

/// Linjeavstandsvariant for brødtekst.
enum DsBodyVariant {
  /// Standard linjeavstand.
  standard,

  /// Kompakt linjeavstand for korte tekster.
  short,

  /// Romslig linjeavstand for lange, lesetunge tekster.
  long,
}

/// Hvilket hjørne et merke (`DsBadge`) plasseres i over verts-widgeten.
enum DsBadgePlacement {
  /// Øverst til høyre.
  topRight,

  /// Øverst til venstre.
  topLeft,

  /// Nederst til høyre.
  bottomRight,

  /// Nederst til venstre.
  bottomLeft,
}

/// Visuell variant for `DsBadge`.
enum DsBadgeVariant {
  /// Fylt merke med solid bakgrunn.
  base,

  /// Tonet merke med dempet bakgrunn.
  tinted,
}

/// Form på et lasteskjelett (`DsSkeleton`).
enum DsSkeletonVariant {
  /// Tekstlinje-plassholder.
  text,

  /// Sirkulær plassholder (f.eks. avatar).
  circle,

  /// Rektangulær plassholder.
  rectangle,
}

/// Visuell variant for `DsCard`. Speiler Designsystemets Card-`data-variant`
/// (`'default' | 'tinted'`).
enum DsCardVariant {
  /// Standard kort med overflatebakgrunn.
  default_,

  /// Tonet kort med dempet bakgrunn.
  tinted,
}

/// Visuell variant for `DsDetails`. Speiler Designsystemets
/// Details-`data-variant` (`'default' | 'tinted'`).
enum DsDetailsVariant {
  /// Standard utvidbart panel.
  default_,

  /// Tonet utvidbart panel.
  tinted,
}

/// Visuell variant for `DsToggleGroup`. Speiler Designsystemets
/// ToggleGroup-`variant` (`'primary' | 'secondary'`).
enum DsToggleGroupVariant {
  /// Primær variant.
  primary,

  /// Sekundær variant.
  secondary,
}

/// Delt valg-variant for `DsTag`/`DsSwitch`/`DsCheckbox`/`DsRadio`. Speiler
/// Designsystemets `data-variant`, der `outline` gir en utlinjet visning og
/// standard (udefinert i React) gir den fylte visningen.
enum DsSelectionVariant {
  /// Standard, fylt visning.
  default_,

  /// Utlinjet visning med kant rundt kontrollen.
  outline,
}

/// Form på en avatar (`DsAvatar`). Speiler Designsystemets Avatar-`data-variant`
/// (`'circle' | 'square'`).
enum DsAvatarVariant {
  /// Sirkulær avatar.
  circle,

  /// Kvadratisk avatar (med avrundede hjørner).
  square,
}

/// Plassering av et overlegg (Popover/Tooltip/Dialog) i forhold til ankeret.
///
/// Speiler floating-ui sin `Placement` som brukes av React-egenskapen
/// `placement`. `Start`/`End`-variantene justerer overlegget mot ankerets
/// start- eller sluttkant langs den vinkelrette aksen.
enum DsPlacement {
  /// Over ankeret, midtstilt.
  top,

  /// Over ankeret, justert mot startkanten.
  topStart,

  /// Over ankeret, justert mot sluttkanten.
  topEnd,

  /// Til høyre for ankeret, midtstilt.
  right,

  /// Til høyre for ankeret, justert mot toppen.
  rightStart,

  /// Til høyre for ankeret, justert mot bunnen.
  rightEnd,

  /// Under ankeret, midtstilt.
  bottom,

  /// Under ankeret, justert mot startkanten.
  bottomStart,

  /// Under ankeret, justert mot sluttkanten.
  bottomEnd,

  /// Til venstre for ankeret, midtstilt.
  left,

  /// Til venstre for ankeret, justert mot toppen.
  leftStart,

  /// Til venstre for ankeret, justert mot bunnen.
  leftEnd,
}

/// Visuell variant for `DsPopover`. Speiler Designsystemets
/// Popover-`data-variant` (`'default' | 'tinted'`).
enum DsPopoverVariant {
  /// Standard popover med overflatebakgrunn.
  default_,

  /// Tonet popover med dempet bakgrunn.
  tinted,
}

/// Sorteringstilstand for en sorterbar tabellkolonne, speiler React-attributtet
/// `aria-sort`.
enum DsSortDirection {
  /// Ingen sortering — nøytral indikator (`aria-sort="none"`).
  none,

  /// Stigende sortering (`aria-sort="ascending"`).
  ascending,

  /// Synkende sortering (`aria-sort="descending"`).
  descending,

  /// Sortert etter et ikke-monotont kriterium (`aria-sort="other"`). Finnes
  /// for `aria-sort`-paritet med Designsystemet og tegner med vilje
  /// ingen-indikator-visningen — det er ikke en uimplementert tilstand.
  other,
}
