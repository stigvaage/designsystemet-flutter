import 'package:flutter/widgets.dart';

import 'ds_enums.dart';

/// Returns `(targetAnchor, followerAnchor, offset)` for positioning an overlay
/// relative to its anchor with [CompositedTransformFollower], for the given
/// [placement]. [gap] is the pixel distance between anchor and overlay.
(Alignment, Alignment, Offset) dsPlacementAnchors(
  DsPlacement placement, {
  double gap = 4,
}) {
  return switch (placement) {
    DsPlacement.top => (
      Alignment.topCenter,
      Alignment.bottomCenter,
      Offset(0, -gap),
    ),
    DsPlacement.topStart => (
      Alignment.topLeft,
      Alignment.bottomLeft,
      Offset(0, -gap),
    ),
    DsPlacement.topEnd => (
      Alignment.topRight,
      Alignment.bottomRight,
      Offset(0, -gap),
    ),
    DsPlacement.bottom => (
      Alignment.bottomCenter,
      Alignment.topCenter,
      Offset(0, gap),
    ),
    DsPlacement.bottomStart => (
      Alignment.bottomLeft,
      Alignment.topLeft,
      Offset(0, gap),
    ),
    DsPlacement.bottomEnd => (
      Alignment.bottomRight,
      Alignment.topRight,
      Offset(0, gap),
    ),
    DsPlacement.left => (
      Alignment.centerLeft,
      Alignment.centerRight,
      Offset(-gap, 0),
    ),
    DsPlacement.leftStart => (
      Alignment.topLeft,
      Alignment.topRight,
      Offset(-gap, 0),
    ),
    DsPlacement.leftEnd => (
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Offset(-gap, 0),
    ),
    DsPlacement.right => (
      Alignment.centerRight,
      Alignment.centerLeft,
      Offset(gap, 0),
    ),
    DsPlacement.rightStart => (
      Alignment.topRight,
      Alignment.topLeft,
      Offset(gap, 0),
    ),
    DsPlacement.rightEnd => (
      Alignment.bottomRight,
      Alignment.bottomLeft,
      Offset(gap, 0),
    ),
  };
}

bool _isVertical(DsPlacement p) =>
    p.name.startsWith('top') || p.name.startsWith('bottom');
bool _isTopSide(DsPlacement p) => p.name.startsWith('top');
bool _isLeftSide(DsPlacement p) => p.name.startsWith('left');

DsPlacement _flip(DsPlacement p) => switch (p) {
  DsPlacement.top => DsPlacement.bottom,
  DsPlacement.topStart => DsPlacement.bottomStart,
  DsPlacement.topEnd => DsPlacement.bottomEnd,
  DsPlacement.bottom => DsPlacement.top,
  DsPlacement.bottomStart => DsPlacement.topStart,
  DsPlacement.bottomEnd => DsPlacement.topEnd,
  DsPlacement.left => DsPlacement.right,
  DsPlacement.leftStart => DsPlacement.rightStart,
  DsPlacement.leftEnd => DsPlacement.rightEnd,
  DsPlacement.right => DsPlacement.left,
  DsPlacement.rightStart => DsPlacement.leftStart,
  DsPlacement.rightEnd => DsPlacement.leftEnd,
};

/// Resolves [placement] for an overlay whose anchor occupies [anchorRect] in a
/// viewport of size [screen]. When [autoPlacement] is true, flips to the
/// opposite side along the main axis if that side has more room. Returns
/// [placement] unchanged when measurements are unavailable.
///
/// Begrensninger (avviker fra floating-ui): flip-avgjørelsen er basert
/// utelukkende på rommet mellom ankerets kant og visningsportkanten — den tar
/// ikke hensyn til overleggets egen målte innholdsstørrelse. Et `top`-overlegg
/// med rikelig absolutt plass over ankeret, men med innhold som er høyere enn
/// den plassen, vil derfor ikke flippe. Funksjonen utfører heller ingen
/// «shift»/klipping mot visningsporten, så `DsPopover`/`DsTooltip` kan tegnes
/// delvis utenfor skjermen. (`DsSelect`/`DsSuggestion` begrenser i stedet
/// nedtrekkshøyden mot tilgjengelig plass.)
DsPlacement dsResolvePlacement({
  required DsPlacement placement,
  required bool autoPlacement,
  Rect? anchorRect,
  Size? screen,
}) {
  if (!autoPlacement || anchorRect == null || screen == null) return placement;
  if (_isVertical(placement)) {
    final above = anchorRect.top;
    final below = screen.height - anchorRect.bottom;
    if (_isTopSide(placement) ? below > above : above > below) {
      return _flip(placement);
    }
    return placement;
  }
  final left = anchorRect.left;
  final right = screen.width - anchorRect.right;
  if (_isLeftSide(placement) ? right > left : left > right) {
    return _flip(placement);
  }
  return placement;
}
