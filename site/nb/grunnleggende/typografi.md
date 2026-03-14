# Typografi

Biblioteket bruker skrifttypen **Inter** som er bundet med i pakken i vektene 400 (regular), 500 (medium) og 600 (semibold).

## DsHeading

Overskrifter brukes til a strukturere innhold hierarkisk. Alle overskrifter har vekt 500 (medium) og linjehyde 1.3.

### Syv niva

| Niva | Enum |
|---|---|
| Ekstra ekstra stor | `DsHeadingLevel.xxl` |
| Ekstra stor | `DsHeadingLevel.xl` |
| Stor | `DsHeadingLevel.lg` |
| Medium | `DsHeadingLevel.md` |
| Liten | `DsHeadingLevel.sm` |
| Ekstra liten | `DsHeadingLevel.xs` |
| Ekstra ekstra liten | `DsHeadingLevel.xxs` |

### Eksempel

```dart
DsHeading(
  text: 'Sideoverskrift',
  level: DsHeadingLevel.xl,
)
```

## DsParagraph

Brodtekst med fem storrelser og tre varianter som styrer linjehyde.

### Storrelser

`DsParagraphSize.xs`, `DsParagraphSize.sm`, `DsParagraphSize.md`, `DsParagraphSize.lg`, `DsParagraphSize.xl`

### Varianter

| Variant | Linjehyde | Bruk |
|---|---|---|
| `standard` | 1.5 | Vanlig brodtekst |
| `short` | 1.3 | Kompakt tekst, UI-elementer |
| `long` | 1.7 | Lengre artikler, bedre lesbarhet |

### Eksempel

```dart
DsParagraph(
  text: 'Dette er en avsnittekst med god lesbarhet.',
  size: DsParagraphSize.md,
  variant: DsParagraphVariant.long,
)
```

## DsLabel

Brukes til etiketter for skjemafelt. Stilen folger temaets typografidefinisjon og tilpasses automatisk til gjeldende storrelse.

```dart
DsLabel(
  text: 'E-postadresse',
)
```

## DsValidationMessage

Brukes til valideringsmeldinger under skjemafelt. Vises typisk i kombinasjon med `DsField`.

```dart
DsValidationMessage(
  text: 'Feltet er pakrevd',
  type: DsValidationType.error,
)
```
