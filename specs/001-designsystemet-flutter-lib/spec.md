# Feature Specification: Designsystemet Flutter Component Library

**Feature Branch**: `001-designsystemet-flutter-lib`
**Created**: 2026-03-14
**Status**: Draft
**Input**: User description: "Flutter component library implementing the Norwegian Designsystemet design system (designsystemet.no) with full token architecture, 40 components, theme portability, and accessibility compliance"

## Clarifications

### Session 2026-03-14

- Q: What is the default size mode when no `DsSizeScope` ancestor is present? → A: `md` (18px base, ~48px component height)
- Q: How should the Inter font be delivered? → A: Bundle Inter (3 weights: 400, 500, 600) as a package asset for zero-setup offline use
- Q: Should the theme API provide only InheritedWidget or also ThemeExtension for Material integration? → A: Both — `DsTheme.of(context)` as primary, plus optional `ThemeExtension<DsThemeData>` for Material app integration

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Theme a Flutter App with Designsystemet (Priority: P1)

A Flutter developer adds the `komponentbibliotek_flutter` package to their project and wraps their app with a `DsTheme` widget using the built-in Digdir theme. All Designsystemet components rendered within the app automatically pick up the correct colors, typography, spacing, border radii, and shadows. The developer can switch between light and dark mode by changing the `brightness` parameter on `DsThemeData`.

**Why this priority**: Without a functioning theme infrastructure, no component can render correctly. This is the foundation that everything else depends on.

**Independent Test**: Can be fully tested by creating a minimal Flutter app, wrapping it in `DsTheme(data: DsThemeData.digdir())`, and verifying that a `DsHeading` widget renders with the correct font family, weight, size, and color from the Digdir theme.

**Acceptance Scenarios**:

1. **Given** a Flutter app with `DsTheme(data: DsThemeData.digdir())` at the root, **When** a `DsHeading` is placed in the widget tree, **Then** it renders using Inter font, medium weight (500), with `neutral.textDefault` color and the correct size for the heading level
2. **Given** a `DsThemeData` with `brightness: Brightness.dark`, **When** components render, **Then** all color tokens reflect the dark color scheme generated from the same base colors
3. **Given** a `DsColorScope(color: DsColor.danger)` wrapping a subtree, **When** components inside that subtree render, **Then** they use the danger color scale instead of the default accent scale
4. **Given** a `DsSizeScope(size: DsSize.lg)` wrapping a subtree, **When** components inside render without an explicit `size` parameter, **Then** they use the large size mode (21px base font, ~56px component height)

---

### User Story 2 - Build a Form with Core Components (Priority: P2)

A Flutter developer builds a registration form using `DsTextfield`, `DsCheckbox`, `DsButton`, and `DsField` (label + validation wrapper). Each component respects the inherited theme and size scope, displays proper error states when validation fails, and meets accessibility standards with correct semantics and focus management.

**Why this priority**: Form components are the most commonly needed UI primitives in government and enterprise apps, which are the primary audience for Designsystemet.

**Independent Test**: Can be fully tested by composing a form with text fields, a checkbox, and a submit button, then verifying visual states (default, hover, focus, error, disabled), keyboard navigation, and screen reader announcements.

**Acceptance Scenarios**:

1. **Given** a `DsTextfield` inside a `DsField` with a label, **When** the user taps the field, **Then** it shows a visible focus ring using `borderStrong` color, and the label is associated via semantics
2. **Given** a `DsTextfield` in error state, **When** rendered, **Then** it displays with the danger color scale's `borderDefault` border and a `DsValidationMessage` showing the error text in `danger.textDefault`
3. **Given** a `DsButton(variant: DsButtonVariant.primary)`, **When** the button is disabled, **Then** it renders at 30% opacity and does not respond to tap events
4. **Given** a `DsButton(loading: true)`, **When** rendered, **Then** the button content is replaced by a `DsSpinner` and tap events are ignored
5. **Given** a `DsCheckbox` with `indeterminate: true`, **When** rendered, **Then** it shows the indeterminate visual state (dash instead of checkmark)

---

### User Story 3 - Display Information with Layout Components (Priority: P3)

