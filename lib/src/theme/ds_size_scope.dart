import 'package:flutter/widgets.dart';
import '../utils/ds_enums.dart';

class DsSizeScope extends InheritedWidget {
  const DsSizeScope({super.key, required this.size, required super.child});

  final DsSize size;

  static DsSize of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DsSizeScope>();
    return scope?.size ?? DsSize.md;
  }

  @override
  bool updateShouldNotify(DsSizeScope oldWidget) => size != oldWidget.size;
}
