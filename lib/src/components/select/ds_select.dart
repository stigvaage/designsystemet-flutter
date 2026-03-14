import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../dropdown/ds_dropdown.dart';

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
  });

  final List<String> items;
  final int? selectedIndex;
  final ValueChanged<int>? onChanged;
  final String? placeholder;
  final DsSize? size;
  final DsColor? color;
  final String? error;
  final bool disabled;

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
          color: hasError ? dangerScale.borderDefault : colorScale.borderDefault,
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
          Text('▾', style: TextStyle(color: colorScale.textSubtle)),
        ],
      ),
    );

    if (disabled) {
      return Opacity(
        opacity: theme.disabledOpacity,
        child: trigger,
      );
    }

    return DsDropdown(
      trigger: trigger,
      items: items.map((label) => DsDropdownItem(label: label)).toList(),
      onSelected: onChanged,
      color: color,
    );
  }
}
