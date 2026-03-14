import 'package:flutter/widgets.dart';
import '../../utils/ds_enums.dart';
import '../input/ds_input.dart';

class DsTextarea extends StatelessWidget {
  const DsTextarea({
    super.key,
    this.controller,
    this.size,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    this.rows = 4,
    this.maxLength,
    this.autofocus = false,
    this.placeholder,
  });

  final TextEditingController? controller;
  final DsSize? size;
  final String? error;
  final bool disabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final int rows;
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
      onChanged: onChanged,
      focusNode: focusNode,
      maxLines: rows,
      maxLength: maxLength,
      autofocus: autofocus,
      placeholder: placeholder,
    );
  }
}
