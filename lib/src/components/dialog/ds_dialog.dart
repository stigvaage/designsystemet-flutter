import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scale.dart';
import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../utils/ds_animation.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_focus.dart';
import '../../utils/ds_icons.dart';

/// Plassering av en [DsDialog].
///
/// Speiler `data-placement` i offisiell Designsystemet: [center] (standard)
/// viser en sentrert dialog, mens [left], [right], [top] og [bottom] viser
/// dialogen som en «skuff» (drawer) forankret til den aktuelle skjermkanten.
enum DsDialogPlacement {
  /// Sentrert dialog med maks bredde og avrundede hjørner (standard).
  center,

  /// Skuff forankret til venstre kant, full høyde.
  left,

  /// Skuff forankret til høyre kant, full høyde.
  right,

  /// Skuff forankret til toppen, full bredde.
  top,

  /// Skuff forankret til bunnen, full bredde.
  bottom,
}

/// Modalt dialogvindu med tittel, valgfri lukkeknapp og fokusfelle.
///
/// Vis dialogen med [DsDialog.show]. Dialogen fanger fokus, lukkes med
/// `Escape`, og kaller [onClose] også når den avvises via klikk utenfor
/// dialogen eller tilbakenavigasjon.
///
/// Lukkeknappen vises som standard (i tråd med offisiell Designsystemet) og
/// kan skjules ved å sette [closeButton] til `false`.
class DsDialog extends StatefulWidget {
  /// Oppretter en [DsDialog].
  const DsDialog({
    super.key,
    required this.child,
    this.title,
    this.onClose,
    this.color,
    this.closeButton = true,
    this.placement = DsDialogPlacement.center,
  });

  /// Innholdet i dialogen.
  final Widget child;

  /// Valgfri tittel som vises øverst i dialogen.
  final Widget? title;

  /// Kalles når dialogen lukkes (via lukkeknapp, `Escape`, klikk utenfor eller
  /// tilbakenavigasjon).
  final VoidCallback? onClose;

  /// Fargeskala for dialogen. Faller tilbake til [DsColorScope] når `null`.
  final DsColor? color;

  /// Om lukkeknappen (X) skal vises. Standard `true`.
  final bool closeButton;

  /// Hvor dialogen plasseres på skjermen. Standard [DsDialogPlacement.center].
  final DsDialogPlacement placement;

  /// Viser [DsDialog] som en modal rute over gjeldende skjerm.
  ///
  /// [closeOnBarrierTap] styrer om et klikk utenfor dialogen lukker den.
  /// Standard er `false`, i tråd med offisiell Designsystemet der en modal
  /// dialog uten `closedby` kun lukkes med `Escape` eller en eksplisitt
  /// handling. [placement] styrer plasseringen på skjermen.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool closeOnBarrierTap = false,
    DsDialogPlacement placement = DsDialogPlacement.center,
  }) {
    return Navigator.of(context).push<T>(
      _DsDialogRoute<T>(
        builder: builder,
        closeOnBarrierTap: closeOnBarrierTap,
        placement: placement,
      ),
    );
  }

  @override
  State<DsDialog> createState() => _DsDialogState();
}

