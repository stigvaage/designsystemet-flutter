import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// A small label tag with a tinted background and subtle border.
///
/// The [variant] mirrors the React `data-variant` attribute:
/// [DsSelectionVariant.default_] renders a tinted fill with a subtle border,
/// while [DsSelectionVariant.outline] renders a transparent background with a
/// default border.
class DsTag extends StatelessWidget {
  const DsTag({
    super.key,
    required this.child,
    this.size,
    this.color,
    this.variant = DsSelectionVariant.default_,
  });

  final Widget child;
  final DsSize? size;
  final DsColor? color;

  /// The visual variant of the tag. Defaults to [DsSelectionVariant.default_].
  final DsSelectionVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final radius = BorderRadius.circular(theme.borderRadius.sm);

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    };

    final fontSize = switch (sizeMode) {
      DsSize.sm => 12.0,
      DsSize.md => 14.0,
      DsSize.lg => 16.0,
    };

    final backgroundColor = switch (variant) {
      DsSelectionVariant.default_ => colorScale.surfaceTinted,
      // transparent: border-only (uses Color(0x00000000) since this file
      // imports only widgets.dart, which has no Colors.transparent).
      DsSelectionVariant.outline => const Color(0x00000000),
    };

    final borderColor = switch (variant) {
      DsSelectionVariant.default_ => colorScale.borderSubtle,
      DsSelectionVariant.outline => colorScale.borderDefault,
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: DefaultTextStyle(
        style: theme.typography.bodyXs.copyWith(
          fontSize: fontSize,
          color: colorScale.textDefault,
        ),
        child: child,
      ),
    );
  }
}
