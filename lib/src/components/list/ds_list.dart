import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// An ordered or unordered list of items with bullet or number markers.
class DsList extends StatelessWidget {
  const DsList({
    super.key,
    required this.items,
    this.ordered = false,
    this.color,
  });

  final List<Widget> items;
  final bool ordered;
  final DsColor? color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    // Group the items under a single semantics container with the `list`
    // role so skjermlesere annonserer strukturen som en liste. The `list`
    // role requires no parent role, so it is safe to apply directly here.
    return Semantics(
      container: true,
      role: SemanticsRole.list,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++)
            Semantics(
              role: SemanticsRole.listItem,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The bullet/number marker is rein dekorasjon; exclude it
                    // from the semantics tree so skjermlesere ikke leser opp
                    // «•» eller «1.» som innhold. A minimum width keeps single-
                    // digit markers aligned while allowing flersifrede ordnede
                    // markører to render on one line uten å brekke raden.
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 24),
                      child: ExcludeSemantics(
                        child: Text(
                          ordered ? '${i + 1}.' : '•',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: theme.typography.bodyMd.copyWith(
                            color: colorScale.textDefault,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.typography.bodyMd.copyWith(
                          color: colorScale.textDefault,
                        ),
                        child: items[i],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
