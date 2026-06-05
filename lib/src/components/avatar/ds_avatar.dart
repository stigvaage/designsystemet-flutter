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
    this.semanticLabel,
  });

  /// The name used to derive the displayed initials and the default semantic
  /// label.
  final String? name;

  /// An optional image URL. When set, the image is loaded with an initials
  /// fallback while loading or on error.
  final String? imageUrl;

  /// The size of the avatar. Falls back to [DsSizeScope.of] when null.
  final DsSize? size;

  /// The color used for the avatar fill and text. Falls back to
  /// [DsColorScope.of] when null.
  final DsColor? color;

  /// The shape of the avatar; see [DsAvatarVariant].
  final DsAvatarVariant variant;

  /// An optional override for the accessibility label.
  ///
  /// Use this when the avatar image carries meaning (for example a company
  /// logo) and the [name]-based default is not descriptive enough. When null,
  /// the semantic label falls back to [name], or «Profilbilde» when [name] is
  /// also null.
  final String? semanticLabel;

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
        ? BorderRadius.circular(theme.borderRadius.sm)
        : null;

    // Det offisielle Designsystemet tegner kun en kant i forced-colors-modus
    // (høykontrast); i normal modus er avataren en solid, fylt brikke.
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    final foregroundDecoration = highContrast
        ? BoxDecoration(
            shape: shape,
            borderRadius: borderRadius,
            border: Border.all(color: colorScale.borderStrong, width: 1),
          )
        : null;

    Widget initialsWidget() => Text(
      _initials,
      style: TextStyle(
        fontFamily: theme.typography.fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: colorScale.baseContrastDefault,
      ),
    );

    return Semantics(
      label: semanticLabel ?? name ?? 'Profilbilde',
      image: true,
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: borderRadius,
          color: colorScale.baseDefault,
        ),
        foregroundDecoration: foregroundDecoration,
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