A Flutter developer builds a dashboard view using `DsCard`, `DsAlert`, `DsTabs`, `DsTag`, `DsBadge`, and `DsTable` to present structured information. Cards support elevated and bordered variants, alerts convey severity-appropriate messaging, and tabs provide keyboard-navigable panel switching.

**Why this priority**: Information display and navigation components are essential for building complete application views after forms are in place.

**Independent Test**: Can be fully tested by composing a view with cards containing alerts and tags, a tab bar with panels, and a data table, then verifying visual variants, interactive states, and keyboard navigation.

**Acceptance Scenarios**:

1. **Given** a `DsCard(elevated: true)`, **When** rendered, **Then** it has `shadowSm` elevation and no border; a non-elevated card has `borderSubtle` border and no shadow
2. **Given** a `DsAlert(severity: DsSeverity.warning)`, **When** rendered, **Then** it uses the warning color scale with `surfaceTinted` background, `borderDefault` left border (4px), and a warning icon in `baseDefault`
3. **Given** a `DsTabs` with three tabs, **When** the user presses the right arrow key while a tab is focused, **Then** focus moves to the next tab (roving focus pattern) and the associated panel becomes visible
4. **Given** a `DsTag(size: DsSize.sm, color: DsColor.success)`, **When** rendered, **Then** it uses the small size tokens and the success color scale

---

### User Story 4 - Import a Custom Theme from Designsystemet CLI (Priority: P4)

A Flutter developer uses the Designsystemet CLI to generate design tokens from their custom `designsystemet.config.json`, then runs `dart run komponentbibliotek_flutter:generate` to produce typed Dart theme files. They import the generated theme class and apply it to their app, and all components automatically reflect the custom brand colors, typography, spacing, and border radii.

**Why this priority**: Theme portability is a core constitutional principle, but the built-in Digdir theme (P1) must work first. Custom theme import extends value to organizations with their own branding.

**Independent Test**: Can be fully tested by generating tokens from a test config with known color values, running the code generator, and verifying the output Dart file contains the correct `DsThemeData` factory with matching color values for both light and dark schemes.

**Acceptance Scenarios**:

1. **Given** a `designsystemet.config.json` with custom primary color `#FF0000`, **When** tokens are generated via CLI and then `dart run komponentbibliotek_flutter:generate --tokens-dir ./design-tokens --output lib/generated/` is run, **Then** a Dart file is produced containing a `DsThemeData` factory where the accent color scale is derived from `#FF0000`
2. **Given** a generated theme file, **When** applied via `DsTheme(data: GeneratedTheme.light())`, **Then** all components use the custom theme's tokens instead of the Digdir defaults
3. **Given** a config with custom `borderRadius: 8`, **When** the theme is generated, **Then** the `DsBorderRadiusTokens` values reflect the larger radius throughout all components

---

### User Story 5 - Ensure Accessibility Compliance (Priority: P5)

A Flutter developer using the library can be confident that all components meet WCAG 2.1 AA standards out of the box. Every interactive component has proper semantic labels, focus indicators are visible, keyboard navigation works correctly, and the color token system guarantees sufficient contrast ratios.

**Why this priority**: Accessibility is a constitutional non-negotiable and a legal requirement in Norway (universell utforming), but it is tested across all components rather than being a standalone deliverable.

**Independent Test**: Can be fully tested by running automated accessibility checks on each component, verifying `Semantics` widget presence, focus ring visibility, and testing keyboard-only navigation through a form.

**Acceptance Scenarios**:

1. **Given** any interactive component (button, textfield, checkbox, etc.), **When** inspected via Flutter's Semantics debugger, **Then** it has appropriate semantic properties (`label`, `button`, `textField`, `checked`, `enabled`, etc.)
2. **Given** a `DsButton` receiving keyboard focus, **When** rendered, **Then** a visible focus ring appears using `borderStrong` color with sufficient contrast
3. **Given** a `DsRadio` group with three options, **When** the user presses arrow keys, **Then** focus moves between options using the roving focus pattern without requiring Tab
4. **Given** any component with animations, **When** `MediaQuery.of(context).disableAnimations` is true, **Then** animations are suppressed

---

### Edge Cases

