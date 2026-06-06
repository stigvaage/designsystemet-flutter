import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// En hopp-til-innhold-lenke for tilgjengelighet som kun er synlig ved fokus.
///
/// Lar tastaturbrukere hoppe forbi gjentakende navigasjon og rett til
/// hovedinnholdet, og oppfyller WCAG 2.1 suksesskriterium 2.4.1 (Hopp over
/// blokker). Lenken er skjult (via [Offstage]) inntil den får tastaturfokus,
/// slik at den ikke forstyrrer det visuelle oppsettet for musebrukere.
///
/// Den aktiveres med `Enter`, `Space` eller trykk og kaller da [onActivate],
/// som typisk flytter fokus eller ruller til målelementet. I motsetning til de
/// rene lenkerolle-komponentene ([DsLink], brødsmuler) aktiverer skip-lenken
/// bevisst også på `Space`, fordi den oppfører seg som en knapp som utfører en
/// handling på siden snarere enn å navigere til en URL.
///
/// Visuelt speiler den den offisielle `.ds-skip-link`-komponenten: en dempet
/// overflate ([DsColorScale.surfaceHover]) med standard tekstfarge
/// ([DsColorScale.textDefault]) og understreket tekst. En synlig fokusring
/// ([DsFocus.reserveRing]) vises ved tastaturnavigasjon.
class DsSkipLink extends StatefulWidget {
  const DsSkipLink({
    super.key,
    required this.label,
    required this.onActivate,
    this.color,
  });

  /// Teksten som vises i lenken; brukes også som Semantics-etikett.
  final String label;

  /// Kalles når lenken aktiveres med `Enter`, `Space` eller trykk. Flytt
  /// vanligvis fokus til (eller rull til) hovedinnholdet her.
  final VoidCallback onActivate;

  /// Overstyrer omkringliggende [DsColorScope]-farge. Som standard arves
  /// fargen fra scope-et ([DsColor.accent] hvis ingen er satt).
  final DsColor? color;

  @override
  State<DsSkipLink> createState() => _DsSkipLinkState();
}

class _DsSkipLinkState extends State<DsSkipLink> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final radius = BorderRadius.circular(theme.borderRadius.defaultRadius);

    return Semantics(
      link: true,
      label: widget.label,
      // Bind aktiveringen på den alltid tilstedeværende ytre noden, slik at
      // skjermlesere kan aktivere lenken selv mens den visuelle delen er
      // skjult bak [Offstage] (som fjernes fra semantikktreet).
      onTap: widget.onActivate,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onActivate();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: Offstage(
          offstage: !_isFocused,
          child: GestureDetector(
            onTap: widget.onActivate,
            child: DsFocus.reserveRing(
              focused: _isFocused,
              radius: radius,
              scale: colorScale,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScale.surfaceHover,
                  borderRadius: radius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    widget.label,
                    style: theme.typography.bodyMd.copyWith(
                      color: colorScale.textDefault,
                      decoration: TextDecoration.underline,
                      decorationColor: colorScale.textDefault,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
