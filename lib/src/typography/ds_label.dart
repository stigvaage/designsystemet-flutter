import 'package:flutter/widgets.dart';
import '../theme/ds_color_scope.dart';
import '../theme/ds_size_scope.dart';
import '../theme/ds_theme.dart';
import '../utils/ds_enums.dart';

/// Label text component using Designsystemet typography tokens.
///
/// Used for form field labels and other short descriptive text.
class DsLabel extends StatelessWidget {
  const DsLabel({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.weight,
  });

  final String text;
  final DsSize? size;
  final DsColor? color;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final sizeMode = size ?? DsSizeScope.of(context);

    final baseStyle = switch (sizeMode) {
      DsSize.sm => theme.typography.bodyMd,
      DsSize.md => theme.typography.bodyLg,
      DsSize.lg => theme.typography.bodyXl,
    };

    final style = baseStyle.copyWith(
      color: colorScale.textDefault,
      fontWeight: weight ?? FontWeight.w500,
    );

    return Text(text, style: style);
  }
}
