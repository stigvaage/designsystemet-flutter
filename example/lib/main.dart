import 'package:designsystemet_flutter/designsystemet_flutter.dart';
import 'package:designsystemet_flutter/generated/ds_theme_digdir.dart';
import 'package:flutter/widgets.dart';

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
          // DsTextfield/DsTextarea krever en Overlay-stamfar for at
          // tekstmarkering, markeringshåndtak og verktøylinjer skal virke.
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => SingleChildScrollView(
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
                          const DsLabel(text: 'Mørk modus'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Typografi
                      const DsHeading(
                        text: 'Typografi',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      const DsHeading(
                        text: 'Overskrift 2XL',
                        level: DsHeadingLevel.xxl,
                      ),
                      const DsHeading(
                        text: 'Overskrift XL',
                        level: DsHeadingLevel.xl,
                      ),
                      const DsHeading(
                        text: 'Overskrift LG',
                        level: DsHeadingLevel.lg,
                      ),
                      const DsHeading(
                        text: 'Overskrift MD',
                        level: DsHeadingLevel.md,
                      ),
                      const DsParagraph(
                        text: 'Brødtekst (standardvariant, md-størrelse)',
                      ),
                      const DsParagraph(
                        text: 'Brødtekst (kort variant)',
                        variant: DsBodyVariant.short,
                      ),
                      const SizedBox(height: 24),

                      // Knapper
                      const DsHeading(
                        text: 'Knapper',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          DsButton(
                            onPressed: () {},
                            child: const Text('Primær'),
                          ),
                          DsButton(
                            variant: DsButtonVariant.secondary,
                            onPressed: () {},
                            child: const Text('Sekundær'),
                          ),
                          DsButton(
                            variant: DsButtonVariant.tertiary,
                            onPressed: () {},
                            child: const Text('Tertiær'),
                          ),
                          DsButton(
                            disabled: true,
                            onPressed: () {},
                            child: const Text('Deaktivert'),
                          ),
                          DsButton(
                            loading: true,
                            onPressed: () {},
                            child: const Text('Laster'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Størrelsesvarianter
                      const DsLabel(text: 'Størrelsesvarianter:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          DsSizeScope(
                            size: DsSize.sm,
                            child: DsButton(
                              onPressed: () {},
                              child: const Text('Liten'),
                            ),
                          ),
                          DsButton(
                            onPressed: () {},
                            child: const Text('Middels'),
                          ),
                          DsSizeScope(
                            size: DsSize.lg,
                            child: DsButton(
                              onPressed: () {},
                              child: const Text('Stor'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Skjemakontroller
                      const DsHeading(
                        text: 'Skjemakontroller',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      const DsField(
                        label: 'E-post',
                        description: 'Skriv inn e-postadressen din',
                        child: DsTextfield(placeholder: 'navn@eksempel.no'),
                      ),
                      const SizedBox(height: 12),
                      const DsField(
                        label: 'Melding',
                        child: DsTextarea(rows: 3),
                      ),
                      const SizedBox(height: 12),
                      DsCheckbox(
                        value: _checkboxValue,
                        onChanged: (v) => setState(() => _checkboxValue = v),
                        label: const Text('Jeg godtar vilkårene'),
                      ),
                      const SizedBox(height: 24),

                      // Varsler
                      const DsHeading(
                        text: 'Varsler',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      const DsAlert(
                        severity: DsSeverity.info,
                        title: Text('Informasjon'),
                        child: Text('Dette er et informasjonsvarsel.'),
                      ),
                      const SizedBox(height: 8),
                      const DsAlert(
                        severity: DsSeverity.success,
                        child: Text('Operasjonen ble fullført.'),
                      ),
                      const SizedBox(height: 8),
                      const DsAlert(
                        severity: DsSeverity.warning,
                        child: Text('Se gjennom før du fortsetter.'),
                      ),
                      const SizedBox(height: 8),
                      const DsAlert(
                        severity: DsSeverity.danger,
                        closable: true,
                        child: Text('Det oppstod en feil.'),
                      ),
                      const SizedBox(height: 24),

                      // Kort
                      const DsHeading(text: 'Kort', level: DsHeadingLevel.md),
                      const SizedBox(height: 8),
                      const DsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DsCardHeader(child: Text('Kort med kantlinje')),
                            DsCardBlock(
                              child: Text('Standardkort med kantlinje.'),
                            ),
                            DsCardFooter(child: Text('Bunntekst')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const DsCard(
                        elevated: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DsCardHeader(child: Text('Hevet kort')),
                            DsCardBlock(child: Text('Kort med skygge.')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Etiketter og brikker
                      const DsHeading(
                        text: 'Etiketter og brikker',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          DsTag(child: Text('Standard')),
                          DsTag(color: DsColor.success, child: Text('Suksess')),
                          DsTag(color: DsColor.danger, child: Text('Fare')),
                          DsChip(selected: true, child: Text('Valgt brikke')),
                          DsChip(removable: true, child: Text('Fjernbar')),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Faner
                      const DsHeading(text: 'Faner', level: DsHeadingLevel.md),
                      const SizedBox(height: 8),
                      DsTabs(
                        tabs: const ['Oversikt', 'Detaljer', 'Innstillinger'],
                        initialIndex: _selectedTab,
                        onChanged: (i) => setState(() => _selectedTab = i),
                        children: const [
                          DsParagraph(text: 'Innhold for oversikt vises her.'),
                          DsParagraph(text: 'Innhold for detaljer vises her.'),
                          DsParagraph(
                            text: 'Innhold for innstillinger vises her.',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Vekslergruppe
                      const DsHeading(
                        text: 'Vekslergruppe',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      DsToggleGroup(
                        items: const ['Dag', 'Uke', 'Måned'],
                        selectedIndex: _selectedToggle,
                        onChanged: (i) => setState(() => _selectedToggle = i),
                      ),
                      const SizedBox(height: 24),

                      // Paginering
                      const DsHeading(
                        text: 'Paginering',
                        level: DsHeadingLevel.md,
                      ),
                      const SizedBox(height: 8),
                      DsPagination(
                        currentPage: _currentPage,
                        totalPages: 5,
                        onPageChanged: (p) => setState(() => _currentPage = p),
                      ),
                      const SizedBox(height: 24),

                      // Merke
                      const DsHeading(text: 'Merke', level: DsHeadingLevel.md),
                      const SizedBox(height: 8),
                      const DsBadge(
                        count: 3,
                        child: DsAvatar(name: 'Ola Nordmann'),
                      ),
                      const SizedBox(height: 24),

                      // Skillelinje
                      const DsDivider(),
                      const SizedBox(height: 8),
                      // MERK: oppdater denne versjonen sammen med pubspec.yaml og
                      // CHANGELOG.md ved hver release.
                      const DsParagraph(
                        text: 'designsystemet_flutter v0.3.0',
                        bodySize: DsBodySize.xs,
                        color: DsColor.neutral,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
