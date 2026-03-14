# Research: Designsystemet Flutter Component Library

**Feature**: 001-designsystemet-flutter-lib
**Date**: 2026-03-14
**Sources**: Context7 `/digdir/designsystemet` docs, Designsystemet GitHub wiki, CLI README, training data

## 1. Token Generation Pipeline

### Decision: Use W3C DTCG JSON format as code generator input

**Rationale**: The `@digdir/designsystemet` CLI (`tokens create` command) generates W3C Design Tokens Community Group (DTCG) format JSON files. This is the canonical output format and the only stable contract for token consumption.

**CLI usage**:
```bash
npx @digdir/designsystemet tokens create --config designsystemet.config.json
# or with --clean flag for updates
npx @digdir/designsystemet tokens create --config designsystemet.config.json --clean
```

**Config structure** (`designsystemet.config.json`):
```json
{
  "$schema": "node_modules/@digdir/designsystemet/dist/config.schema.json",
  "outDir": "./design-tokens",
  "themes": {
    "<theme-name>": {
      "colors": {
        "main": { "primary": "#0062BA", "accent": "#1E98F5" },
        "neutral": "#1E2B3C",
        "support": { "extra1": "#F45F63", "extra2": "#E5AA20" }
      },
      "borderRadius": 4,
      "typography": { "fontFamily": "Inter" },
      "overrides": {
        "colors": {
          "primary": {
            "background-default": { "light": "#ff0000", "dark": "#000fff" },
            "text-default": { "light": "#00ff00", "dark": "#00ffff" }
          }
        },
        "severity": {
          "success": "#28a745",
          "warning": "#ffc107",
          "danger": "#dc3545",
          "info": "#17a2b8"
        }
      }
    }
  }
}
```

**Output directory structure** (`design-tokens/`):
```
design-tokens/
├── primitives/
│   ├── colors/
│   │   ├── light.json
│   │   ├── dark.json
│   │   └── contrast.json
│   ├── size.json
│   └── typography.json
└── themes/
    └── <theme-name>/
        ├── light.json
        ├── dark.json
        ├── contrast.json
        └── global.json
```

**DTCG JSON format** (each token file):
```json
{
  "color": {
    "accent": {
      "background-default": { "$value": "#fefeff", "$type": "color" },
      "background-tinted": { "$value": "#eef4fa", "$type": "color" },
      "surface-default": { "$value": "#dde9f3", "$type": "color" },
      "surface-hover": { "$value": "#ccdff0", "$type": "color" },
      "surface-active": { "$value": "#b3cfe5", "$type": "color" },
      "border-subtle": { "$value": "#99c0db", "$type": "color" },
      "border-default": { "$value": "#5a9ac4", "$type": "color" },
      "border-strong": { "$value": "#2b7bb5", "$type": "color" },
      "base-default": { "$value": "#0062BA", "$type": "color" },
      "base-hover": { "$value": "#004d94", "$type": "color" },
      "base-active": { "$value": "#003b73", "$type": "color" },
      "text-subtle": { "$value": "#1a5c97", "$type": "color" },
      "text-default": { "$value": "#003052", "$type": "color" },
      "base-contrast-subtle": { "$value": "#d4e4f0", "$type": "color" },
      "base-contrast-default": { "$value": "#ffffff", "$type": "color" }
    }
  }
}
```

**Alternatives considered**:
- Parse CSS custom properties directly → rejected (CSS is a compiled output, not the stable contract; JSON is the canonical intermediate format)
- Use the config JSON directly and recompute colors → rejected (color algorithm uses CIE LCh color space with complex contrast computation; duplicating this is error-prone)

## 2. Color System Architecture

### Decision: Map DTCG semantic token names to DsColorScale fields

**Rationale**: The CLI outputs 15-16 semantically named tokens per color scale (not numbered). These names directly map to the `DsColorScale` class fields.

**Token name → Dart field mapping**:

