# Data Model: Designsystemet Flutter Component Library

**Feature**: 001-designsystemet-flutter-lib
**Date**: 2026-03-14

## Core Token Entities

### DsColorScale

A single semantic color scale with 16 tokens across 5 groups.

| Field | Type | Description |
|-------|------|-------------|
| backgroundDefault | Color | Large surface area fill |
| backgroundTinted | Color | Tinted variant of background |
| surfaceDefault | Color | Card/panel surface fill |
| surfaceTinted | Color | Tinted surface variant |
| surfaceHover | Color | Surface on pointer hover |
| surfaceActive | Color | Surface on press/active |
| borderSubtle | Color | Low-emphasis stroke |
| borderDefault | Color | Standard stroke (≥3:1 vs backgrounds) |
| borderStrong | Color | High-emphasis stroke (≥3:1 vs all surfaces) |
| textSubtle | Color | Secondary text (≥4.5:1 vs backgrounds + default surfaces) |
| textDefault | Color | Primary text (≥4.5:1 vs all backgrounds + surfaces) |
| baseDefault | Color | Solid fill (buttons, badges) |
| baseHover | Color | Solid fill on hover |
| baseActive | Color | Solid fill on press |
| baseContrastSubtle | Color | Text on base-default (≥4.5:1) |
| baseContrastDefault | Color | Text on base-default AND base-hover (≥4.5:1) |

**Identity**: Scales are identified by semantic name (accent, neutral, brand1, etc.)
**Immutability**: All fields are final; a new instance is created for theme switching.
**Invariant**: Contrast ratios between token pairs must meet WCAG 2.1 AA thresholds as specified above.

### DsColorScheme

Collection of all color scales for a theme.

| Field | Type | Description |
|-------|------|-------------|
| accent | DsColorScale | Primary interactive color |
| neutral | DsColorScale | Neutral/gray scale |
| brand1 | DsColorScale | First brand color |
| brand2 | DsColorScale | Second brand color |
| brand3 | DsColorScale | Third brand color |
| success | DsColorScale | Success/positive semantic |
| danger | DsColorScale | Error/destructive semantic |
| warning | DsColorScale | Warning/caution semantic |
| info | DsColorScale | Informational semantic |
| custom | Map\<String, DsColorScale\> | User-defined additional scales |

**Lookup**: `resolve(DsColor)` returns the appropriate `DsColorScale` by enum value or custom key.
**Default color**: When no `DsColorScope` is set, components use `accent`.

### DsSizeTokens

Size mode configuration with computed scale values.

| Field | Type | Description |
|-------|------|-------------|
| base | double | Base font size in logical pixels (sm=16, md=18, lg=21) |
| step | double | Step increment (default: 4) |
| size0–size30 | double | 31 computed size values |
| sizeUnit | double | Derived unit value |

**Computation**: `sizeN = base + (step * N)` for the linear range (exact formula to be confirmed from CLI source).
**Default mode**: `md` when no `DsSizeScope` ancestor is present.

### DsTypography

All text style definitions for the theme.

| Field | Type | Description |
|-------|------|-------------|
| fontFamily | String | Default: "Inter" (configurable) |
| heading2xl–heading2xs | TextStyle | 7 heading levels (weight 500, line-height 1.3) |
| bodyXl–bodyXs | TextStyle | 5 body sizes, default line-height 1.5 |
| bodyShortXl–bodyShortXs | TextStyle | 5 body sizes, line-height 1.3 |
| bodyLongXl–bodyLongXs | TextStyle | 5 body sizes, line-height 1.7 |

**Font weights**: 400 (body), 500 (headings), 600 (semibold — available for emphasis).
**Letter-spacing**: Varies by level (-0.01em for 2xl through +0.015em for 2xs).
**Size dependency**: Font sizes are computed from the active `DsSizeTokens`.

### DsBorderRadiusTokens

| Field | Type | Description |
|-------|------|-------------|
| sm | double | Small radius |
| md | double | Medium radius |
| lg | double | Large radius |
| xl | double | Extra-large radius |
| defaultRadius | double | Standard component radius |
| full | double | Pill/circle (9999) |

