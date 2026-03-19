import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';

class DsLink extends StatefulWidget {
  const DsLink({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.inverted = false,
  });

  final String text;
  final VoidCallback? onTap;
  final DsColor? color;
  final bool inverted;

  @override
  State<DsLink> createState() => _DsLinkState();
}

class _DsLinkState extends State<DsLink> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    final textColor = widget.inverted
        ? colorScale.baseContrastDefault
        : colorScale.textDefault;

    return Semantics(
      link: true,
      label: widget.text,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            widget.onTap?.call();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (f) => setState(() => _isFocused = f),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: _isFocused
                    ? Border.all(color: colorScale.borderStrong, width: 2)
                    : Border.all(color: const Color(0x00000000), width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: Text(
                  widget.text,
                  style: theme.typography.bodyMd.copyWith(
                    color: textColor,
                    decoration: _isHovered
                        ? TextDecoration.none
                        : TextDecoration.underline,
                    decorationColor: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
