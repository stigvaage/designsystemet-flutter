import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_typography.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A breadcrumb navigation trail with slash-separated links.
///
/// All items except the last are rendered as tappable links with underlines.
class DsBreadcrumbs extends StatelessWidget {
  const DsBreadcrumbs({
    super.key,
    required this.items,
    this.onItemTap,
    this.color,
    this.ariaLabel = 'Brødsmulenavigasjon',
  });

  final List<String> items;
  final ValueChanged<int>? onItemTap;
  final DsColor? color;

  /// Accessible label for the navigation landmark (React Breadcrumbs
  /// `aria-label`). Defaults to `'Brødsmulenavigasjon'`.
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '/',
                  style: theme.typography.bodySm.copyWith(
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
                  onTap: () => onItemTap?.call(i),
                ),
              )
            else
              // The last item is the current page (aria-current="page").
              Semantics(
                label: items[i],
                hint: 'Gjeldende side',
                child: ExcludeSemantics(
                  child: Text(
                    items[i],
                    style: theme.typography.bodySm.copyWith(
                      color: colorScale.textSubtle,
                    ),
                  ),
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
  });

  final String label;
  final DsTypography typography;
  final DsColorScale colorScale;
  final VoidCallback onTap;

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
                color: colorScale.textDefault,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
