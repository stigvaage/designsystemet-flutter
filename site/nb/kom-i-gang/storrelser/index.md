# Størrelser

Størrelsessystemet gir tre moduser som styrer dimensjonene til alle komponenter gjennom et konsistent sett med tokens.

## Tre størrelsesmoduser

| Modus | Basestørrelse | Beskrivelse |
|---|---|---|
| `DsSize.sm` | 16px | Kompakt visning |
| `DsSize.md` | 18px | Standard (brukes når ingen størrelse er angitt) |
| `DsSize.lg` | 21px | Stor visning |

## DsSizeTokens

`DsSizeTokens` inneholder 31 nummererte verdier, fra `size0` til `size30`. Hver verdi beregnes med formelen:

```
sizeN = N * trinn   (trinn = 4px)
```

`size0` er alltid `0px`. Avstandsverdiene er like for alle tre størrelsesmodusene — `base` (16/18/21px) er kontroll-/skriftstørrelse-grunnverdien som lagres på tokenet, men den inngår **ikke** i utregningen av `sizeN`.

Eksempler:

| Token | Verdi |
|---|---|
| `size0` | 0px |
| `size1` | 4px |
| `size2` | 8px |
| `size5` | 20px |
| `size10` | 40px |

## DsSizeScope

Bruk `DsSizeScope` for å sette størrelsen for et undertreav widgeter:

```dart
DsSizeScope(
  size: DsSize.sm,
  child: Column(
    children: [
      DsButton(
        variant: DsButtonVariant.primary,
        onPressed: () {},
        child: Text('Kompakt knapp'),
      ),
      DsField(
        label: 'Kompakt felt',
        child: DsTextfield(),
      ),
    ],
  ),
)
```

## Prioritering

Når en komponent har både en lokal `size`-parameter og en `DsSizeScope`-ancestor, vinner den lokale parameteren:

```dart
DsSizeScope(
  size: DsSize.sm,
  child: DsButton(
    size: DsSize.lg, // Denne vinner over DsSizeScope
    variant: DsButtonVariant.primary,
    onPressed: () {},
    child: Text('Stor knapp'),
  ),
)
```

## Standardverdi

Hvis verken en lokal `size`-parameter eller `DsSizeScope` er angitt, brukes `DsSize.md` som standard.

## Hente størrelsestokens fra kontekst

```dart
Widget build(BuildContext context) {
  final størrelser = DsTheme.of(context).sizeTokens;

  return Padding(
    padding: EdgeInsets.all(størrelser.size2),
    child: Text('Innhold'),
  );
}
```