- What happens when `DsTheme` is missing from the widget tree? Components MUST throw a descriptive error (not a null pointer exception) indicating that `DsTheme` is required as an ancestor
- What happens when a `DsColorScope` references a custom color key that does not exist in the current theme? Components MUST fall back to the accent color scale and log a warning in debug mode
- What happens when a component receives both a local `size` parameter and is inside a `DsSizeScope`? The local parameter MUST take precedence over the inherited scope
- What happens when `DsTextfield` is used without a `DsField` wrapper? It MUST still render correctly as a standalone input, just without label and validation message
- What happens when very long text is placed in a `DsButton`? The button MUST expand horizontally to fit the text or truncate with ellipsis if constrained, never clip or overflow
- What happens when a `DsCard(onTap: ...)` is nested inside another `DsCard(onTap: ...)`? Only the inner card's tap handler should fire (gesture disambiguation)

## Requirements *(mandatory)*

### Functional Requirements

**Theme Infrastructure:**
- **FR-001**: Library MUST provide a `DsThemeData` class containing all design tokens: color scheme, size tokens, typography, border radii, shadows, and disabled opacity
- **FR-002**: Library MUST provide a `DsTheme` InheritedWidget that makes `DsThemeData` available to all descendant widgets via `DsTheme.of(context)`. Library MUST also provide `DsThemeData` as a `ThemeExtension` so it can optionally be accessed via `Theme.of(context).extension<DsThemeData>()` for Material app integration
- **FR-003**: Library MUST include a built-in Digdir default theme with both light and dark color schemes
- **FR-004**: Library MUST support `DsColorScope` for locally overriding the active color scale in a widget subtree
- **FR-005**: Library MUST support `DsSizeScope` for locally overriding the active size mode (sm, md, lg) in a widget subtree

**Color System:**
- **FR-006**: Each color scale MUST contain exactly 16 tokens across 5 groups: background (2), surface (4), border (3), text (2), base (5)
- **FR-007**: The color scheme MUST provide 9 named semantic color scales: accent, neutral, brand1, brand2, brand3, success, danger, warning, info
- **FR-008**: The color scheme MUST support additional custom-named color scales via a `Map<String, DsColorScale>`
- **FR-009**: Contrast guarantees MUST be maintained: `textDefault` at 4.5:1 against all background/surface colors, `borderDefault` at 3:1 against backgrounds and default surfaces

**Size System:**
- **FR-010**: Library MUST support three size modes: sm (16px base), md (18px base), lg (21px base), each with a numbered scale from size0 through size30
- **FR-011**: Every component that accepts a `size` parameter MUST also inherit the size from the nearest `DsSizeScope` ancestor when `size` is null. When no `DsSizeScope` ancestor is present, the default size mode MUST be `md` (18px base)

**Typography:**
- **FR-012**: Library MUST provide heading text styles at 7 levels (2xs through 2xl) with weight 500, line-height 1.3, and level-appropriate letter-spacing
- **FR-013**: Library MUST provide body text styles at 5 levels (xs through xl) in three variants: default (line-height 1.5), short (1.3), and long (1.7)
- **FR-014**: Default font family MUST be Inter, bundled as a package asset (weights 400, 500, 600) for zero-setup offline use. Font family MUST be configurable via `DsTypography.fontFamily`

**Components (40 total):**
- **FR-015**: Library MUST implement 14 core components: Button, Textfield, Textarea, Checkbox, Radio, Switch, Alert, Card, Tag, Chip, Badge, Spinner, Divider, Link
- **FR-016**: Library MUST implement 14 navigation/layout components: Tabs, Dialog, Dropdown, Select, Pagination, Table, Breadcrumbs, Search, Tooltip, Popover, Avatar, AvatarStack, ToggleGroup, Suggestion
- **FR-017**: Library MUST implement 8 form/utility components: Field, Fieldset, Input, ErrorSummary, Details, List, Skeleton, SkipLink
- **FR-018**: Library MUST implement 4 typography components: Heading, Paragraph, Label, ValidationMessage
- **FR-019**: Every component MUST support all defined visual states (default, hover, focused, active, disabled) with correct token-based styling for each state
- **FR-020**: Disabled state MUST be represented at 30% opacity across all components

