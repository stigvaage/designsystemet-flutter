import 'package:flutter/widgets.dart';

/// The shared label layout for selection controls (checkbox, radio, switch).
///
/// Renders a [Row] of `[control, gap, Column(label, description)]`,
/// reproducing the layout previously duplicated across `DsCheckbox`,
/// `DsRadio` and `DsSwitch` so they can adopt it with no visual change:
///
/// * The row's [CrossAxisAlignment] is [CrossAxisAlignment.start] when a
///   [description] is present (so the control aligns to the first text line)
///   and [CrossAxisAlignment.center] otherwise. Override with
///   [crossAxisAlignment].
/// * The label column is left-aligned and shrink-wrapped.
/// * The [description], when present, is rendered below the [label] using
///   [descriptionStyle] (callers pass the resolved `bodySm` + `textSubtle`
///   token style so no values are hardcoded here).
///
/// Pass the same [gap] the components already use (8 logical pixels) — it is
/// the default.
///
/// ## Tilgjengelighet
///
/// Hele raden pakkes i [MergeSemantics] slik at [label] (og [description])
/// slås sammen med [control] til én semantikknode. Det gjør at en
/// skjermleser leser opp etiketten som kontrollens tilgjengelige navn
/// («Godta vilkår, avkrysningsboks, avkrysset») i stedet for en navnløs
/// kontroll og en frittstående tekstnode. Tilstandssemantikk (avkrysset,
/// valgt, på/av) og en eventuell live-region for feilmeldinger settes av
/// komponentene rundt [DsControlLabel] og berøres ikke av sammenslåingen,
/// fordi feilmeldingen ligger som et søsken utenfor denne widgeten.
class DsControlLabel extends StatelessWidget {
  const DsControlLabel({
    super.key,
    required this.control,
    required this.label,
    this.description,
    this.descriptionStyle,
    this.gap = 8.0,
    this.crossAxisAlignment,
    this.descriptionGap = 0.0,
  });

  /// The selection control (checkbox box, radio circle, switch track).
  final Widget control;

  /// The primary label widget shown next to the [control].
  final Widget label;

  /// Optional secondary description shown below the [label].
  final Widget? description;

  /// Text style applied to [description] via a [DefaultTextStyle]. Callers
  /// pass the resolved `bodySm` + `textSubtle` token style. Ignored when
  /// [description] is `null`.
  final TextStyle? descriptionStyle;

  /// Horizontal gap between the [control] and the label column.
  final double gap;

  /// Cross-axis alignment of the [Row]. Defaults to
  /// [CrossAxisAlignment.start] when a [description] is present and
  /// [CrossAxisAlignment.center] otherwise, matching the components' layout.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Vertical gap inserted between [label] and [description]. Defaults to `0`
  /// to match the existing component layout (no explicit gap).
  final double descriptionGap;

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null;
    final descriptionWidget = hasDescription
        ? (descriptionStyle != null
              ? DefaultTextStyle(style: descriptionStyle!, child: description!)
              : description!)
        : null;

    // Merge the control with its visible label/description into a single
    // semantics node so screen readers announce the label as the control's
    // accessible name together with its state (set by the surrounding
    // component). The error live-region lives outside this widget, so it is
    // unaffected and still announces valid → invalid transitions.
    return MergeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            crossAxisAlignment ??
            (hasDescription
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center),
        children: [
          control,
          SizedBox(width: gap),
          // Loose [Flexible] (not [Expanded]) so the label column keeps its
          // natural width when the parent is unbounded (shrink-wrap), but
          // wraps onto multiple lines instead of overflowing when the parent
          // constrains the available width.
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                label,
                if (descriptionWidget != null) ...[
                  if (descriptionGap > 0) SizedBox(height: descriptionGap),
                  descriptionWidget,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
