import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class _PaginationPreview extends StatefulWidget {
  const _PaginationPreview({required this.totalPages});
  final int totalPages;

  @override
  State<_PaginationPreview> createState() => _PaginationPreviewState();
}

class _PaginationPreviewState extends State<_PaginationPreview> {
  int _currentPage = 1;

  @override
  void didUpdateWidget(covariant _PaginationPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentPage > widget.totalPages) {
      _currentPage = widget.totalPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DsPagination(
        currentPage: _currentPage,
        totalPages: widget.totalPages,
        onPageChanged: (page) => setState(() => _currentPage = page),
      ),
    );
  }
}

final paginationComponent = WidgetbookComponent(
  name: 'DsPagination',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final totalPages = context.knobs.double
            .slider(label: 'Sider', min: 1, max: 10, initialValue: 5)
            .toInt();
        return _PaginationPreview(totalPages: totalPages);
      },
    ),
  ],
);
