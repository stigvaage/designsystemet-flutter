import 'package:flutter/widgets.dart';

import '../../theme/ds_theme.dart';

class DsErrorSummary extends StatelessWidget {
  const DsErrorSummary({
    super.key,
    required this.errors,
    this.title,
    this.onErrorTap,
  });

  final List<String> errors;
  final String? title;
  final ValueChanged<int>? onErrorTap;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final dangerScale = theme.colorScheme.danger;

    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: dangerScale.surfaceTinted,
          borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
          border: Border.all(color: dangerScale.borderDefault, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Errors',
              style: theme.typography.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: dangerScale.textDefault,
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < errors.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: GestureDetector(
                  onTap: onErrorTap != null ? () => onErrorTap!(i) : null,
                  child: Text(
                    '• ${errors[i]}',
                    style: theme.typography.bodyXs.copyWith(
                      color: dangerScale.textDefault,
                      decoration: onErrorTap != null
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
