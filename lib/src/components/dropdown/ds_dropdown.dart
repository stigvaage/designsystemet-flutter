import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_size_scope.dart';
import '../../theme/ds_size_tokens.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_overlay_anchors.dart';

/// Standard maksimal høyde for nedtrekksmenyen før innholdet ruller. Brukes som
/// øvre grense når den tilgjengelige plassen mot skjermkanten klemmes inn, og
/// som fallback når trigger/visningsområde ikke kan måles.
const double kDsDropdownMaxMenuHeight = 280;

/// Minste bredde på nedtrekksmenyen, slik at korte etiketter ikke gir en
/// uforholdsmessig smal meny.
const double kDsDropdownMinMenuWidth = 160;

/// An overlay-based dropdown menu that appears below a trigger widget.
///
/// Displays a list of [DsDropdownItem]s and notifies on selection. Closes on
/// outside tap or the Escape key. Keyboard users can move the highlight with
/// ArrowUp/ArrowDown and activate the highlighted item with Enter (WCAG 2.1.1),
/// matching `DsSelect` and `DsSuggestion`.
///
/// Selection can be observed two ways, which may be combined:
/// * [onSelected] receives the tapped item's index (the original API), and
/// * each [DsDropdownItem] may carry its own [DsDropdownItem.onTap] callback so
///   callers do not have to track indices.
class DsDropdown extends StatefulWidget {
  const DsDropdown({
    super.key,
    required this.trigger,
    required this.items,
    this.onSelected,
    this.size,
    this.color,
    this.focusNode,
  });

  /// The widget that opens the menu when tapped.
  final Widget trigger;

  /// The menu items rendered in order.
  final List<DsDropdownItem<dynamic>> items;

  /// Called with the tapped item's index. Fires alongside the item's own
  /// [DsDropdownItem.onTap], if any.
  final ValueChanged<int>? onSelected;

  /// The size mode for the menu items. Falls back to [DsSizeScope.of] when null.
  final DsSize? size;

  /// The colour role used to resolve the menu surface and text colours. Falls
  /// back to [DsColorScope.of] when null.
  final DsColor? color;

  /// Optional external focus node for the trigger. When null an internal node
  /// is created and disposed with the widget.
  final FocusNode? focusNode;

  @override
  State<DsDropdown> createState() => _DsDropdownState();
}

/// A data model for a single item within a [DsDropdown] menu.
///
/// In addition to the index reported by [DsDropdown.onSelected], an item may
/// carry its own [onTap] callback and an opaque [value], so callers can react
/// to a selection without tracking item indices.
class DsDropdownItem<T> {
  const DsDropdownItem({
    required this.label,
    this.enabled = true,
    this.onTap,
    this.value,
  });

  /// The text rendered for this item.
  final String label;

  /// When false the item is dimmed and cannot be selected.
  final bool enabled;

  /// Called when this item is selected. Fires alongside
  /// [DsDropdown.onSelected]. Lets callers avoid tracking item indices.
  final VoidCallback? onTap;

  /// An opaque value associated with this item, for the caller's convenience.
  final T? value;
}

class _DsDropdownState extends State<DsDropdown> {
  final _layerLink = LayerLink();

  /// Focus node for the trigger so keyboard activation (arrows/Enter/Escape) is
  /// routed to it while the menu is open. Falls back to an internally owned node
  /// when [DsDropdown.focusNode] is null.
  FocusNode? _ownFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  OverlayEntry? _entry;
  bool _isOpen = false;

  /// Plasseringen av menyen i forhold til utløseren. Vippes over utløseren
  /// ([DsPlacement.topStart]) når det er mer plass der enn under, slik at lange
  /// menyer eller menyer nær skjermkanten ikke renner ut av visningsområdet.
  DsPlacement _placement = DsPlacement.bottomStart;

  /// Maksimal høyde på menyflaten, klemt inn mot avstanden fra utløseren til
  /// relevant skjermkant. Faller tilbake til [kDsDropdownMaxMenuHeight].
  double _maxHeight = kDsDropdownMaxMenuHeight;

  /// Index of the keyboard-highlighted item, or -1 when nothing is highlighted.
  /// Driven by ArrowUp/ArrowDown so a keyboard user can navigate and activate an
  /// item without a pointer.
  int _highlight = -1;

  void _toggle() {
    _isOpen ? _close() : _open();
  }

