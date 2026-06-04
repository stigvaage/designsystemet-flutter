import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

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
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter) {
                      onItemTap?.call(i);
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onItemTap?.call(i),
                      child: Text(
                        items[i],
                        style: theme.typography.bodySm.copyWith(
                          color: colorScale.textDefault,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
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
