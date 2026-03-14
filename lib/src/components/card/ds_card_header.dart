import 'package:flutter/widgets.dart';

class DsCardHeader extends StatelessWidget {
  const DsCardHeader({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: child,
    );
  }
}