  void _open() {
    if (_isOpen) return;
    // Ensure the trigger holds focus while the menu is open so keyboard
    // activation (arrows/Enter/Escape) is routed to it.
    _focusNode.requestFocus();
    // Capture theme and color scope BEFORE creating the OverlayEntry, since the
    // overlay builds outside this subtree's inherited widgets.
    final capturedTheme = DsTheme.of(context);
    final capturedColor = widget.color ?? DsColorScope.of(context);
    final capturedSize = widget.size ?? DsSizeScope.of(context);
    _highlight = -1;

    // Measure the trigger and viewport so the menu can flip above the trigger
    // and clamp its height to the available room, never running off-screen.
    final box = context.findRenderObject() as RenderBox?;
    final rect = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    final media = MediaQuery.maybeOf(context);
    final screen = media?.size;
    // Only treat the viewport as measured when it has a real, positive size;
    // otherwise (e.g. a zero-size MediaQuery in tests) skip both flipping and
    // height-clamping and use the default cap.
    final hasViewport = screen != null && screen.height > 0 && screen.width > 0;

    // Flip above the trigger when there is more room there than below.
    _placement = dsResolvePlacement(
      placement: DsPlacement.bottomStart,
      autoPlacement: true,
      anchorRect: rect,
      screen: hasViewport ? screen : null,
    );

    // Clamp the menu height to the space between the trigger and the relevant
    // viewport edge (minus the soft keyboard inset below), so it never runs
    // off-screen. Falls back to the default cap when measurements are
    // unavailable or the computed room is non-positive.
    if (rect != null && hasViewport) {
      const gap = 4.0;
      final bottomInset = media?.viewInsets.bottom ?? 0;
      final roomBelow = screen.height - rect.bottom - bottomInset - gap;
      final roomAbove = rect.top - gap;
      final room = _placement == DsPlacement.topStart ? roomAbove : roomBelow;
      _maxHeight = room > 0
          ? room.clamp(0.0, kDsDropdownMaxMenuHeight)
          : kDsDropdownMaxMenuHeight;
    } else {
      _maxHeight = kDsDropdownMaxMenuHeight;
    }

    setState(() => _isOpen = true);
    _entry = OverlayEntry(
      builder: (overlayContext) => _buildMenuWithTheme(
        overlayContext,
        capturedTheme,
        capturedColor,
        capturedSize,
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    if (!_isOpen) return;
    setState(() => _isOpen = false);
    _highlight = -1;
    _entry?.remove();
    _entry = null;
  }

  void _select(int index) {
    final item = widget.items[index];
    widget.onSelected?.call(index);
    item.onTap?.call();
    _close();
  }

  /// Returns the index of the next enabled item from [from] stepping by [delta]
  /// (wrapping), or -1 when no item is enabled. Keeps arrow navigation from
  /// landing on disabled rows.
  int _nextEnabled(int from, int delta) {
    final count = widget.items.length;
    if (count == 0) return -1;
    for (var i = 1; i <= count; i++) {
      final candidate = (from + delta * i) % count;
      final wrapped = candidate < 0 ? candidate + count : candidate;
      if (widget.items[wrapped].enabled) return wrapped;
    }
    return -1;
  }

  void _moveHighlight(int delta) {
    final next = _nextEnabled(_highlight, delta);
    if (next < 0) return;
    _highlight = next;
    _entry?.markNeedsBuild();
  }

  Widget _buildMenuWithTheme(
    BuildContext context,
    DsThemeData theme,
    DsColor activeColor,
    DsSize size,
  ) {
    final colorScale = theme.colorScheme.resolve(activeColor);
    final fontSize = DsSizeValues.fontSize(size);
    final padding = size.pick(
      sm: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      md: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      lg: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );

    final (targetAnchor, followerAnchor, offset) = dsPlacementAnchors(
      _placement,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _close,
      child: Stack(
        children: [
          CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            offset: offset,
            child: Align(
              alignment: Alignment.topLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScale.backgroundDefault,
                  borderRadius: BorderRadius.circular(
                    theme.borderRadius.defaultRadius,
                  ),
                  border: Border.all(color: colorScale.borderSubtle, width: 1),
                  boxShadow: theme.shadows.md,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: kDsDropdownMinMenuWidth,
                    maxHeight: _maxHeight,
                  ),
                  child: SingleChildScrollView(
                    // Group the item rows under a single semantics container
                    // with the `menu` role so assistive technology announces
                    // them as a cohesive menu rather than loose buttons.
                    child: Semantics(
                      container: true,
                      role: SemanticsRole.menu,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < widget.items.length; i++)
                            _itemRow(i, colorScale, fontSize, padding, theme),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(
    int index,
    DsColorScale colorScale,
    double fontSize,
    EdgeInsets padding,
    DsThemeData theme,
  ) {
    final item = widget.items[index];
    final highlighted = _highlight == index;
    return Semantics(
      button: true,
      role: SemanticsRole.menuItem,
      enabled: item.enabled,
      label: item.label,
      // A GestureDetector with a null onTap registers no tap recognizer, so a
      // tap on a disabled row would fall through to the outside-tap barrier
      // (the translucent _close detector wrapping the menu) and close the menu.
      // A disabled row instead carries an opaque, no-op tap recognizer so it
      // wins the gesture arena and swallows the tap: nothing fires and the menu
      // stays open. Enabled rows select as before.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.enabled ? () => _select(index) : () {},
        child: ColoredBox(
          color: highlighted && item.enabled
              ? colorScale.surfaceHover
              : const Color(0x00000000),
          child: Padding(
            padding: padding,
            child: Text(
              item.label,
              style: theme.typography.bodySm.copyWith(
                fontSize: fontSize,
                color: item.enabled
                    ? colorScale.textDefault
                    : colorScale.textSubtle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove the overlay directly — do NOT call _close()/setState() here, since
    // setState during dispose throws.
    _entry?.remove();
    _entry = null;
    _ownFocusNode?.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Allow key repeat for arrow navigation so holding the key keeps moving.
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape && _isOpen) {
      _close();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      // Open first if closed, then advance the highlight to the next enabled
      // item.
      if (!_isOpen) {
        _open();
        _moveHighlight(1);
      } else {
        _moveHighlight(1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (!_isOpen) {
        // Opening with ArrowUp lands on the LAST enabled item, matching
        // DsSelect. _open() resets _highlight to -1; seed it to 0 first so a
        // single backward step wraps to the last enabled index (Dart's `%`
        // returns a non-negative remainder, so stepping from -1 would land on
        // the second-to-last item).
        _open();
        _highlight = 0;
        _moveHighlight(-1);
      } else {
        _moveHighlight(-1);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      // When open with a highlighted enabled item, activate it; otherwise toggle
      // the menu open/closed.
      if (_isOpen &&
          _highlight >= 0 &&
          _highlight < widget.items.length &&
          widget.items[_highlight].enabled) {
        _select(_highlight);
      } else {
        _toggle();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Semantics(
        button: true,
        expanded: _isOpen,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              _focusNode.requestFocus();
              _toggle();
            },
            child: widget.trigger,
          ),
        ),
      ),
    );
  }
}
