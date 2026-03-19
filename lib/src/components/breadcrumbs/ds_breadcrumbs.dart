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
  });

  final List<String> items;
  final ValueChanged<int>? onItemTap;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Semantics(
      label: 'Brødsmulenavigasjon',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '/',
                  style: TextStyle(color: colorScale.textSubtle, fontSize: 14),
                ),
              ),
            if (i < items.length - 1)
              Semantics(
                link: true,
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
              Text(
                items[i],
                style: theme.typography.bodySm.copyWith(
                  color: colorScale.textSubtle,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
