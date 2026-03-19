import 'package:flutter/widgets.dart';
import '../utils/ds_enums.dart';

/// Inherited widget that sets the default [DsColor] for descendant components.
///
/// Components that accept an optional `color` parameter fall back to
/// [DsColorScope.of] when no explicit color is provided. Defaults to [DsColor.accent].
class DsColorScope extends InheritedWidget {
  const DsColorScope({super.key, required this.color, required super.child});

  final DsColor color;

  static DsColor of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DsColorScope>();
    return scope?.color ?? DsColor.accent;
  }

  @override
  bool updateShouldNotify(DsColorScope oldWidget) => color != oldWidget.color;
}
