import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_typography.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';

/// En brødsmulesti (navigasjon) med lenker adskilt av et chevron-ikon.
///
/// Alle elementene unntatt det siste vises som klikkbare, fokuserbare lenker
/// med understreking. Det siste elementet representerer gjeldende side: det er
/// fortsatt en fokuserbar lenke (`aria-current="page"`), men uten understreking,
/// i tråd med det offisielle Designsystemet.
///
/// Stien brytes over flere linjer ([Wrap]) når bredden er begrenset, slik som
/// det offisielle `<ol>` med `flex-wrap: wrap`.
class DsBreadcrumbs extends StatelessWidget {
  const DsBreadcrumbs({
    super.key,
    required this.items,
    this.onItemTap,
    this.color,
    this.ariaLabel = 'Du er her:',
  });

  /// Etikettene i brødsmulestien. Det siste elementet er gjeldende side.
  final List<String> items;

  /// Kalles med indeksen til elementet når en lenke aktiveres.
  final ValueChanged<int>? onItemTap;

  /// Fargetema. Arver fra nærmeste [DsColorScope] hvis utelatt.
  final DsColor? color;

  /// Tilgjengelig etikett for navigasjonslandemerket (React Breadcrumbs
  /// `aria-label`). Standard er `'Du er her:'`, i tråd med den offisielle
  /// norske standardverdien (`--dsc-breadcrumbs-label`).
  final String ariaLabel;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Semantics(
      label: ariaLabel,
      // Group the trail as a single navigation landmark/list container so
      // assistive technology announces it as one region (React `<nav><ol>`).
      container: true,
      explicitChildNodes: true,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              // Chevron-skille mellom elementene, slik som det offisielle
              // `--dsc-breadcrumbs-icon-url` (en høyrepekende chevron) i farge
              // text-subtle og størrelse `--ds-size-6`. Dekorativt, derfor
              // ekskludert fra semantikk.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.sizeTokens.size2,
                ),
                child: ExcludeSemantics(
                  child: Icon(
                    DsIcons.chevronRight,
                    size: theme.sizeTokens.size6,
                    color: colorScale.textSubtle,
                  ),
                ),
              ),
            if (i < items.length - 1)
              Semantics(
                link: true,
                // Positional hint within the trail (e.g. "Steg 1 av 3").
                hint: 'Steg ${i + 1} av ${items.length}',
                child: _DsBreadcrumbLink(
                  label: items[i],
                  typography: theme.typography,
                  colorScale: colorScale,
                  underline: true,
                  onTap: () => onItemTap?.call(i),
                ),
              )
            else
              // The last item is the current page (aria-current="page"). Per the
              // official spec it is still a focusable link in the tab order, but
              // visually un-underlined and rendered in text-subtle.
              Semantics(
                link: true,
                hint: 'Gjeldende side',
                child: _DsBreadcrumbLink(
                  label: items[i],
                  typography: theme.typography,
                  colorScale: colorScale,
                  underline: false,
                  current: true,
                  onTap: () => onItemTap?.call(i),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// A single tappable breadcrumb link.
///
/// Tracks keyboard focus so it can render a visible focus indicator
/// ([DsFocus.reserveRing]) when focused, satisfying WCAG 2.4.7. The ring space
/// is always reserved to prevent layout shift between the focused and
/// unfocused states (matching the [DsButton] pattern).
///
/// As a link-role control it activates on `Enter` only — not `Space` — which
/// matches native hyperlink behaviour (`Space` is reserved for scrolling and
/// for activating button-role controls). This is the shared convention for all
/// link-role widgets in the library.
class _DsBreadcrumbLink extends StatefulWidget {
  const _DsBreadcrumbLink({
    required this.label,
    required this.typography,
    required this.colorScale,
    required this.onTap,
    this.underline = true,
    this.current = false,
  });

  final String label;
  final DsTypography typography;
  final DsColorScale colorScale;
  final VoidCallback onTap;

  /// Whether the link text is underlined. The current-page link is not
  /// underlined, matching the official `li:last-child a` rule.
  final bool underline;

  /// Whether this link represents the current page (`aria-current="page"`).
  final bool current;

  @override
  State<_DsBreadcrumbLink> createState() => _DsBreadcrumbLinkState();
}

class _DsBreadcrumbLinkState extends State<_DsBreadcrumbLink> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScale = widget.colorScale;

    return Focus(
      onFocusChange: (f) => setState(() => _isFocused = f),
      onKeyEvent: (node, event) {
        // Link-role convention: activate on Enter only (not Space), matching
        // native hyperlinks and the other link-role widgets in the library.
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: DsFocus.reserveRing(
            focused: _isFocused,
            radius: BorderRadius.circular(DsFocus.ringOffset),
            scale: colorScale,
            child: Text(
              widget.label,
              style: widget.typography.bodySm.copyWith(
                color: widget.current
                    ? colorScale.textSubtle
                    : colorScale.textDefault,
                decoration: widget.underline
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
