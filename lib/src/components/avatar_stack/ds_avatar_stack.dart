import 'package:flutter/widgets.dart';

import '../../utils/ds_enums.dart';

class DsAvatarStack extends StatelessWidget {
  const DsAvatarStack({
    super.key,
    required this.children,
    this.maxVisible = 5,
    this.overlap = 8,
    this.size,
  });

  final List<Widget> children;
  final int maxVisible;
  final double overlap;
  final DsSize? size;

  @override
  Widget build(BuildContext context) {
    final visible = children.take(maxVisible).toList();
    return SizedBox(
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (48 - overlap),
              child: visible[i],
            ),
        ],
      ),
    );
  }
}