**Component API Conventions:**
- **FR-021**: Every component MUST accept optional `size` and `color` parameters that override inherited scope values
- **FR-022**: `DsButton` MUST support three variants (primary, secondary, tertiary), loading state with spinner, and optional leading/trailing icon
- **FR-023**: `DsAlert` MUST support four severity levels (info, warning, success, danger) with severity-appropriate color scale, icon, and optional close button
- **FR-024**: `DsCard` MUST support sub-components (Header, Block, Footer), bordered/elevated variants, and optional clickable behavior with hover state

**Code Generator:**
- **FR-025**: Library MUST provide a `bin/generate.dart` CLI tool that reads W3C-format JSON token files produced by `@digdir/designsystemet` CLI and generates typed Dart theme files
- **FR-026**: Generated theme files MUST include both light and dark `DsThemeData` factory constructors
- **FR-027**: Generator MUST produce one Dart file per theme defined in the token input

**Accessibility:**
- **FR-028**: Every interactive component MUST include proper `Semantics` widget annotations
- **FR-029**: All focusable components MUST display a visible focus indicator using `borderStrong` color
- **FR-030**: Components with grouped options (Tabs, Radio, ToggleGroup) MUST implement roving focus keyboard navigation
- **FR-031**: Components MUST respect `MediaQuery.disableAnimations` to suppress motion for users who prefer reduced motion

**Architecture:**
- **FR-032**: Components MUST NOT depend on Material or Cupertino widget styling; only `package:flutter/widgets.dart` and `package:flutter/rendering.dart` may be used for visual rendering
- **FR-033**: Library MUST be tree-shakable so that unused components are not included in the application bundle
- **FR-034**: Library MUST expose clearly separated entry points: tokens, components, theme importer

### Key Entities

- **DsThemeData**: The complete theme configuration containing all design tokens (colors, sizes, typography, borders, shadows). Passed to `DsTheme` to make tokens available throughout the widget tree
- **DsColorScale**: A single semantic color scale with 16 tokens across 5 groups (background, surface, border, text, base). Represents one purpose (e.g., "danger", "accent") rather than one hue
- **DsColorScheme**: Collection of all 9 named color scales plus custom scales. Determines the full color palette for a theme
- **DsSizeTokens**: Size mode configuration defining the base font size, step value, and all 31 computed size values. Three built-in modes: sm, md, lg
- **DsTypography**: Font family and all heading/body text style definitions, computed from font tokens and the active size mode

### Assumptions

- The Designsystemet CLI (`@digdir/designsystemet` v1.9.0+) generates W3C-compatible JSON tokens in a stable format that can be reliably parsed
- The Inter font (weights 400, 500, 600) is bundled as a package asset, adding ~1MB to the package but requiring no network access or external dependencies
- The Digdir default theme color values are publicly available from the Designsystemet source code and can be hard-coded for the built-in theme
- Components target all Flutter-supported platforms (Android, iOS, Web, macOS, Linux, Windows) with minimum Flutter SDK 3.19+
- The library follows Dart 3.3+ language features (pattern matching, sealed classes) and `flutter_lints` analysis rules

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can add the package to their `pubspec.yaml`, wrap their app with `DsTheme`, and see correctly themed Designsystemet components rendering within 5 minutes of setup
- **SC-002**: All 40 components render visually identical to the Designsystemet reference implementation at https://storybook.designsystemet.no across all three sizes (sm, md, lg) and all applicable color scales
- **SC-003**: Every component passes automated accessibility validation: semantic labels present, focus indicators visible at 3:1 contrast, keyboard navigation functional
- **SC-004**: Custom themes generated from `designsystemet.config.json` via the CLI pipeline produce a working Flutter theme that correctly applies all custom tokens without modifying library source code
- **SC-005**: Golden test coverage exists for every component at every size, color variant, and interactive state, providing visual regression protection
- **SC-006**: Library achieves 100% score on `flutter analyze` with zero warnings or errors under `flutter_lints`
- **SC-007**: Importing only a single component (e.g., `DsButton`) does not pull unused components into the application bundle (tree-shaking verification)
- **SC-008**: Components maintain 60fps during state transitions (hover, focus, press) on mid-range mobile devices
