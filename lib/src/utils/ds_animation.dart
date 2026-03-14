import 'package:flutter/widgets.dart';

class DsAnimation {
  DsAnimation._();

  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);

  static const Curve defaultCurve = Curves.easeInOut;

  static Duration resolveDuration(BuildContext context, Duration duration) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return disableAnimations ? Duration.zero : duration;
  }

  static bool shouldAnimate(BuildContext context) {
    return !(MediaQuery.maybeOf(context)?.disableAnimations ?? false);
  }
}
