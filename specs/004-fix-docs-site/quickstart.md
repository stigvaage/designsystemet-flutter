# Quickstart: Fix Documentation Site and Widgetbook Issues

## What's broken
The WidgetbookEmbed Vue component constructs incorrect deep-link URLs. All 40 component doc pages link to Widgetbook but land on the home page instead of the correct component.

## Root cause
Three bugs in `site/.vitepress/theme/WidgetbookEmbed.vue`:
1. Missing `#/` hash prefix (Flutter web uses hash routing)
2. Path not lowercased or hyphenated (Widgetbook normalizes internally)
3. Missing use case name segment (Widgetbook requires 3-segment paths)

## The fix (3 steps)

### Step 1: Fix WidgetbookEmbed.vue URL construction
```typescript
// Replace the widgetbookUrl computed property:
const widgetbookUrl = computed(() => {
  const path = props.component.replace(/ /g, '-').toLowerCase()
  return `${baseUrl}widgetbook/#/?path=${encodeURIComponent(path)}`
})

// Remove unused height prop from defineProps
```

### Step 2: Update all 40 component markdown files
Add `/Standard` to the component prop and remove `:height`:
```diff
- <WidgetbookEmbed component="Kjernekomponenter/DsButton" :height="200" />
+ <WidgetbookEmbed component="Kjernekomponenter/DsButton/Standard" />
```

### Step 3: Verify locally
```bash
cd site && npm run dev    # Check link cards render
cd widgetbook && flutter run -d chrome  # Check deep-links resolve
```

## Files changed
- `site/.vitepress/theme/WidgetbookEmbed.vue` (1 file — URL logic fix)
- `site/nb/komponenter/ds-*.md` (40 files — prop updates)
- `.github/workflows/deploy-widgetbook.yml` (1 file — minor improvements)
