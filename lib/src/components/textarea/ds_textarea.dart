import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../utils/ds_enums.dart';
import '../input/ds_input.dart';

/// A multi-line text input area built on [DsInput].
///
/// The number of visible lines is controlled by [rows].
///
/// [DsTextarea] is a thin wrapper that forwards every property directly to
/// [DsInput] (passing [rows] as `maxLines`). Keep this in sync with
/// [DsInput]'s constructor when adding properties, so the two components do
/// not drift apart.
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
      maxLines: rows,
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
