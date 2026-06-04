import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';
import '../input/ds_input.dart';

/// A search input field with a magnifying-glass icon prefix.
///
/// Built on [DsInput] and forwards text change and submit callbacks. Mirrors
/// the React `Search` composition (`Search.Input` + `Search.Clear`): set
/// [clearable] to show a clear button as a suffix when the field has text.
class DsSearch extends StatefulWidget {
  const DsSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSubmit,
    this.size,
    this.placeholder,
    this.focusNode,
    this.clearable = false,
    this.onClear,
    this.clearLabel = 'Tøm',
  });

  /// Controls the text being edited. A controller is created internally when
  /// none is supplied.
  final TextEditingController? controller;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. presses enter).
  final ValueChanged<String>? onSubmitted;

  /// Alias for [onSubmitted] matching the React `onSubmit` naming. When both
  /// are provided, [onSubmitted] is called first, then [onSubmit].
  final ValueChanged<String>? onSubmit;

  /// Sizing of the field. Falls back to the surrounding `DsSizeScope`.
  final DsSize? size;

  /// Placeholder text shown when the field is empty.
  final String? placeholder;

  /// External focus node for the underlying input.
  final FocusNode? focusNode;

  /// When `true`, shows a clear button (an `x` icon) as a suffix while the
  /// field contains text. Tapping it empties the field, calls [onChanged] with
  /// an empty string, and calls [onClear].
  final bool clearable;

  /// Called after the field is cleared via the clear button.
  final VoidCallback? onClear;

  /// Accessible label for the clear button. Defaults to «Tøm».
  final String clearLabel;

  @override
  State<DsSearch> createState() => _DsSearchState();
}

class _DsSearchState extends State<DsSearch> {
  TextEditingController? _ownController;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    if (widget.clearable) _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(DsSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.controller ?? _ownController;
    // Resolve through the getter so the listener is attached to the controller
    // [build] actually uses. When switching from an external controller to the
    // internal one, [_ownController] may still be null here; reading it via the
    // getter lazily creates it, ensuring the listener lands on the right
    // instance (otherwise the clear button would never show/hide).
    final newController =
        widget.controller ?? (_ownController ??= TextEditingController());
    if (oldController != newController ||
        oldWidget.clearable != widget.clearable) {
      if (oldWidget.clearable) {
        oldController?.removeListener(_onTextChanged);
      }
      if (widget.clearable) {
        newController.addListener(_onTextChanged);
      }
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _ownController)?.removeListener(_onTextChanged);
    _ownController?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild so the clear button appears/disappears as the field gains or
    // loses text.
    if (mounted) setState(() {});
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call(value);
    widget.onSubmit?.call(value);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final colorScale = theme.colorScheme.resolve(DsColorScope.of(context));

    final showClear = widget.clearable && _controller.text.isNotEmpty;

    return DsInput(
      controller: _controller,
      size: widget.size,
      onChanged: widget.onChanged,
      onSubmitted: _handleSubmitted,
      focusNode: widget.focusNode,
      placeholder: widget.placeholder ?? 'Søk...',
      prefix: const Icon(DsIcons.search, size: 16),
      suffix: showClear
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _clear,
              child: Semantics(
                button: true,
                label: widget.clearLabel,
                child: Icon(DsIcons.x, size: 16, color: colorScale.textSubtle),
              ),
            )
          : null,
    );
  }
}
