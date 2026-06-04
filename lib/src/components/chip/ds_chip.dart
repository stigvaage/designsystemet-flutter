import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';

/// Internal semantic role for a [DsChip], mirroring the React chip parts
/// (`Chip.Button`, `Chip.Removable`, `Chip.Checkbox`, `Chip.Radio`).
enum _DsChipRole { button, removable, checkbox, radio }

/// A pill-shaped chip with optional selection state and remove button.
///
/// Supports keyboard activation (Enter/Space to tap, Delete to remove). The
/// chip shows a visible focus ring while focused. For a [DsChip.removable]
/// chip the remove icon is a separately focusable button that activates with
/// Enter/Space, in addition to Delete pressing on the chip itself.
///
/// The default constructor renders a generic chip. For behaviour that mirrors
/// the React chip parts, use the named constructors:
///
/// * [DsChip.button] — a clickable action chip (`Chip.Button`).
/// * [DsChip.removable] — a chip with a remove icon (`Chip.Removable`).
/// * [DsChip.checkbox] — a toggleable, multi-select chip (`Chip.Checkbox`).
/// * [DsChip.radio] — a single-select chip (`Chip.Radio`).
class DsChip extends StatefulWidget {
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
  State<DsChip> createState() => _DsChipState();
}

class _DsChipState extends State<DsChip> {
  bool _isFocused = false;
  bool _isRemoveFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
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
        widget._role == _DsChipRole.checkbox ||
        widget._role == _DsChipRole.radio;
    final Color bgColor;
    final Color fgColor;
    if (widget.selected) {
      bgColor = isToggle ? colorScale.surfaceActive : colorScale.baseDefault;
      fgColor = isToggle
          ? colorScale.textDefault
          : colorScale.baseContrastDefault;
    } else {
      bgColor = colorScale.surfaceTinted;
      fgColor = colorScale.textDefault;
    }
    final Color borderColor = widget.selected
        ? (isToggle ? colorScale.borderDefault : colorScale.baseDefault)
        : colorScale.borderSubtle;

    Widget chip = Container(
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
              child: widget.child,
            ),
          ),
          if (widget.removable)
            _buildRemoveButton(colorScale, fgColor, padding.right),
        ],
      ),
    );

    // Always reserve focus ring space to prevent layout shift, matching the
    // pattern used by DsButton/DsCheckbox.
    final focusDecoration = _isFocused
        ? DsFocus.focusRingWithRadius(colorScale, radius)
        : BoxDecoration(
            borderRadius: BorderRadius.circular(
              radius.topLeft.x + DsFocus.ringWidth,
            ),
            border: Border.all(
              color: const Color(0x00000000),
              width: DsFocus.ringWidth,
            ),
          );

    chip = DecoratedBox(
      decoration: focusDecoration,
      child: Padding(
        padding: const EdgeInsets.all(DsFocus.ringWidth),
        child: chip,
      ),
    );

    return Semantics(
      // Only the button role is announced as a button. The toggle roles
      // (checkbox/radio) carry their own role-specific state below.
      button: widget.onTap != null && widget._role == _DsChipRole.button,
      // A selected button-role chip is a toggled (pressed) button — exposing
      // [selected] here as well would contradict the button role, so [selected]
      // is reserved for the radio role.
      toggled: widget._role == _DsChipRole.button && widget.selected
          ? true
          : null,
      checked: widget._role == _DsChipRole.checkbox ? widget.selected : null,
      selected: widget._role == _DsChipRole.radio ? widget.selected : null,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if ((event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) &&
                widget.onTap != null) {
              widget.onTap!();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.delete &&
                widget.removable &&
                widget.onRemove != null) {
              widget.onRemove!();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          cursor: widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: chip,
          ),
        ),
      ),
    );
  }

  /// Builds the remove icon as a real focusable button.
  ///
  /// It exposes button semantics, activates with Enter/Space (and via a tap),
  /// and shows its own focus ring while focused. Delete on the whole chip
  /// remains an alternative removal path handled by the chip's [Focus].
  Widget _buildRemoveButton(
    DsColorScale colorScale,
    Color fgColor,
    double trailingPadding,
  ) {
    Widget icon = Padding(
      padding: EdgeInsets.only(right: trailingPadding),
      child: Icon(DsIcons.x, size: 14, color: fgColor),
    );

    // Reserve a small focus ring around the remove icon so focusing it does
    // not shift the chip layout.
    final removeRadius = BorderRadius.circular(DsFocus.ringWidth);
    final removeFocusDecoration = _isRemoveFocused
        ? DsFocus.focusRingWithRadius(colorScale, removeRadius)
        : BoxDecoration(
            borderRadius: BorderRadius.circular(DsFocus.ringWidth * 2),
            border: Border.all(
              color: const Color(0x00000000),
              width: DsFocus.ringWidth,
            ),
          );

    icon = DecoratedBox(
      decoration: removeFocusDecoration,
      child: Padding(
        padding: const EdgeInsets.all(DsFocus.ringWidth),
        child: icon,
      ),
    );

    return Semantics(
      button: true,
      label: 'Fjern',
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) &&
              widget.onRemove != null) {
            widget.onRemove!();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isRemoveFocused = f),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onRemove,
            child: icon,
          ),
        ),
      ),
    );
  }
}
