import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';

/// Internal semantic role for a [DsChip], mirroring the React chip parts
/// (`Chip.Button`, `Chip.Removable`, `Chip.Checkbox`, `Chip.Radio`).
enum _DsChipRole { button, removable, checkbox, radio }

/// A pill-shaped chip with optional selection state and remove button.
///
/// Supports keyboard activation (Enter/Space to tap, Delete to remove).
///
/// The default constructor renders a generic chip. For behaviour that mirrors
/// the React chip parts, use the named constructors:
///
/// * [DsChip.button] — a clickable action chip (`Chip.Button`).
/// * [DsChip.removable] — a chip with a remove icon (`Chip.Removable`).
/// * [DsChip.checkbox] — a toggleable, multi-select chip (`Chip.Checkbox`).
/// * [DsChip.radio] — a single-select chip (`Chip.Radio`).
class DsChip extends StatelessWidget {
  const DsChip({
    super.key,
    required this.child,
    this.size,
    this.color,
    this.removable = false,
    this.selected = false,
    this.onRemove,
    this.onTap,
  }) : _role = _DsChipRole.button;

  /// A clickable action chip, mirroring React `Chip.Button`.
  ///
  /// Calls [onTap] when activated. [selected] toggles the active visual state.
  const DsChip.button({
    super.key,
    required this.child,
    this.onTap,
    this.selected = false,
    this.size,
    this.color,
  }) : removable = false,
       onRemove = null,
       _role = _DsChipRole.button;

  /// A chip that shows a remove icon, mirroring React `Chip.Removable`.
  ///
  /// Calls [onRemove] when the remove icon is activated (or Delete is pressed).
  const DsChip.removable({
    super.key,
    required this.child,
    required VoidCallback this.onRemove,
    this.size,
    this.color,
  }) : removable = true,
       selected = false,
       onTap = null,
       _role = _DsChipRole.removable;

  /// A toggleable, multi-select chip, mirroring React `Chip.Checkbox`.
  ///
  /// [selected] reflects the checked state and [onChanged] is called with the
  /// negated value when the chip is activated. Exposes checkbox/checked
  /// semantics for assistive technology.
  DsChip.checkbox({
    super.key,
    required this.child,
    required this.selected,
    required ValueChanged<bool> onChanged,
    this.size,
    this.color,
  }) : removable = false,
       onRemove = null,
       onTap = (() => onChanged(!selected)),
       _role = _DsChipRole.checkbox;

  /// A single-select chip, mirroring React `Chip.Radio`.
  ///
  /// [selected] reflects the chosen state and [onChanged] is called when the
  /// chip is activated. Exposes selected semantics for assistive technology.
  const DsChip.radio({
    super.key,
    required this.child,
    required this.selected,
    required VoidCallback onChanged,
    this.size,
    this.color,
  }) : removable = false,
       onRemove = null,
       onTap = onChanged,
       _role = _DsChipRole.radio;

  final Widget child;
  final DsSize? size;
  final DsColor? color;
  final bool removable;
  final bool selected;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  final _DsChipRole _role;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = size ?? DsSizeScope.of(context);
    final radius = BorderRadius.circular(theme.borderRadius.full);

    final padding = switch (sizeMode) {
      DsSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      DsSize.md => const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      DsSize.lg => const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    };

    // Checkbox/radio selection uses the softer [surfaceActive]/[textDefault]
    // pairing (a tinted active state), while button/removable keep the
    // filled [baseDefault] selected styling.
    final isToggle =
        _role == _DsChipRole.checkbox || _role == _DsChipRole.radio;
    final Color bgColor;
    final Color fgColor;
    if (selected) {
      bgColor = isToggle ? colorScale.surfaceActive : colorScale.baseDefault;
      fgColor = isToggle
          ? colorScale.textDefault
          : colorScale.baseContrastDefault;
    } else {
      bgColor = colorScale.surfaceTinted;
      fgColor = colorScale.textDefault;
    }
    final Color borderColor = selected
        ? (isToggle ? colorScale.borderDefault : colorScale.baseDefault)
        : colorScale.borderSubtle;

    return Semantics(
      button: onTap != null && !isToggle,
      checked: _role == _DsChipRole.checkbox ? selected : null,
      selected: _role == _DsChipRole.checkbox ? null : selected,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if ((event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) &&
                onTap != null) {
              onTap!();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.delete &&
                removable &&
                onRemove != null) {
              onRemove!();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          cursor: onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: radius,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: padding,
                    child: DefaultTextStyle(
                      style: theme.typography.bodyMd.copyWith(color: fgColor),
                      child: child,
                    ),
                  ),
                  if (removable) ...[
                    Semantics(
                      button: true,
                      label: 'Fjern',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onRemove,
                        child: Padding(
                          padding: EdgeInsets.only(right: padding.right),
                          child: Icon(DsIcons.x, size: 14, color: fgColor),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
