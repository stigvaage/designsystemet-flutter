import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/ds_color_scope.dart';
import '../../theme/ds_theme.dart';
import '../../theme/ds_theme_data.dart';
import '../../utils/ds_enums.dart';
import '../../utils/ds_overlay_anchors.dart';

/// En verktøytips som vises ved siden av [child] ved peker-hover **eller**
/// tastaturfokus.
///
/// Speiler React-Tooltip: [placement] (standard [DsPlacement.top]) og
/// [autoPlacement] (standard `true`). [message] eksponeres også for hjelpemidler
/// via [Semantics.tooltip].
///
/// I tråd med det offisielle Designsystemet bruker verktøytipset **alltid** den
/// nøytrale fargeskalaen og påvirkes ikke av en arvet [DsColorScope] eller
/// [color]. Det oppfyller WCAG 2.1 AA SC 1.4.13 «Innhold ved pekerhvile eller
/// fokus»: det kan lukkes med Escape uten å flytte peker/fokus (dismissible), og
/// pekeren kan flyttes inn over selve tipset uten at det forsvinner (hoverable).
class DsTooltip extends StatefulWidget {
  const DsTooltip({
    super.key,
    required this.message,
    required this.child,
    @Deprecated(
      'Verktøytips bruker alltid nøytral farge i tråd med det offisielle '
      'Designsystemet. Denne parameteren ignoreres og fjernes i en '
      'framtidig versjon.',
    )
    this.color,
    this.placement = DsPlacement.top,
    this.autoPlacement = true,
  });

  /// Teksten som vises i verktøytipset og eksponeres via [Semantics.tooltip].
  final String message;

  /// Utløseren som verktøytipset er forankret til.
  final Widget child;

  /// Utdatert. Verktøytipset bruker alltid den nøytrale fargeskalaen i tråd med
  /// det offisielle Designsystemet, så denne parameteren har ingen effekt.
  @Deprecated(
    'Verktøytips bruker alltid nøytral farge i tråd med det offisielle '
    'Designsystemet. Denne parameteren ignoreres og fjernes i en '
    'framtidig versjon.',
  )
  final DsColor? color;

  /// Siden av [child] verktøytipset forankres til. Standard [DsPlacement.top].
  final DsPlacement placement;

  /// Når sann (standard) snus tipset til motsatt side dersom den foretrukne
  /// [placement] mangler plass i visningsområdet.
  final bool autoPlacement;

  @override
  State<DsTooltip> createState() => _DsTooltipState();
}

class _DsTooltipState extends State<DsTooltip> {
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  DsThemeData? _capturedTheme;
  DsPlacement _resolvedPlacement = DsPlacement.top;

  /// Om pekeren er over utløseren.
  bool _hovered = false;

  /// Om utløseren (eller en etterkommer) har tastaturfokus.
  bool _focused = false;

  /// Om pekeren er over selve verktøytipset (gjør tipset «hoverable» slik at
  /// pekeren kan krysse mellomrommet inn på tipset uten at det forsvinner).
  bool _overlayHovered = false;

  /// Settes når brukeren lukker tipset med Escape, slik at det holdes skjult
  /// til en ny hover-/fokus-syklus starter (WCAG 1.4.13 «dismissible»).
  bool _dismissed = false;

  /// Avstemmer overlegget mot gjeldende [_hovered]/[_focused]/[_overlayHovered].
  /// Tipset vises så lenge ett av signalene er aktivt og ikke avvist med
  /// Escape, og skjules først når alle er inaktive. Å spore signalene hver for
  /// seg hindrer at tipset forsvinner for tidlig (f.eks. når pekeren forlater
  /// utløseren mens fokus består, eller når pekeren flyttes inn på tipset).
  void _sync() {
    if (!_dismissed && (_hovered || _focused || _overlayHovered)) {
      _show();
    } else {
      _hide();
    }
  }

  void _show() {
    if (_entry != null) return;
    _capturedTheme = DsTheme.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final rect = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    _resolvedPlacement = dsResolvePlacement(
      placement: widget.placement,
      autoPlacement: widget.autoPlacement,
      anchorRect: rect,
      screen: MediaQuery.maybeOf(context)?.size,
    );
    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = _capturedTheme!;
    // Verktøytips bruker alltid nøytral farge per det offisielle Designsystemet
    // og påvirkes ikke av arvet/aktiv farge.
    final neutral = theme.colorScheme.neutral;
    final (targetAnchor, followerAnchor, offset) = dsPlacementAnchors(
      _resolvedPlacement,
      gap: 8,
    );

    return DsTheme(
      data: theme,
      child: DsColorScope(
        color: DsColor.neutral,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              offset: offset,
              // Spor hover på selve tipset slik at pekeren kan krysse
              // mellomrommet inn på tipset uten at det forsvinner (hoverable).
              child: MouseRegion(
                onEnter: (_) {
                  _overlayHovered = true;
                  _sync();
                },
                onExit: (_) {
                  _overlayHovered = false;
                  _sync();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: neutral.baseDefault,
                    borderRadius: BorderRadius.circular(theme.borderRadius.sm),
                    boxShadow: theme.shadows.sm,
                  ),
                  child: Text(
                    widget.message,
                    style: theme.typography.bodyXs.copyWith(
                      color: neutral.baseContrastDefault,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hold et åpent overlegg synkronisert med en arvet temaendring i stedet for
    // å fryse temaet fra det ble vist.
    if (_entry != null) {
      _capturedTheme = DsTheme.of(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _entry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Semantics(
        tooltip: widget.message,
        child: Focus(
          // Vis også ved tastaturfokus (utløser-barnet leverer fokusnoden).
          // canRequestFocus:false unngår et ekstra tab-stopp.
          canRequestFocus: false,
          // Lukk med Escape uten å flytte peker/fokus (WCAG 1.4.13).
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape &&
                _entry != null) {
              _dismissed = true;
              _hide();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          onFocusChange: (hasFocus) {
            _focused = hasFocus;
            // En ny fokus-syklus opphever en tidligere Escape-avvisning.
            if (hasFocus) _dismissed = false;
            _sync();
          },
          child: MouseRegion(
            onEnter: (_) {
              _hovered = true;
              // En ny hover-syklus opphever en tidligere Escape-avvisning.
              _dismissed = false;
              _sync();
            },
            onExit: (_) {
              _hovered = false;
              _sync();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
