import 'package:widgetbook/widgetbook.dart';

import 'components/alert.dart';
import 'components/avatar.dart';
import 'components/badge.dart';
import 'components/breadcrumbs.dart';
import 'components/button.dart';
import 'components/card.dart';
import 'components/checkbox.dart';
import 'components/chip.dart';
import 'components/details.dart';
import 'components/dialog.dart';
import 'components/divider.dart';
import 'components/dropdown.dart';
import 'components/error_summary.dart';
import 'components/field.dart';
import 'components/fieldset.dart';
import 'components/input.dart';
import 'components/link.dart';
import 'components/list_component.dart';
import 'components/pagination.dart';
import 'components/popover.dart';
import 'components/radio.dart';
import 'components/search.dart';
import 'components/select.dart';
import 'components/skeleton.dart';
import 'components/skip_link.dart';
import 'components/spinner.dart';
import 'components/suggestion.dart';
import 'components/switch_component.dart';
import 'components/table.dart';
import 'components/tabs.dart';
import 'components/tag.dart';
import 'components/textarea.dart';
import 'components/textfield.dart';
import 'components/toggle_group.dart';
import 'components/tooltip.dart';
import 'components/typography.dart';

final widgetbookComponents = <WidgetbookNode>[
  WidgetbookFolder(
    name: 'Kjernekomponenter',
    children: [
      buttonComponent,
      textfieldComponent,
      textareaComponent,
      checkboxComponent,
      radioComponent,
      switchComponent,
      alertComponent,
      cardComponent,
      tagComponent,
      chipComponent,
      badgeComponent,
      spinnerComponent,
      dividerComponent,
      linkComponent,
    ],
  ),
  WidgetbookFolder(
    name: 'Navigasjon og layout',
    children: [
      tabsComponent,
      dialogComponent,
      dropdownComponent,
      selectComponent,
      paginationComponent,
      tableComponent,
      breadcrumbsComponent,
      searchComponent,
      tooltipComponent,
      popoverComponent,
      avatarComponent,
      avatarStackComponent,
      toggleGroupComponent,
      suggestionComponent,
    ],
  ),
  WidgetbookFolder(
    name: 'Skjema og verktøy',
    children: [
      fieldComponent,
      fieldsetComponent,
      inputComponent,
      errorSummaryComponent,
      detailsComponent,
      listComponent,
      skeletonComponent,
      skipLinkComponent,
    ],
  ),
  WidgetbookFolder(
    name: 'Typografi',
    children: [
      headingComponent,
      paragraphComponent,
      labelComponent,
      validationMessageComponent,
    ],
  ),
];
