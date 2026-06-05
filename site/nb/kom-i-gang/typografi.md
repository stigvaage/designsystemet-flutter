# Typografi

Biblioteket bruker skrifttypen **Inter** som er bundet med i pakken i vektene 400 (regular), 500 (medium) og 600 (semibold).

## DsHeading

Overskrifter brukes til å strukturere innhold hierarkisk. Alle overskrifter har vekt 500 (medium) og linjehøyde 1.3.

### Syv nivå

| Nivå | Enum |
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

Brødtekst med fem størrelser og tre varianter som styrer linjehøyde.

### Størrelser

`DsBodySize.xs`, `DsBodySize.sm`, `DsBodySize.md`, `DsBodySize.lg`, `DsBodySize.xl`

### Varianter

| Variant | Linjehøyde | Bruk |
|---|---|---|
| `standard` | 1.5 | Vanlig brødtekst |
| `short` | 1.3 | Kompakt tekst, UI-elementer |
| `long` | 1.7 | Lengre artikler, bedre lesbarhet |

### Eksempel

```dart
DsParagraph(
  text: 'Dette er en avsnittekst med god lesbarhet.',
  bodySize: DsBodySize.md,
  variant: DsBodyVariant.long,
)
```

## DsLabel

Brukes til etiketter for skjemafelt. Stilen følger temaets typografidefinisjon og tilpasses automatisk til gjeldende størrelse.

```dart
DsLabel(
  text: 'E-postadresse',
)
```

## DsValidationMessage

Brukes til valideringsmeldinger under skjemafelt. Vises typisk i kombinasjon med `DsField`.

```dart
DsValidationMessage(
  text: 'Feltet er påkrevd',
  type: DsValidationType.error,
)
```
