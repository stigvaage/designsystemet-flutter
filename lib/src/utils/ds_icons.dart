import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Curated icon set for the Designsystemet component library.
///
/// Internal icons are used by components; common UI icons are provided as
/// convenience for consumers. For the full Lucide catalogue, use
/// [LucideIcons] directly (re-exported from `theme.dart`).
abstract final class DsIcons {
  // ── Internal (used by components) ──────────────────────────────────────

  static const IconData info = LucideIcons.info;
  static const IconData triangleAlert = LucideIcons.triangleAlert;
  static const IconData circleCheck = LucideIcons.circleCheck;
  static const IconData circleX = LucideIcons.circleX;
  static const IconData x = LucideIcons.x;
  static const IconData chevronDown = LucideIcons.chevronDown;
  static const IconData chevronRight = LucideIcons.chevronRight;
  static const IconData search = LucideIcons.search;

  // ── Common UI (convenience for consumers) ──────────────────────────────

  static const IconData plus = LucideIcons.plus;
  static const IconData minus = LucideIcons.minus;
  static const IconData check = LucideIcons.check;
  static const IconData edit = LucideIcons.pencil;
  static const IconData trash = LucideIcons.trash2;
  static const IconData settings = LucideIcons.settings;
  static const IconData user = LucideIcons.user;
  static const IconData home = LucideIcons.house;
  static const IconData send = LucideIcons.send;
  static const IconData download = LucideIcons.download;
  static const IconData upload = LucideIcons.upload;
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;
  static const IconData externalLink = LucideIcons.externalLink;
  static const IconData copy = LucideIcons.copy;
  static const IconData arrowLeft = LucideIcons.arrowLeft;
  static const IconData arrowRight = LucideIcons.arrowRight;
  static const IconData menu = LucideIcons.menu;
}
