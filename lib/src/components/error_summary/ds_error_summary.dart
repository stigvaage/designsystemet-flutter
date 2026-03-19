import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_theme.dart';

/// A summary panel listing validation errors styled with danger colors.
///
/// Each error can optionally be tapped to navigate to the relevant field.
/// Marked as a live region for screen-reader announcements.
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
              style: theme.typography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
                color: dangerScale.textDefault,
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < errors.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: onErrorTap != null
                    ? Semantics(
                        link: true,
                        child: Focus(
                          onKeyEvent: (node, event) {
                            if (event is KeyDownEvent &&
                                (event.logicalKey ==
                                        LogicalKeyboardKey.enter ||
                                    event.logicalKey ==
                                        LogicalKeyboardKey.space)) {
                              onErrorTap!(i);
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => onErrorTap!(i),
                              child: Text(
                                '• ${errors[i]}',
                                style: theme.typography.bodyMd.copyWith(
                                  color: dangerScale.textDefault,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        '• ${errors[i]}',
                        style: theme.typography.bodyMd.copyWith(
                          color: dangerScale.textDefault,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
