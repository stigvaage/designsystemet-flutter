import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';

/// A summary panel listing validation errors styled with danger colors.
///
/// Each error can optionally be tapped to navigate to the relevant field via
/// [onErrorTap]; when set, every error becomes a keyboard-focusable link with a
/// visible focus ring ([DsFocus.reserveRing], WCAG 2.4.7). The panel is marked
/// as a live region so screen readers announce it when it appears.
class DsErrorSummary extends StatelessWidget {
  const DsErrorSummary({
    super.key,
    required this.errors,
    this.title,
    this.onErrorTap,
    this.size = DsSize.md,
    this.color = DsColor.danger,
  });

  /// The error messages to list.
  final List<String> errors;

  /// The heading shown above the list. Defaults to the official Designsystemet
  /// ErrorSummary heading `'Du må rette opp følgende'` when omitted.
  final String? title;

  /// Called with the error index when an error is tapped or activated. When
  /// `null` the errors render as plain text instead of focusable links.
  final ValueChanged<int>? onErrorTap;

  /// Controls padding and typography scale. Defaults to [DsSize.md].
  final DsSize size;

  /// The semantic color of the summary. Defaults to [DsColor.danger], which is
  /// the canonical color for validation errors.
  final DsColor color;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final colorScale = theme.colorScheme.resolve(color);

    final padding = size.pick(sm: 12.0, md: 16.0, lg: 20.0);
    final titleStyle = size.pick(
      sm: theme.typography.bodySm,
      md: theme.typography.bodyMd,
      lg: theme.typography.bodyLg,
    );
    final bodyStyle = size.pick(
      sm: theme.typography.bodySm,
      md: theme.typography.bodyMd,
      lg: theme.typography.bodyLg,
    );
    final itemGap = size.pick(sm: 2.0, md: 4.0, lg: 6.0);

    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: colorScale.surfaceTinted,
          borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
          border: Border.all(color: colorScale.borderDefault, width: 1),
        ),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Du må rette opp følgende',
              style: titleStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScale.textDefault,
              ),
            ),
            SizedBox(height: size.pick(sm: 6.0, md: 8.0, lg: 10.0)),
            for (var i = 0; i < errors.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: itemGap),
                child: onErrorTap != null
                    ? Semantics(
                        link: true,
                        child: _DsErrorLink(
                          label: '• ${errors[i]}',
                          style: bodyStyle,
                          colorScale: colorScale,
                          onTap: () => onErrorTap!(i),
                        ),
                      )
                    : Text(
                        '• ${errors[i]}',
                        style: bodyStyle.copyWith(
                          color: colorScale.textDefault,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A single tappable error message rendered as a link.
///
/// Tracks keyboard focus so it shows a visible focus ring when focused
/// ([DsFocus.reserveRing], WCAG 2.4.7). The ring space is always reserved to
/// prevent layout shift between the focused and unfocused states.
class _DsErrorLink extends StatefulWidget {
  const _DsErrorLink({
    required this.label,
    required this.style,
    required this.colorScale,
    required this.onTap,
  });

  final String label;
  final TextStyle style;
  final DsColorScale colorScale;
  final VoidCallback onTap;

  @override
  State<_DsErrorLink> createState() => _DsErrorLinkState();
}

class _DsErrorLinkState extends State<_DsErrorLink> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _isFocused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: DsFocus.reserveRing(
            focused: _isFocused,
            radius: BorderRadius.circular(DsFocus.ringOffset),
            scale: widget.colorScale,
            child: Text(
              widget.label,
              style: widget.style.copyWith(
                color: widget.colorScale.textDefault,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
