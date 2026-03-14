import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

final skeletonComponent = WidgetbookComponent(
  name: 'DsSkeleton',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) {
        final width = context.knobs.double.slider(label: 'Bredde', min: 50, max: 400, initialValue: 200);
        final height = context.knobs.double.slider(label: 'Høyde', min: 10, max: 60, initialValue: 20);
        return Center(child: DsSkeleton(width: width, height: height));
      },
    ),
  ],
);