class _DsDialogState extends State<DsDialog> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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

  /// Hjørneradius som passer til [DsDialog.placement].
  ///
  /// Skuff-plasseringer dropper radien på de to hjørnene som ligger mot
  /// skjermkanten, slik det offisielle systemet gjør for drawer-varianten.
  BorderRadius _resolveBorderRadius(double radius) {
    final r = Radius.circular(radius);
    return switch (widget.placement) {
      DsDialogPlacement.center => BorderRadius.all(r),
      DsDialogPlacement.left => BorderRadius.only(topRight: r, bottomRight: r),
      DsDialogPlacement.right => BorderRadius.only(topLeft: r, bottomLeft: r),
      DsDialogPlacement.top => BorderRadius.only(bottomLeft: r, bottomRight: r),
      DsDialogPlacement.bottom => BorderRadius.only(topLeft: r, topRight: r),
    };
  }

  BoxConstraints _resolveConstraints() {
    return switch (widget.placement) {
      DsDialogPlacement.center => const BoxConstraints(maxWidth: 560),
      DsDialogPlacement.left || DsDialogPlacement.right => const BoxConstraints(
        maxWidth: 560,
        minHeight: double.infinity,
      ),
      DsDialogPlacement.top || DsDialogPlacement.bottom => const BoxConstraints(
        minWidth: double.infinity,
      ),
    };
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
            constraints: _resolveConstraints(),
            decoration: BoxDecoration(
              color: colorScale.backgroundDefault,
              borderRadius: _resolveBorderRadius(theme.borderRadius.lg),
              boxShadow: theme.shadows.xl,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null || widget.closeButton)
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
                      if (widget.closeButton)
                        _DsDialogCloseButton(
                          colorScale: colorScale,
                          onClose: _handleClose,
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

/// Lukkeknappen (X) som vises når [DsDialog.closeButton] er `true`.
///
/// Sporer egen fokustilstand slik at en synlig fokusring kan reserveres og
/// tegnes (via [DsFocus.reserveRing]) uten at layouten flytter seg, og viser
/// klikk-markøren ved peking. Aktiveres ved tap og med `Enter`/`Space`.
class _DsDialogCloseButton extends StatefulWidget {
  const _DsDialogCloseButton({required this.colorScale, required this.onClose});

  final DsColorScale colorScale;
  final VoidCallback onClose;

  @override
  State<_DsDialogCloseButton> createState() => _DsDialogCloseButtonState();
}

class _DsDialogCloseButtonState extends State<_DsDialogCloseButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    Widget button = SizedBox(
      width: 44,
      height: 44,
      child: Center(
        child: Icon(DsIcons.x, size: 20, color: widget.colorScale.textSubtle),
      ),
    );

    // Always reserve focus ring space to prevent layout shift.
    button = DsFocus.reserveRing(
      focused: _isFocused,
      radius: BorderRadius.zero,
      scale: widget.colorScale,
      child: button,
    );

    return Semantics(
      button: true,
      label: 'Lukk dialogvindu',
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onClose();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onClose,
            child: button,
          ),
        ),
      ),
    );
  }
}

class _DsDialogRoute<T> extends PopupRoute<T> {
  _DsDialogRoute({
    required this.builder,
    required this.closeOnBarrierTap,
    required this.placement,
  });

  final WidgetBuilder builder;
  final bool closeOnBarrierTap;
  final DsDialogPlacement placement;

  @override
  Color? get barrierColor => const Color(0x80000000);

  @override
  bool get barrierDismissible => closeOnBarrierTap;

  @override
  String? get barrierLabel => 'Lukk';

  @override
  Duration get transitionDuration {
    final context = navigator?.context;
    final disableAnimations = context == null
        ? false
        : (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    return disableAnimations ? Duration.zero : DsAnimation.normal;
  }

  Alignment get _alignment => switch (placement) {
    DsDialogPlacement.center => Alignment.center,
    DsDialogPlacement.left => Alignment.centerLeft,
    DsDialogPlacement.right => Alignment.centerRight,
    DsDialogPlacement.top => Alignment.topCenter,
    DsDialogPlacement.bottom => Alignment.bottomCenter,
  };

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Align(alignment: _alignment, child: builder(context));
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!DsAnimation.shouldAnimate(context)) {
      return child;
    }
    final curved = CurvedAnimation(
      parent: animation,
      curve: DsAnimation.defaultCurve,
    );
    final fade = FadeTransition(opacity: curved, child: child);
    if (placement == DsDialogPlacement.center) {
      return fade;
    }
    // Skuff-plasseringer glir inn fra sin kant.
    final begin = switch (placement) {
      DsDialogPlacement.left => const Offset(-1, 0),
      DsDialogPlacement.right => const Offset(1, 0),
      DsDialogPlacement.top => const Offset(0, -1),
      DsDialogPlacement.bottom => const Offset(0, 1),
      DsDialogPlacement.center => Offset.zero,
    };
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
      child: fade,
    );
  }
}