| DTCG token name | DsColorScale field |
|-----------------|-------------------|
| `background-default` | `backgroundDefault` |
| `background-tinted` | `backgroundTinted` |
| `surface-default` | `surfaceDefault` |
| `surface-tinted` | `surfaceTinted` |
| `surface-hover` | `surfaceHover` |
| `surface-active` | `surfaceActive` |
| `border-subtle` | `borderSubtle` |
| `border-default` | `borderDefault` |
| `border-strong` | `borderStrong` |
| `text-subtle` | `textSubtle` |
| `text-default` | `textDefault` |
| `base-default` | `baseDefault` |
| `base-hover` | `baseHover` |
| `base-active` | `baseActive` |
| `base-contrast-subtle` | `baseContrastSubtle` |
| `base-contrast-default` | `baseContrastDefault` |

**Color scale categories in the scheme**:
- `main` colors in config → become named scales (first is `primary`/`accent`, rest are `brand1`, `brand2`, etc.)
- `neutral` → becomes `neutral` scale
- `support` → named support colors
- Severity colors (`success`, `danger`, `warning`, `info`) → auto-generated or overridden via `overrides.severity`

**Alternatives considered**:
- Use numbered tokens (1-16) → rejected (CLI outputs semantic names, not numbers)
- Flatten all scales into one map → rejected (typed DsColorScale class provides compile-time safety)

## 3. CSS Component Patterns (for Flutter porting)

### Decision: Port CSS class + data-attribute patterns to InheritedWidget + custom painting

**Rationale**: The web implementation uses CSS classes with `data-*` attributes for styling. Flutter has no CSS, so we translate these patterns.

**Web pattern → Flutter equivalent**:

| Web pattern | Flutter equivalent |
|-------------|-------------------|
| `class="ds-button"` | `DsButton` widget class |
| `data-variant="primary"` | `variant: DsButtonVariant.primary` |
| `data-color="danger"` | `color: DsColor.danger` or `DsColorScope` |
| `data-size="sm"` | `size: DsSize.sm` or `DsSizeScope` |
| CSS custom properties (`--ds-*`) | `DsThemeData` fields via `DsTheme.of(context)` |
| `:hover` pseudo-class | `MouseRegion` + state management |
| `:focus-visible` pseudo-class | `FocusNode` + `Focus` widget |
| `:active` pseudo-class | `GestureDetector` onTapDown/onTapUp |
| `@media (hover: hover) and (pointer: fine)` | Check `MediaQuery.of(context).pointerDeviceKind` |
| `disabled` attribute + `opacity: 0.3` | `Opacity(opacity: 0.3)` + ignore gestures |
| `data-size="auto"` (viewport-based) | Not ported initially; explicit size modes only |

**CSS class naming → Dart naming**:
- `ds-button` → `DsButton`
- `ds-alert` → `DsAlert`
- `ds-field` → `DsField`
- `ds-input` → `DsInput`
- `ds-label` → `DsLabel`

**Hover implementation note**: Designsystemet CSS uses `@media (hover: hover) and (pointer: fine)` to prevent hover effects on touch devices. In Flutter, use `MouseRegion` which naturally only fires on pointer devices.

