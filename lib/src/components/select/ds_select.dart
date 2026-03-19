import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';
import '../dropdown/ds_dropdown.dart';

/// A select control that opens a [DsDropdown] to choose from a list of
/// string items. Supports placeholder text, error state, disabled, and
/// read-only modes.
class DsSelect extends StatelessWidget {
  const DsSelect({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onChanged,
    this.placeholder,
    this.size,
    this.color,
    this.error,
    this.disabled = false,
    this.readOnly = false,
  });

  final List<String> items;
  final int? selectedIndex;
  final ValueChanged<int>? onChanged;
  final String? placeholder;
  final DsSize? size;
  final DsColor? color;
  final String? error;
  final bool disabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final dangerScale = theme.colorScheme.danger;
    final sizeMode = size ?? DsSizeScope.of(context);
    final hasError = error != null;

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    };
    final fontSize = switch (sizeMode) {
      DsSize.sm => 14.0,
      DsSize.md => 16.0,
      DsSize.lg => 18.0,
    };

    final displayText = selectedIndex != null && selectedIndex! < items.length
        ? items[selectedIndex!]
        : placeholder ?? '';

    final trigger = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScale.backgroundDefault,
        borderRadius: BorderRadius.circular(theme.borderRadius.defaultRadius),
        border: Border.all(
          color: hasError
              ? dangerScale.borderDefault
              : colorScale.borderDefault,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontFamily: theme.typography.fontFamily,
                fontSize: fontSize,
                color: selectedIndex != null
                    ? colorScale.textDefault
                    : colorScale.textSubtle,
              ),
            ),
          ),
          Icon(DsIcons.chevronDown, size: 16, color: colorScale.textSubtle),
        ],
      ),
    );

    if (disabled || readOnly) {
      return Semantics(
        button: true,
        label: 'Velg',
        value: displayText.isNotEmpty ? displayText : null,
        enabled: !disabled,
        readOnly: readOnly,
        child: Opacity(
          opacity: disabled ? theme.disabledOpacity : 1.0,
          child: trigger,
        ),
      );
    }

    return Semantics(
      button: true,
      label: 'Velg',
      value: displayText.isNotEmpty ? displayText : null,
      child: Focus(
        child: DsDropdown(
          trigger: trigger,
          items: items.map((label) => DsDropdownItem(label: label)).toList(),
          onSelected: onChanged,
          color: color,
        ),
      ),
    );
  }
}
