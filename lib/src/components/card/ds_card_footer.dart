import 'package:flutter/widgets.dart';

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
