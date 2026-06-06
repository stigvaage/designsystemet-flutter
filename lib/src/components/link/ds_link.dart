import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// En tekstlenke med Designsystemet-styling.
///
/// Underlinjen vises alltid; ved peker-hover blir den tykkere og fargen går
/// fra dempet ([DsColorScale.textSubtle]) til standard ([DsColorScale.textDefault]),
/// slik den offisielle `.ds-link`-komponenten oppfører seg.
///
/// Lenken aktiveres med `Enter` (ikke `Space`), som speiler oppførselen til
/// native hyperlenker og de andre lenkerolle-komponentene i biblioteket. En
/// synlig fokusring ([DsFocus.reserveRing]) vises ved tastaturnavigasjon.
///
/// Når [onTap] er `null` er lenken ikke-interaktiv: den annonseres ikke som
/// lenke for skjermlesere, er ikke et tab-stopp og viser ingen fokusring.
class DsLink extends StatefulWidget {
  const DsLink({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.inverted = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// Lenketeksten som vises for brukeren; brukes også som Semantics-etikett.
  final String text;

  /// Kalles når lenken trykkes eller aktiveres med `Enter`. Når den er `null`
  /// er lenken ikke-interaktiv.
  final VoidCallback? onTap;

  /// Overstyrer omkringliggende [DsColorScope]-farge. Som standard arves
  /// fargen fra scope-et ([DsColor.accent] hvis ingen er satt).
  final DsColor? color;

  /// Portspesifikk utvidelse: når `true` brukes kontrastfargen
  /// ([DsColorScale.baseContrastDefault]) slik at lenken er lesbar på en
  /// sterk/farget bakgrunn. Inngår ikke i det offisielle Designsystemet-API-et
  /// (der håndteres farge via `data-color`/[DsColorScope]). Som standard `false`.
  final bool inverted;

  /// Valgfri [FocusNode] for å styre fokus programmatisk.
  final FocusNode? focusNode;

  /// Når `true` får lenken fokus automatisk når den vises. Som standard `false`.
  final bool autofocus;

  /// Underlinjetykkelse i hvilende tilstand (i logiske piksler).
  static const double _restingUnderlineThickness = 1.0;

  /// Underlinjetykkelse ved hover (i logiske piksler).
  static const double _hoverUnderlineThickness = 2.0;

  @override
  State<DsLink> createState() => _DsLinkState();
}

class _DsLinkState extends State<DsLink> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final interactive = widget.onTap != null;

    // Hvilende farge er dempet; ved hover går den til standard tekstfarge.
    // På farget bakgrunn brukes kontrastfargen i begge tilstander.
    final Color textColor;
    if (widget.inverted) {
      textColor = colorScale.baseContrastDefault;
    } else {
      textColor = (interactive && _isHovered)
          ? colorScale.textDefault
          : colorScale.textSubtle;
    }

    final textWidget = ExcludeSemantics(
      child: Text(
        widget.text,
        style: theme.typography.bodyMd.copyWith(
          color: textColor,
          decoration: TextDecoration.underline,
          decorationColor: textColor,
          decorationThickness: (interactive && _isHovered)
              ? DsLink._hoverUnderlineThickness
              : DsLink._restingUnderlineThickness,
        ),
      ),
    );

    return Semantics(
      link: interactive,
      label: widget.text,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: interactive,
        onKeyEvent: (node, event) {
          // Lenkerolle-konvensjon: aktiver kun på Enter (ikke Space), som
          // native hyperlenker og de andre lenkerolle-komponentene.
          if (interactive &&
              event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            widget.onTap!();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          onEnter: interactive
              ? (_) => setState(() => _isHovered = true)
              : null,
          onExit: interactive
              ? (_) => setState(() => _isHovered = false)
              : null,
          cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            onTap: widget.onTap,
            child: DsFocus.reserveRing(
              focused: _isFocused,
              radius: BorderRadius.circular(DsFocus.ringOffset),
              scale: colorScale,
              child: textWidget,
            ),
          ),
        ),
      ),
    );
  }
}
