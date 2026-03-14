import 'package:flutter/widgets.dart';
import '../theme/ds_color_scope.dart';
import '../theme/ds_theme.dart';
import '../theme/ds_typography.dart';
import '../utils/ds_enums.dart';

/// Heading text component using Designsystemet typography tokens.
class DsHeading extends StatelessWidget {
  const DsHeading({
    super.key,
    required this.text,
    this.level = DsHeadingLevel.md,
    this.size,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final DsHeadingLevel level;
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

    final style = _resolveStyle(theme.typography).copyWith(
      color: colorScale.textDefault,
    );

    return Semantics(
      header: true,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  TextStyle _resolveStyle(DsTypography typography) {
    return switch (level) {
      DsHeadingLevel.xxl => typography.heading2xl,
      DsHeadingLevel.xl => typography.headingXl,
      DsHeadingLevel.lg => typography.headingLg,
      DsHeadingLevel.md => typography.headingMd,
      DsHeadingLevel.sm => typography.headingSm,
      DsHeadingLevel.xs => typography.headingXs,
      DsHeadingLevel.xxs => typography.heading2xs,
    };
  }
}