**Computation**: Derived from `base` and `scale` config values.

### DsShadowTokens

| Field | Type | Description |
|-------|------|-------------|
| xs | List\<BoxShadow\> | 2 layers |
| sm | List\<BoxShadow\> | 3 layers |
| md | List\<BoxShadow\> | 3 layers |
| lg | List\<BoxShadow\> | 3 layers |
| xl | List\<BoxShadow\> | 3 layers |

**Values**: Fixed (not theme-dependent). Black with varying opacity, offset, and blur.

### DsThemeData

Top-level theme configuration aggregating all token categories.

| Field | Type | Description |
|-------|------|-------------|
| brightness | Brightness | light or dark |
| colorScheme | DsColorScheme | All color scales |
| sizeTokens | DsSizeTokens | Active size mode tokens |
| typography | DsTypography | Text styles |
| borderRadius | DsBorderRadiusTokens | Border radius tokens |
| shadows | DsShadowTokens | Shadow tokens |
| disabledOpacity | double | 0.3 for disabled state |

**Factories**: `DsThemeData.digdir()` (built-in), `DsThemeData.fromTokens(Map<String, dynamic>)` (from JSON).
**ThemeExtension**: Also extends `ThemeExtension<DsThemeData>` for Material integration.

## Scope Entities

### DsColor (enum + custom)

Identifies which color scale to use.

| Value | Maps to |
|-------|---------|
| accent | DsColorScheme.accent |
| neutral | DsColorScheme.neutral |
| brand1 | DsColorScheme.brand1 |
| brand2 | DsColorScheme.brand2 |
| brand3 | DsColorScheme.brand3 |
| success | DsColorScheme.success |
| danger | DsColorScheme.danger |
| warning | DsColorScheme.warning |
| info | DsColorScheme.info |
| custom(String key) | DsColorScheme.custom[key] |

### DsSize (enum)

| Value | Base | Step | Typical height |
|-------|------|------|---------------|
| sm | 16 | 4 | ~36px |
| md | 18 | 4 | ~48px |
| lg | 21 | 4 | ~56px |

## Component Variant Enums

| Enum | Values | Used by |
|------|--------|---------|
| DsButtonVariant | primary, secondary, tertiary | DsButton |
| DsIconPosition | left, right | DsButton |
| DsSeverity | info, warning, success, danger | DsAlert |
| DsHeadingLevel | xxl, xl, lg, md, sm, xs, xxs | DsHeading |
| DsBodySize | xl, lg, md, sm, xs | DsParagraph |
| DsBodyVariant | standard, short, long | DsParagraph |
| DsBadgePlacement | topRight, topLeft, bottomRight, bottomLeft | DsBadge |

## Relationships

```text
DsTheme (InheritedWidget)
  └── DsThemeData
        ├── DsColorScheme
        │     ├── DsColorScale (accent)
        │     ├── DsColorScale (neutral)
        │     ├── DsColorScale (brand1..3)
        │     ├── DsColorScale (success, danger, warning, info)
        │     └── Map<String, DsColorScale> (custom)
        ├── DsSizeTokens
        ├── DsTypography
        ├── DsBorderRadiusTokens
        └── DsShadowTokens

DsColorScope (InheritedWidget)
  └── overrides active DsColor for subtree

DsSizeScope (InheritedWidget)
  └── overrides active DsSize for subtree

Component
  ├── reads DsTheme.of(context) for tokens
  ├── reads DsColorScope.of(context) for active color (default: accent)
  └── reads DsSizeScope.of(context) for active size (default: md)
```

## State Transitions (interactive components)

```text
default ──hover──→ hovered
default ──focus──→ focused
default ──press──→ active
any ─────disable─→ disabled (0.3 opacity, no interaction)
any ─────error───→ error (danger color scale for borders/text)
button ──load────→ loading (spinner replaces content, no interaction)
```

States are not mutually exclusive: a component can be focused AND hovered simultaneously.
Disabled state overrides all other visual states.
