import 'package:flutter/widgets.dart';

import '../../theme/ds_theme.dart';
import '../../typography/ds_label.dart';
import '../../typography/ds_validation_message.dart';
import '../../utils/ds_enums.dart';

class DsField extends StatelessWidget {
  const DsField({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.error,
    this.size,
  });

  final Widget child;
  final String? label;
  final String? description;
  final String? error;
  final DsSize? size;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: DsLabel(text: label!, size: size),
          ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              description!,
              style: theme.typography.bodyXs.copyWith(
                color: theme.colorScheme.neutral.textSubtle,
              ),
            ),
          ),
        child,
        if (error != null)
          DsValidationMessage(message: error!),
      ],
    );
  }
}
