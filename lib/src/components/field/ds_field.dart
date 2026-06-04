import 'package:flutter/widgets.dart';

import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../typography/ds_label.dart';
import '../../typography/ds_validation_message.dart';
import '../../utils/ds_enums.dart';

/// Form field wrapper that composes a label, description, input, and validation message.
///
/// Place any input widget (e.g. [DsTextfield], [DsCheckbox]) as [child].
/// When [error] is set, a [DsValidationMessage] is shown below the input.
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

    // Resolve the field size the same way [DsLabel] does so label, description
    // and validation message all scale together. Matches the official
    // Designsystemet `data-size` cascade across the whole field.
    final sizeMode = size ?? DsSizeScope.of(context);

    // Same body-size mapping that [DsLabel] applies: sm→bodyMd, md→bodyLg,
    // lg→bodyXl. This keeps description and validation text in step with the
    // scaling label instead of being pinned to bodyMd.
    final bodyStyle = sizeMode.pick(
      sm: theme.typography.bodyMd,
      md: theme.typography.bodyLg,
      lg: theme.typography.bodyXl,
    );

    // [DsValidationMessage] pins its own text to bodyMd and takes no size
    // parameter, so scale it proportionally to the resolved field size
    // (bodyMd → 1.0, bodyLg → 1.125, bodyXl → 1.25). This is applied on top of
    // any user text scaling so accessibility settings are still respected.
    final validationScale = sizeMode.pick(sm: 1.0, md: 1.125, lg: 1.25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: DsLabel(text: label!, size: sizeMode),
          ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              description!,
              style: bodyStyle.copyWith(
                color: theme.colorScheme.neutral.textSubtle,
              ),
            ),
          ),
        DsFieldScope(error: error, child: child),
        if (error != null)
          MediaQuery(
            // Compose the field size factor with the user's current text
            // scaler so the validation message scales with the field while
            // still honouring accessibility text-scaling settings.
            data: MediaQuery.of(context).copyWith(
              textScaler: _ScaledTextScaler(
                MediaQuery.textScalerOf(context),
                validationScale,
              ),
            ),
            child: DsValidationMessage(message: error!),
          ),
      ],
    );
  }
}

/// A [TextScaler] that multiplies an [inner] scaler by a fixed [factor].
///
/// Used to apply the field's size step to [DsValidationMessage] (which pins
/// its own text to `bodyMd`) without discarding the user's accessibility text
/// scaling carried by [inner].
class _ScaledTextScaler extends TextScaler {
  const _ScaledTextScaler(this.inner, this.factor);

  final TextScaler inner;
  final double factor;

  @override
  double scale(double fontSize) => inner.scale(fontSize) * factor;

  // Derives the legacy factor from [scale] so the deprecated
  // [TextScaler.textScaleFactor] getter is never read directly.
  @override
  double get textScaleFactor => inner.scale(1.0) * factor;

  @override
  bool operator ==(Object other) =>
      other is _ScaledTextScaler &&
      other.inner == inner &&
      other.factor == factor;

  @override
  int get hashCode => Object.hash(inner, factor);
}

class DsFieldScope extends InheritedWidget {
  const DsFieldScope({super.key, required this.error, required super.child});

  final String? error;

  static DsFieldScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DsFieldScope>();

  @override
  bool updateShouldNotify(DsFieldScope oldWidget) => error != oldWidget.error;
}
