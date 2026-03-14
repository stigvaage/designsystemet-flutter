import 'package:flutter/widgets.dart';
import '../theme/ds_theme.dart';
import '../utils/ds_enums.dart';

/// Validation message text component.
///
/// Displays error or success messages below form fields
/// using the appropriate color scale (danger for errors, success for valid).
class DsValidationMessage extends StatelessWidget {
  const DsValidationMessage({
    super.key,
    required this.message,
    this.isError = true,
    this.size,
  });

  final String message;
  final bool isError;
  final DsSize? size;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final colorScale = theme.colorScheme.resolve(
      isError ? DsColor.danger : DsColor.success,
    );

    final style = theme.typography.bodyXs.copyWith(
      color: colorScale.textDefault,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(message, style: style),
    );
  }
}
