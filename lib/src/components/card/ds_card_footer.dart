import 'package:flutter/widgets.dart';

/// Footer section for a [DsCard], providing bottom-aligned padding.
class DsCardFooter extends StatelessWidget {
  const DsCardFooter({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: child,
    );
  }
}
