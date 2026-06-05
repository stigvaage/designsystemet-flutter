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
///
/// Etter offisiell Designsystemet-praksis bør fokus flyttes til
/// feilsammendraget etter mislykket innsending. Send med en [focusNode] og kall
/// `focusNode.requestFocus()` etter validering, eller sett [autofocus] til
/// `true`, slik at tastatur- og skjermleserbrukere lander på sammendraget.
class DsErrorSummary extends StatefulWidget {
  const DsErrorSummary({
    super.key,
    required this.errors,
    this.title,
    this.onErrorTap,
    this.size = DsSize.md,
    this.color = DsColor.danger,
    this.focusNode,
    this.autofocus = false,
  });

  /// The error messages to list.
  final List<String> errors;

  /// The heading shown above the list. Defaults to a sensible Norwegian default
  /// `'Du må rette opp følgende'` when omitted.
  final String? title;

  /// Called with the error index when an error is tapped or activated. When
  /// `null` the errors render as plain text instead of focusable links.
  final ValueChanged<int>? onErrorTap;

  /// Controls padding and typography scale. Defaults to [DsSize.md].
  final DsSize size;

  /// The semantic color of the summary. Defaults to [DsColor.danger], which is
  /// the canonical color for validation errors.
  final DsColor color;

  /// Fokusnode for selve sammendraget. Send med en node og kall
  /// `focusNode.requestFocus()` etter mislykket innsending for å flytte fokus
  /// til sammendraget, slik den offisielle Designsystemet-praksisen anbefaler.
  /// Når den ikke oppgis lager komponenten en intern node.
  final FocusNode? focusNode;

  /// Når `true` får sammendraget fokus så snart det vises, slik at tastatur- og
  /// skjermleserbrukere automatisk tas til feillisten. Standard er `false`.
  final bool autofocus;

  @override
  State<DsErrorSummary> createState() => _DsErrorSummaryState();
}

class _DsErrorSummaryState extends State<DsErrorSummary> {
  FocusNode? _ownFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final colorScale = theme.colorScheme.resolve(widget.color);
    final errors = widget.errors;

    final padding = widget.size.pick(sm: 12.0, md: 16.0, lg: 20.0);
    final titleStyle = widget.size.pick(
      sm: theme.typography.bodySm,
      md: theme.typography.bodyMd,
      lg: theme.typography.bodyLg,
    );
    final bodyStyle = widget.size.pick(
      sm: theme.typography.bodySm,
      md: theme.typography.bodyMd,
      lg: theme.typography.bodyLg,
    );
    final itemGap = widget.size.pick(sm: 2.0, md: 4.0, lg: 6.0);
    final bulletGap = widget.size.pick(sm: 6.0, md: 8.0, lg: 10.0);

    return Semantics(
      liveRegion: true,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        // The summary heading is a programmatic focus target (for moving focus
        // here after a failed submit), not a regular Tab stop competing with
        // the error links.
        skipTraversal: true,
        canRequestFocus: true,
        child: Container(
          decoration: BoxDecoration(
            color: colorScale.surfaceTinted,
            borderRadius: BorderRadius.circular(
              theme.borderRadius.defaultRadius,
            ),
            border: Border.all(color: colorScale.borderDefault, width: 1),
          ),
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title ?? 'Du må rette opp følgende',
                style: titleStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScale.textDefault,
                ),
              ),
              SizedBox(height: bulletGap),
              for (var i = 0; i < errors.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: itemGap),
                  child: widget.onErrorTap != null
                      ? Semantics(
                          link: true,
                          child: _DsErrorLink(
                            label: errors[i],
                            style: bodyStyle,
                            colorScale: colorScale,
                            onTap: () => widget.onErrorTap!(i),
                          ),
                        )
                      : _DsErrorRow(
                          marker: _bullet(bodyStyle, colorScale),
                          child: Text(
                            errors[i],
                            style: bodyStyle.copyWith(
                              color: colorScale.textDefault,
                            ),
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The decorative list bullet. Wrapped in [ExcludeSemantics] so it is not part
/// of the accessible name announced for the error message (WCAG 1.3.1 / 1.1.1).
Widget _bullet(TextStyle style, DsColorScale colorScale) {
  return ExcludeSemantics(
    child: Text('•', style: style.copyWith(color: colorScale.textDefault)),
  );
}

/// Lays out a decorative [marker] (bullet) next to the error [child].
class _DsErrorRow extends StatelessWidget {
  const _DsErrorRow({required this.marker, required this.child});

  final Widget marker;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        marker,
        const SizedBox(width: 8),
        Flexible(child: child),
      ],
    );
  }
}

/// A single tappable error message rendered as a link.
///
/// Tracks keyboard focus so it shows a visible focus ring when focused
/// ([DsFocus.reserveRing], WCAG 2.4.7). The ring space is always reserved to
/// prevent layout shift between the focused and unfocused states. The decorative
/// bullet is rendered separately and excluded from semantics so only the error
/// message becomes the link's accessible name.
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
    return _DsErrorRow(
      marker: _bullet(widget.style, widget.colorScale),
      child: Focus(
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
      ),
    );
  }
}
