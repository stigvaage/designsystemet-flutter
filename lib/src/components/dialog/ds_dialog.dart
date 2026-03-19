import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';

class DsDialog extends StatefulWidget {
  const DsDialog({
    super.key,
    required this.child,
    this.title,
    this.onClose,
    this.color,
  });

  final Widget child;
  final Widget? title;
  final VoidCallback? onClose;
  final DsColor? color;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return Navigator.of(context).push<T>(_DsDialogRoute<T>(builder: builder));
  }

  @override
  State<DsDialog> createState() => _DsDialogState();
}

class _DsDialogState extends State<DsDialog> {
  late final FocusNode _focusNode;
  late final FocusNode _closeFocusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _closeFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Ensure onClose fires even when dismissed via barrier tap or back
    // navigation, which bypass _handleClose.
    _fireOnCloseIfNeeded();
    _focusNode.dispose();
    _closeFocusNode.dispose();
    super.dispose();
  }

  bool _closeFired = false;

  void _handleClose() {
    if (!_closeFired) {
      _closeFired = true;
      widget.onClose?.call();
    }
    Navigator.of(context).pop();
  }

  void _fireOnCloseIfNeeded() {
    if (!_closeFired) {
      _closeFired = true;
      widget.onClose?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = widget.color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return FocusScope(
      autofocus: true,
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            _handleClose();
          }
        },
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 560),
            decoration: BoxDecoration(
              color: colorScale.backgroundDefault,
              borderRadius: BorderRadius.circular(theme.borderRadius.lg),
              boxShadow: theme.shadows.xl,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null || widget.onClose != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null)
                        DefaultTextStyle(
                          style: theme.typography.headingMd.copyWith(
                            color: colorScale.textDefault,
                          ),
                          child: widget.title!,
                        ),
                      if (widget.onClose != null)
                        Semantics(
                          button: true,
                          label: 'Lukk dialog',
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: KeyboardListener(
                              focusNode: _closeFocusNode,
                              onKeyEvent: (event) {
                                if (event is KeyDownEvent &&
                                    (event.logicalKey ==
                                            LogicalKeyboardKey.enter ||
                                        event.logicalKey ==
                                            LogicalKeyboardKey.space)) {
                                  _handleClose();
                                }
                              },
                              child: GestureDetector(
                                onTap: _handleClose,
                                child: Center(
                                  child: Icon(
                                    DsIcons.x,
                                    size: 20,
                                    color: colorScale.textSubtle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (widget.title != null) const SizedBox(height: 16),
                DefaultTextStyle(
                  style: theme.typography.bodyMd.copyWith(
                    color: colorScale.textDefault,
                  ),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DsDialogRoute<T> extends PopupRoute<T> {
  _DsDialogRoute({required this.builder});
  final WidgetBuilder builder;

  @override
  Color? get barrierColor => const Color(0x80000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Center(child: builder(context));
  }
}
