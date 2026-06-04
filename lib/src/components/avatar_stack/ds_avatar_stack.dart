import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// Displays a horizontal stack of overlapping avatar widgets.
///
/// Renders up to [maxVisible] children with a configurable [overlap] offset.
/// When the number of [children] exceeds [max], the remaining avatars collapse
/// into a circular «+N» overflow indicator that is appended to the stack.
///
/// The [size] controls the per-avatar dimension (matching [DsSize]: sm = 32,
/// md = 40, lg = 48) and drives both the stack height and the horizontal step
/// between avatars. The size is also propagated to descendant avatars via a
/// [DsSizeScope] so children without an explicit size match the stack.
///
/// The whole stack is exposed as a single semantics group with a Norwegian
/// summary («N brukere»).
class DsAvatarStack extends StatelessWidget {
  const DsAvatarStack({
    super.key,
    required this.children,
    this.maxVisible = 5,
    this.max,
    this.overlap = 8,
    this.size,
  });

  /// The avatar widgets to display in the stack.
  final List<Widget> children;

  /// The maximum number of avatar widgets to render before truncating.
  final int maxVisible;

  /// The maximum number of avatars to show before collapsing the rest into a
  /// «+N» overflow indicator.
  ///
  /// When null, [maxVisible] is used as the effective limit and no overflow
  /// indicator is rendered. When set and the number of [children] exceeds
  /// [max], the first [max] avatars are shown followed by a «+N» chip counting
  /// the hidden avatars.
  final int? max;

  /// The number of logical pixels each avatar overlaps the previous one.
  final double overlap;

  /// The size of each avatar, controlling both the stack height and the
  /// horizontal step between avatars. Falls back to the inherited [DsSizeScope].
  final DsSize? size;

  @override
  Widget build(BuildContext context) {
    final sizeMode = size ?? DsSizeScope.of(context);
    final dimension = sizeMode.pick(sm: 32.0, md: 40.0, lg: 48.0);
    final step = dimension - overlap;

    // Determine how many avatars to render and whether an overflow chip is
    // needed. [max] (when set) takes precedence and reserves a slot for the
    // «+N» indicator; otherwise [maxVisible] caps the list without overflow.
    final total = children.length;
    final hasOverflow = max != null && total > max!;
    final visibleCount = hasOverflow
        ? max!
        : (total < maxVisible ? total : maxVisible);
    final visible = children.take(visibleCount).toList();
    final overflowCount = total - visibleCount;

    final items = <Widget>[
      for (var i = 0; i < visible.length; i++)
        Positioned(left: i * step, child: visible[i]),
    ];
    if (hasOverflow) {
      items.add(
        Positioned(
          left: visible.length * step,
          child: _OverflowIndicator(
            count: overflowCount,
            dimension: dimension,
            fontSize: sizeMode.pick(sm: 12.0, md: 14.0, lg: 16.0),
          ),
        ),
      );
    }

    return Semantics(
      container: true,
      label: '$total brukere',
      child: DsSizeScope(
        size: sizeMode,
        child: SizedBox(
          height: dimension,
          child: Stack(clipBehavior: Clip.none, children: items),
        ),
      ),
    );
  }
}

/// A circular «+N» chip shown when avatars overflow the stack.
///
/// Styled like a neutral [DsAvatar] using theme tokens so it visually matches
/// the surrounding avatars.
class _OverflowIndicator extends StatelessWidget {
  const _OverflowIndicator({
    required this.count,
    required this.dimension,
    required this.fontSize,
  });

  final int count;
  final double dimension;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final colorScale = theme.colorScheme.resolve(DsColorScope.of(context));

    return Semantics(
      label: '+$count flere',
      child: Container(
        width: dimension,
        height: dimension,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScale.surfaceTinted,
        ),
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorScale.borderSubtle, width: 1),
        ),
        child: Text(
          '+$count',
          style: TextStyle(
            fontFamily: theme.typography.fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: colorScale.textDefault,
          ),
        ),
      ),
    );
  }
}
