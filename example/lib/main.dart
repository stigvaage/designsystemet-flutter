import 'package:flutter/widgets.dart';
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:komponentbibliotek_flutter/generated/ds_theme_digdir.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  var _isDark = false;
  var _checkboxValue = false;
  // ignore: unused_field
  var _switchValue = false;
  var _selectedTab = 0;
  var _selectedToggle = 0;
  var _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return DsTheme(
      data: _isDark ? DsThemeDigdir.dark() : DsThemeDigdir.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: _isDark
              ? DsThemeDigdir.dark().colorScheme.neutral.backgroundDefault
              : DsThemeDigdir.light().colorScheme.neutral.backgroundDefault,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme toggle
                Row(
                  children: [
                    const DsHeading(
                      text: 'Designsystemet Flutter',
                      level: DsHeadingLevel.lg,
                    ),
                    const SizedBox(width: 16),
                    DsSwitch(
                      value: _isDark,
                      onChanged: (v) => setState(() => _isDark = v),
                    ),
                    const SizedBox(width: 8),
                    const DsLabel(text: 'Dark mode'),
                  ],
                ),
                const SizedBox(height: 24),

                // Typography
                const DsHeading(text: 'Typography', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                const DsHeading(text: 'Heading 2XL', level: DsHeadingLevel.xxl),
                const DsHeading(text: 'Heading XL', level: DsHeadingLevel.xl),
                const DsHeading(text: 'Heading LG', level: DsHeadingLevel.lg),
                const DsHeading(text: 'Heading MD', level: DsHeadingLevel.md),
                const DsParagraph(text: 'Body text (default variant, md size)'),
                const DsParagraph(
                  text: 'Body text (short variant)',
                  variant: DsBodyVariant.short,
                ),
                const SizedBox(height: 24),

                // Buttons
                const DsHeading(text: 'Buttons', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    DsButton(
                      onPressed: () {},
                      child: const Text('Primary'),
                    ),
                    DsButton(
                      variant: DsButtonVariant.secondary,
                      onPressed: () {},
                      child: const Text('Secondary'),
                    ),
                    DsButton(
                      variant: DsButtonVariant.tertiary,
                      onPressed: () {},
                      child: const Text('Tertiary'),
                    ),
                    DsButton(
                      disabled: true,
                      onPressed: () {},
                      child: const Text('Disabled'),
                    ),
                    DsButton(
                      loading: true,
                      onPressed: () {},
                      child: const Text('Loading'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Size variants
                const DsLabel(text: 'Size variants:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    DsSizeScope(
                      size: DsSize.sm,
                      child: DsButton(
                        onPressed: () {},
                        child: const Text('Small'),
                      ),
                    ),
                    DsButton(
                      onPressed: () {},
                      child: const Text('Medium'),
                    ),
                    DsSizeScope(
                      size: DsSize.lg,
                      child: DsButton(
                        onPressed: () {},
                        child: const Text('Large'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form controls
                const DsHeading(text: 'Form Controls', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                const DsField(
                  label: 'Email',
                  description: 'Enter your email address',
                  child: DsTextfield(placeholder: 'name@example.com'),
                ),
                const SizedBox(height: 12),
                const DsField(
                  label: 'Message',
                  child: DsTextarea(rows: 3),
                ),
                const SizedBox(height: 12),
                DsCheckbox(
                  value: _checkboxValue,
                  onChanged: (v) => setState(() => _checkboxValue = v),
                  label: const Text('I agree to the terms'),
                ),
                const SizedBox(height: 24),

                // Alerts
                const DsHeading(text: 'Alerts', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                const DsAlert(
                  severity: DsSeverity.info,
                  title: Text('Information'),
                  child: Text('This is an info alert.'),
                ),
                const SizedBox(height: 8),
                const DsAlert(
                  severity: DsSeverity.success,
                  child: Text('Operation completed successfully.'),
                ),
                const SizedBox(height: 8),
                const DsAlert(
                  severity: DsSeverity.warning,
                  child: Text('Please review before proceeding.'),
                ),
                const SizedBox(height: 8),
                const DsAlert(
                  severity: DsSeverity.danger,
                  closable: true,
                  child: Text('An error occurred.'),
                ),
                const SizedBox(height: 24),

                // Cards
                const DsHeading(text: 'Cards', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                const DsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DsCardHeader(child: Text('Bordered Card')),
                      DsCardBlock(child: Text('Default card with border.')),
                      DsCardFooter(child: Text('Footer')),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const DsCard(
                  elevated: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DsCardHeader(child: Text('Elevated Card')),
                      DsCardBlock(child: Text('Card with shadow.')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tags and Chips
                const DsHeading(text: 'Tags & Chips', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const DsTag(child: Text('Default')),
                    DsTag(color: DsColor.success, child: const Text('Success')),
                    DsTag(color: DsColor.danger, child: const Text('Danger')),
                    DsChip(
                      selected: true,
                      child: const Text('Selected Chip'),
                    ),
                    DsChip(
                      removable: true,
                      child: const Text('Removable'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tabs
                const DsHeading(text: 'Tabs', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                DsTabs(
                  tabs: const ['Overview', 'Details', 'Settings'],
                  initialIndex: _selectedTab,
                  onChanged: (i) => setState(() => _selectedTab = i),
                  children: const [
                    DsParagraph(text: 'Overview content goes here.'),
                    DsParagraph(text: 'Details content goes here.'),
                    DsParagraph(text: 'Settings content goes here.'),
                  ],
                ),
                const SizedBox(height: 24),

                // Toggle Group
                const DsHeading(text: 'Toggle Group', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                DsToggleGroup(
                  items: const ['Day', 'Week', 'Month'],
                  selectedIndex: _selectedToggle,
                  onChanged: (i) => setState(() => _selectedToggle = i),
                ),
                const SizedBox(height: 24),

                // Pagination
                const DsHeading(text: 'Pagination', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                DsPagination(
                  currentPage: _currentPage,
                  totalPages: 5,
                  onPageChanged: (p) => setState(() => _currentPage = p),
                ),
                const SizedBox(height: 24),

                // Badge
                const DsHeading(text: 'Badge', level: DsHeadingLevel.md),
                const SizedBox(height: 8),
                const DsBadge(
                  count: 3,
                  child: DsAvatar(name: 'John Doe'),
                ),
                const SizedBox(height: 24),

                // Divider
                const DsDivider(),
                const SizedBox(height: 8),
                DsParagraph(
                  text: 'komponentbibliotek_flutter v0.0.1',
                  bodySize: DsBodySize.xs,
                  color: DsColor.neutral,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
