import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../utils/ds_enums.dart';
import '../input/ds_input.dart';

/// Et flerlinjes tekstområde bygd på [DsInput].
///
/// Antall synlige rader som reserveres opp front, styres av [rows]. Feltet
/// starter [rows] linjer høyt og vokser videre etter hvert som brukeren skriver
/// mer tekst — på samme måte som et HTML-`<textarea rows>`.
///
/// [DsTextarea] er en tynn innpakning som videresender egenskapene direkte til
/// [DsInput]. [rows] settes som [DsInput.minLines] slik at høyden reserveres
/// fra start, mens [DsInput.maxLines] holdes `null` for å la feltet vokse. Hold
/// dette synkronisert med [DsInput]-konstruktøren når du legger til egenskaper,
/// slik at de to komponentene ikke drifter fra hverandre.
class DsTextarea extends StatelessWidget {
  const DsTextarea({
    super.key,
    this.controller,
    this.size,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.rows = 4,
    this.maxLength,
    this.autofocus = false,
    this.placeholder,
    this.textInputAction,
    this.inputFormatters,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final DsSize? size;
  final String? error;
  final bool disabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. presses the action key on
  /// the soft keyboard). Forwarded to [DsInput.onSubmitted].
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// The keyboard layout to show for editing. Forwarded to
  /// [DsInput.keyboardType].
  final TextInputType? keyboardType;

  /// Antall synlige rader som reserveres opp front. Feltet starter [rows]
  /// linjer høyt og vokser videre når innholdet overstiger dette. Settes som
  /// [DsInput.minLines].
  final int rows;
  final int? maxLength;
  final bool autofocus;
  final String? placeholder;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return DsInput(
      controller: controller,
      size: size,
      error: error,
      disabled: disabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      minLines: rows,
      maxLines: null,
      maxLength: maxLength,
      autofocus: autofocus,
      placeholder: placeholder,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      textCapitalization: textCapitalization,
      onTap: onTap,
      textAlign: textAlign,
    );
  }
}
