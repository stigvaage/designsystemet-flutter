# DsDialog

Dialogvindu (modal).

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsDialog" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| title | Widget? | null | Tittelen som vises øverst i dialogen |
| child | Widget | påkrevd | Innholdet i dialogen |
| actions | List\<Widget\> | [] | Handlingsknapper nederst i dialogen |
| closable | bool | true | Om dialogen kan lukkes med lukkeknapp |
| onClose | VoidCallback? | null | Kalles når dialogen lukkes |

## Eksempel

```dart
DsDialog(
  title: Text('Bekreft'),
  child: Text('Vil du fortsette?'),
  actions: [
    DsButton(
      variant: DsButtonVariant.secondary,
      onPressed: () => lukk(),
      child: Text('Avbryt'),
    ),
    DsButton(
      variant: DsButtonVariant.primary,
      onPressed: () => bekreft(),
      child: Text('Bekreft'),
    ),
  ],
)
```

## Tilgjengelighet

- Fanger fokus innenfor dialogen slik at brukeren ikke kan tabbe ut av den.
- Lukkeknappen er fokuserbar og synlig for skjermlesere.
- Escape-tasten lukker dialogen.
