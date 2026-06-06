# Typografi

Biblioteket bruker skrifttypen **Inter** som er bundet med i pakken i vektene 400 (regular), 500 (medium) og 600 (semibold).

## DsHeading

Overskrifter brukes til å strukturere innhold hierarkisk. Alle overskrifter har vekt 500 (medium) og linjehøyde 1.3.

### Syv nivå

Skriftstørrelsene følger offisiell Designsystemet v1.15.0 (px ved referansestørrelse).

| Nivå | Enum | Størrelse |
|---|---|---|
| Ekstra ekstra stor | `DsHeadingLevel.xxl` | 60px |
| Ekstra stor | `DsHeadingLevel.xl` | 48px |
| Stor | `DsHeadingLevel.lg` | 36px |
| Medium | `DsHeadingLevel.md` | 30px |
| Liten | `DsHeadingLevel.sm` | 24px |
| Ekstra liten | `DsHeadingLevel.xs` | 21px |
| Ekstra ekstra liten | `DsHeadingLevel.xxs` | 18px |

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

Skriftstørrelsene følger offisiell Designsystemet v1.15.0 (px ved referansestørrelse).

| Størrelse | Enum | Størrelse |
|---|---|---|
| Ekstra liten | `DsBodySize.xs` | 14px |
| Liten | `DsBodySize.sm` | 16px |
| Medium | `DsBodySize.md` | 18px |
| Stor | `DsBodySize.lg` | 21px |
| Ekstra stor | `DsBodySize.xl` | 24px |

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

Brukes til etiketter for skjemafelt. Stilen følger temaets typografidefinisjon og tilpasses automatisk til gjeldende størrelse. Skriftstørrelsene følger offisiell Designsystemet v1.15.0 (px ved referansestørrelse).

| Størrelse | Enum | Størrelse |
|---|---|---|
| Liten | `DsSize.sm` | 16px |
| Medium | `DsSize.md` | 18px |
| Stor | `DsSize.lg` | 21px |

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
