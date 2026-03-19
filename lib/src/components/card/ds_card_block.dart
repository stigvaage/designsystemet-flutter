import 'package:flutter/widgets.dart';

/// A content block section for a [DsCard] with horizontal and vertical padding.
class DsCardBlock extends StatelessWidget {
  const DsCardBlock({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}
