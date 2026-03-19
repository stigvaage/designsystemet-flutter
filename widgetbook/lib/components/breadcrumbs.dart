import 'package:flutter/widgets.dart';
import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final breadcrumbsComponent = WidgetbookComponent(
  name: 'DsBreadcrumbs',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => const Center(
        child: DsBreadcrumbs(items: ['Hjem', 'Komponenter', 'DsBreadcrumbs']),
      ),
    ),
  ],
);