**Alternatives considered**:
- Use Material widgets internally and override styles → rejected (violates FR-032 and Constitution Principle V's intent for Designsystemet-native rendering)
- Use `CustomPaint` for everything → rejected (overkill; `Container`, `DecoratedBox`, `AnimatedContainer` handle most cases; reserve `CustomPaint` for checkbox marks, radio dots, spinner animation)

## 4. Size Token System

### Decision: Linear computation with three predefined modes

**Rationale**: Size tokens use a linear scale. The CLI defines `base` and `step` per size mode.

**Computation**: `size(n) = base * n * step_factor` where the base unit is 0.25rem and the numbered tokens scale linearly.

**Size modes** (from spec):

| Mode | Base font | Step | Component height |
|------|-----------|------|-----------------|
| sm | 16px | 4px | ~36px |
| md | 18px | 4px | ~48px |
| lg | 21px | 4px | ~56px |

**Web note**: The web supports `data-size="auto"` which switches between sm/md/lg based on viewport width breakpoints. This is NOT ported initially — Flutter apps should set size explicitly via `DsSizeScope`.

**Alternatives considered**:
- Port `auto` size mode with responsive breakpoints → deferred (adds complexity; Flutter developers typically control sizing explicitly)

## 5. Border Radius Computation

### Decision: Scale-based computation from config `borderRadius` value

**Rationale**: The config accepts a single `borderRadius` number (e.g., 4) which is used as the base. Named tokens are derived by multiplying.

**Default tokens** (with `borderRadius: 4`):

| Token | Value |
|-------|-------|
| `border-radius-sm` | 2px |
| `border-radius-md` | 4px (= base) |
| `border-radius-lg` | 8px |
| `border-radius-xl` | 12px |
| `border-radius-default` | 4px (= base) |
| `border-radius-full` | 9999px |

**Alternatives considered**:
- Fixed radius values → rejected (must respect theme config for portability)

## 6. Typography System

### Decision: Inter font bundled, text styles computed from size tokens

**Rationale**: Designsystemet defaults to Inter font loaded from Altinn CDN in web. For Flutter, bundling is preferred (clarification Q2 result). Font feature `cv05` is enabled by default in the web implementation.

**Font source in web**:
```html
<link rel="stylesheet" href="https://altinncdn.no/fonts/inter/v4.1/inter.css">
```

**Flutter approach**: Bundle Inter TTF files (400, 500, 600) as package assets. Enable `fontFeatures: [FontFeature('cv05')]` for the distinctive lowercase 'a' form.

**Text style computation**: Font sizes are derived from the active size tokens. Heading/body styles reference specific size token indices for each level.

**Alternatives considered**:
- Use `google_fonts` package → rejected (requires network, government environments may restrict)
- Don't enable cv05 feature → rejected (Designsystemet explicitly uses it for visual fidelity)

## 7. Component Implementation Strategy

### Decision: Build from primitives using widgets.dart + rendering.dart only

**Rationale**: FR-032 prohibits Material/Cupertino visual dependencies. Components are built using:

- `Container` / `DecoratedBox` for backgrounds, borders, shadows
- `AnimatedContainer` for state transitions (hover, focus)
- `GestureDetector` / `MouseRegion` for interaction
- `Focus` / `FocusNode` for keyboard focus management
- `Semantics` for accessibility
- `CustomPaint` for custom shapes (checkbox marks, radio dots, spinner arcs)
- `Overlay` for dropdowns, tooltips, popovers

**State management pattern per component**:
1. Track `isHovered`, `isFocused`, `isPressed` via `StatefulWidget`
2. Resolve active color scale from `DsColorScope.of(context)` (or local override)
3. Resolve size tokens from `DsSizeScope.of(context)` (or local override)
4. Apply visual properties from theme tokens based on current state
5. Wrap in `Semantics` with appropriate properties
6. Respect `MediaQuery.disableAnimations` for transition durations

**Alternatives considered**:
- Extend `ButtonStyleButton` or other Material base classes → rejected (brings Material visual language as dependency)
- Use `RenderObject` directly → rejected (too low-level for most components; reserve for truly custom rendering)

## 8. ThemeExtension Integration

### Decision: Dual API — InheritedWidget primary, ThemeExtension optional

**Rationale**: Clarification Q3 result. `DsThemeData` extends `ThemeExtension<DsThemeData>` implementing `copyWith` and `lerp`. The `DsTheme` InheritedWidget is the primary API used by all library components. The ThemeExtension is an opt-in convenience for apps already using MaterialApp.

**Implementation approach**:
- `DsThemeData` implements `ThemeExtension<DsThemeData>`
- `DsTheme.of(context)` first checks the InheritedWidget, falls back to `Theme.of(context).extension<DsThemeData>()` if present
- Components always use `DsTheme.of(context)`, never directly access ThemeExtension

**Alternatives considered**:
- InheritedWidget only → rejected (limits integration with existing Material apps)
- ThemeExtension only → rejected (creates hard dependency on Material's Theme)

## 9. Tree-Shaking Strategy

### Decision: Separate library entry points + no cross-component imports

**Rationale**: FR-033 requires tree-shaking. Each component file must only import theme infrastructure and utils, never other components. The barrel export re-exports everything, but individual imports work too.

**Entry points**:
- `package:komponentbibliotek_flutter/theme.dart` — theme only
- `package:komponentbibliotek_flutter/components.dart` — all components
- `package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart` — everything

**Alternatives considered**:
- Single entry point only → rejected (importing everything defeats tree-shaking when only a few components are needed)
- One entry point per component → rejected (too granular, 40+ import paths is unwieldy)
