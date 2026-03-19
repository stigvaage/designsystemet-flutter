import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_icons.dart';

class DsDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = DsTheme.of(context);
    final activeColor = color ?? DsColorScope.of(context);
    final colorScale = theme.colorScheme.resolve(activeColor);

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          onClose?.call();
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
              if (title != null || onClose != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (title != null)
                      DefaultTextStyle(
                        style: theme.typography.headingMd.copyWith(
                          color: colorScale.textDefault,
                        ),
                        child: title!,
                      ),
                    if (onClose != null)
                      GestureDetector(
                        onTap: onClose,
                        child: Icon(
                          DsIcons.x,
                          size: 20,
                          color: colorScale.textSubtle,
                        ),
                      ),
                  ],
                ),
              if (title != null) const SizedBox(height: 16),
              DefaultTextStyle(
                style: theme.typography.bodyMd.copyWith(
                  color: colorScale.textDefault,
                ),
                child: child,
              ),
            ],
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
