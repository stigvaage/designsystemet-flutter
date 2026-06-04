import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// An avatar that displays initials derived from [name], or an image loaded
/// from [imageUrl] with an initials fallback.
///
/// The [variant] controls the shape: [DsAvatarVariant.circle] renders a
/// circular avatar, while [DsAvatarVariant.square] renders a rounded square.
class DsAvatar extends StatelessWidget {
  const DsAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size,
    this.color,
    this.variant = DsAvatarVariant.circle,
  });

  final String? name;
  final String? imageUrl;
  final DsSize? size;
  final DsColor? color;
  final DsAvatarVariant variant;

  String get _initials {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return '?';
    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final dimension = switch (sizeMode) {
      DsSize.sm => 32.0,
      DsSize.md => 40.0,
      DsSize.lg => 48.0,
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 12.0,
      DsSize.md => 14.0,
      DsSize.lg => 16.0,
    };
    final isSquare = variant == DsAvatarVariant.square;
    final shape = isSquare ? BoxShape.rectangle : BoxShape.circle;
    final borderRadius = isSquare
        ? BorderRadius.circular(theme.borderRadius.defaultRadius)
        : null;

    Widget initialsWidget() => Text(
      _initials,
      style: TextStyle(
        fontFamily: theme.typography.fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: colorScale.textDefault,
      ),
    );

    return Semantics(
      label: name ?? 'Profilbilde',
      image: true,
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: borderRadius,
          color: colorScale.surfaceTinted,
        ),
        foregroundDecoration: BoxDecoration(
          shape: shape,
          borderRadius: borderRadius,
          border: Border.all(color: colorScale.borderSubtle, width: 1),
        ),
        alignment: Alignment.center,
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(dimension),
                child: Image.network(
                  imageUrl!,
                  width: dimension,
                  height: dimension,
                  fit: BoxFit.cover,
                  frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return initialsWidget();
                  },
                  errorBuilder: (_, _, _) => initialsWidget(),
                ),
              )
            : initialsWidget(),
      ),
    );
  }
}
