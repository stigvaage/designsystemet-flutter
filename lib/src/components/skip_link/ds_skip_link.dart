import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

/// An accessibility skip-navigation link that is only visible when focused.
///
/// Activates via Enter, Space, or tap to jump past navigation content.
class DsSkipLink extends StatefulWidget {
  const DsSkipLink({
    super.key,
    required this.label,
    required this.onActivate,
    this.color,
  });

  final String label;
  final VoidCallback onActivate;
  final DsColor? color;

  @override
  State<DsSkipLink> createState() => _DsSkipLinkState();
}

class _DsSkipLinkState extends State<DsSkipLink> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return Semantics(
      link: true,
      label: widget.label,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onActivate();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: Offstage(
          offstage: !_isFocused,
          child: GestureDetector(
            onTap: widget.onActivate,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScale.baseDefault,
                borderRadius: BorderRadius.circular(
                  theme.borderRadius.defaultRadius,
                ),
              ),
              child: Text(
                widget.label,
                style: theme.typography.bodyMd.copyWith(
                  color: colorScale.baseContrastDefault,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
