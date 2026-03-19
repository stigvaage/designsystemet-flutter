import 'package:flutter/widgets.dart';
import '../theme/ds_color_scope.dart';
import '../theme/ds_theme.dart';
import '../theme/ds_typography.dart';
import '../utils/ds_enums.dart';

/// Body text component using Designsystemet typography tokens.
class DsParagraph extends StatelessWidget {
  const DsParagraph({
    super.key,
    required this.text,
    this.bodySize = DsBodySize.md,
    this.variant = DsBodyVariant.standard,
    this.size,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final DsBodySize bodySize;
  final DsBodyVariant variant;
  final DsSize? size;
  final DsColor? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final style = _resolveStyle(
      theme.typography,
    ).copyWith(color: colorScale.textDefault);

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _resolveStyle(DsTypography typography) {
    return switch (variant) {
      DsBodyVariant.standard => switch (bodySize) {
        DsBodySize.xl => typography.bodyXl,
        DsBodySize.lg => typography.bodyLg,
        DsBodySize.md => typography.bodyMd,
        DsBodySize.sm => typography.bodySm,
        DsBodySize.xs => typography.bodyXs,
      },
      DsBodyVariant.short => switch (bodySize) {
        DsBodySize.xl => typography.bodyShortXl,
        DsBodySize.lg => typography.bodyShortLg,
        DsBodySize.md => typography.bodyShortMd,
        DsBodySize.sm => typography.bodyShortSm,
        DsBodySize.xs => typography.bodyShortXs,
      },
      DsBodyVariant.long => switch (bodySize) {
        DsBodySize.xl => typography.bodyLongXl,
        DsBodySize.lg => typography.bodyLongLg,
        DsBodySize.md => typography.bodyLongMd,
        DsBodySize.sm => typography.bodyLongSm,
        DsBodySize.xs => typography.bodyLongXs,
      },
    };
  }
}
