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
/// Supports keyboard activation (Enter/Space to tap, Delete to remove) and a
/// subtle hover state, matching the official Designsystemet chip / [DsButton].
/// The chip shows a visible focus ring while focused. For a [DsChip.removable]
/// chip the remove icon is a separately focusable button that activates with
/// Enter/Space, in addition to Delete pressing on the chip itself.
///
/// Set [disabled] to render the chip as non-interactive (dimmed, no hover, no
/// activation, basic cursor). A [focusNode] and a [size] override are exposed
/// for parity with other interactive components.
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
    this.disabled = false,
    this.onRemove,
    this.onTap,
    this.focusNode,
  }) : _role = _DsChipRole.button;

  /// A clickable action chip, mirroring React `Chip.Button`.
  ///
  /// Calls [onTap] when activated. [selected] toggles the active visual state.
  const DsChip.button({
    super.key,
    required this.child,
    this.onTap,
    this.selected = false,
    this.disabled = false,
    this.size,
    this.color,
    this.focusNode,
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
    this.disabled = false,
    this.size,
    this.color,
    this.focusNode,
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
    this.disabled = false,
    this.size,
    this.color,
    this.focusNode,
  }) : removable = false,
       onRemove = null,
       onTap = (() => onChanged(!selected)),
       _role = _DsChipRole.checkbox;

  /// A single-select chip, mirroring React `Chip.Radio`.
  ///
  /// [selected] reflects the chosen state and [onChanged] is called when the
  /// chip is activated. Exposes selected semantics for assistive technology.
  ///
  /// The radio role is idempotent: activating an already-[selected] chip (via
  /// tap, Enter or Space) does not re-fire [onChanged], matching [DsRadio].
  const DsChip.radio({
    super.key,
    required this.child,
    required this.selected,
    required VoidCallback onChanged,
    this.disabled = false,
    this.size,
    this.color,
    this.focusNode,
  }) : removable = false,
       onRemove = null,
       onTap = selected ? null : onChanged,
       _role = _DsChipRole.radio;

  /// The chip's label content.
  final Widget child;

  /// Size override; falls back to the nearest [DsSizeScope].
  final DsSize? size;

  /// Color override; falls back to the nearest [DsColorScope].
  final DsColor? color;

  /// Whether the chip shows a remove icon.
  final bool removable;

  /// Whether the chip renders in its selected/active visual state.
  final bool selected;

  /// Whether the chip is non-interactive (dimmed, no hover, no activation).
  final bool disabled;

  /// Called when the remove icon is activated (or Delete is pressed).
  final VoidCallback? onRemove;

  /// Called when the chip body is activated (tap, Enter or Space).
  final VoidCallback? onTap;

  /// An optional focus node for the chip body.
  final FocusNode? focusNode;

  final _DsChipRole _role;

  @override
  State<DsChip> createState() => _DsChipState();
}

class _DsChipState extends State<DsChip> {
  bool _isFocused = false;
  bool _isRemoveFocused = false;
  bool _isHovered = false;

  /// Whether the chip body can be activated right now.
  bool get _isInteractive => !widget.disabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);
    final sizeMode = widget.size ?? DsSizeScope.of(context);
    final radius = BorderRadius.circular(theme.borderRadius.full);

    final padding = sizeMode.pick(
      sm: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      md: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      lg: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );

    // Checkbox/radio selection uses the softer [surfaceActive]/[textDefault]
    // pairing (a tinted active state), while button/removable keep the
    // filled [baseDefault] selected styling.
    final isToggle =
        widget._role == _DsChipRole.checkbox ||
        widget._role == _DsChipRole.radio;
    // A subtle hover only applies to interactive chips, matching DsButton.
    final hovered = _isHovered && _isInteractive;
    final Color bgColor;
    final Color fgColor;
    if (widget.selected) {
      if (isToggle) {
        bgColor = colorScale.surfaceActive;
        fgColor = colorScale.textDefault;
      } else {
        // Filled selected chip: hover darkens the base, like DsButton primary.
        bgColor = hovered ? colorScale.baseHover : colorScale.baseDefault;
        fgColor = colorScale.baseContrastDefault;
      }
    } else {
      // Unselected chip: hover lifts the tinted surface, like DsButton ghost.
      bgColor = hovered ? colorScale.surfaceHover : colorScale.surfaceTinted;
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
          // Only render the remove button when there is a handler to call.
          // Without [onRemove] the icon would be a no-op on tap, Delete and
          // Enter/Space, yet still announce an enabled "Fjern"-button to
          // assistive technology — a dead control. Prefer [DsChip.removable],
          // which requires [onRemove].
          if (widget.removable && widget.onRemove != null)
            _buildRemoveButton(colorScale, fgColor, padding.right),
        ],
      ),
    );

    // Always reserve focus ring space to prevent layout shift, matching the
    // pattern used by DsButton/DsCheckbox.
    chip = DsFocus.reserveRing(
      focused: _isFocused && !widget.disabled,
      radius: radius,
      scale: colorScale,
      child: chip,
    );

    if (widget.disabled) {
      chip = Opacity(opacity: theme.disabledOpacity, child: chip);
    }

    return Semantics(
      enabled: !widget.disabled,
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
        focusNode: widget.focusNode,
        canRequestFocus: !widget.disabled,
        onKeyEvent: (node, event) {
          if (widget.disabled) return KeyEventResult.ignored;
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
          cursor: _isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) {
            if (_isInteractive) setState(() => _isHovered = true);
          },
          onExit: (_) {
            if (_isHovered) setState(() => _isHovered = false);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.disabled ? null : widget.onTap,
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
    icon = DsFocus.reserveRing(
      focused: _isRemoveFocused && !widget.disabled,
      radius: BorderRadius.circular(DsFocus.ringWidth),
      scale: colorScale,
      child: icon,
    );

    return Semantics(
      button: true,
      enabled: !widget.disabled,
      label: 'Fjern',
      child: Focus(
        canRequestFocus: !widget.disabled,
        onKeyEvent: (node, event) {
          if (!widget.disabled &&
              event is KeyDownEvent &&
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
          cursor: widget.disabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.disabled ? null : widget.onRemove,
            child: icon,
          ),
        ),
      ),
    );
  }
}
