import 'package:flutter/widgets.dart';

import '../../utils/ds_enums.dart';
import '../input/ds_input.dart';

class DsSearch extends StatelessWidget {
  const DsSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.size,
    this.placeholder,
    this.focusNode,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final DsSize? size;
  final String? placeholder;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return DsInput(
      controller: controller,
      size: size,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      placeholder: placeholder ?? 'Search...',
      prefix: const Text('🔍', style: TextStyle(fontSize: 16)),
    );
  }
}
