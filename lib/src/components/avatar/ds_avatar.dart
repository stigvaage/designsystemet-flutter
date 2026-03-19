import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsAvatar extends StatelessWidget {
  const DsAvatar({super.key, this.name, this.imageUrl, this.size, this.color});

  final String? name;
  final String? imageUrl;
  final DsSize? size;
  final DsColor? color;

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
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
          shape: BoxShape.circle,
          color: colorScale.surfaceTinted,
        ),
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorScale.borderSubtle, width: 1),
        ),
        alignment: Alignment.center,
        child: imageUrl != null
            ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: dimension,
                  height: dimension,
                  fit: BoxFit.cover,
                  frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return initialsWidget();
                  },
                  errorBuilder: (_, __, ___) => initialsWidget(),
                ),
              )
            : initialsWidget(),
      ),
    );
  }
}
