import 'package:flutter/widgets.dart';
import '../../utils/ds_enums.dart';
import '../input/ds_input.dart';

class DsTextfield extends StatelessWidget {
  const DsTextfield({
    super.key,
    this.controller,
    this.size,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.autofocus = false,
    this.placeholder,
  });

  final TextEditingController? controller;
  final DsSize? size;
  final String? error;
  final bool disabled;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final bool autofocus;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return DsInput(
      controller: controller,
      size: size,
      error: error,
      disabled: disabled,
      readOnly: readOnly,
      prefix: prefix,
      suffix: suffix,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: 1,
      autofocus: autofocus,
      placeholder: placeholder,
    );
  }
}
