import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

const _cities = [
  DsSuggestionOption(value: 'oslo', label: 'Oslo'),
  DsSuggestionOption(value: 'bergen', label: 'Bergen'),
  DsSuggestionOption(value: 'trondheim', label: 'Trondheim'),
  DsSuggestionOption(value: 'stavanger', label: 'Stavanger'),
  DsSuggestionOption(value: 'tromso', label: 'Tromsø'),
];

final suggestionComponent = WidgetbookComponent(
  name: 'DsSuggestion',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: DsSuggestion<String>(
          options: _cities,
          placeholder: 'Velg by',
          onSelectedChanged: (_) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Flervalg (multiple)',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: DsSuggestion<String>(
          options: _cities,
          multiple: true,
          placeholder: 'Velg byer',
          onSelectedChanged: (_) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Kan opprette (creatable)',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: DsSuggestion<String>(
          options: _cities,
          creatable: true,
          onCreate: (q) => q,
          placeholder: 'Velg eller opprett',
          onSelectedChanged: (_) {},
        ),
      ),
    ),
  ],
);
