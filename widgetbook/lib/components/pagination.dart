import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final paginationComponent = WidgetbookComponent(
  name: 'DsPagination',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final totalPages = context.knobs.double.slider(label: 'Sider', min: 1, max: 10, initialValue: 5).toInt();
        return Center(
          child: DsPagination(
            currentPage: 1,
            totalPages: totalPages,
            onPageChanged: (_) {},
          ),
        );
      },
    ),
  ],
);
