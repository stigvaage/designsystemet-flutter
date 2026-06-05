# Knappeplassering og rekkefølge

Konsekvent plassering og rekkefølge på knapper gjør grensesnittet forutsigbart og lettere å bruke.

## Rekkefølge

- **Primærhandlingen** kommer først (til venstre i en venstrejustert gruppe), slik at den er enkel å finne.
- **Sekundære handlinger** (for eksempel «Avbryt») kommer etter primærhandlingen.
- Bruk kun **én** primærknapp per handlingsgruppe, slik at det er tydelig hva som er den anbefalte handlingen.

```dart
Row(
  children: [
    DsButton(
      variant: DsButtonVariant.primary,
      onPressed: lagre,
      child: const Text('Lagre'),
    ),
    const SizedBox(width: 8),
    DsButton(
      variant: DsButtonVariant.secondary,
      onPressed: avbryt,
      child: const Text('Avbryt'),
    ),
  ],
)
```

## Plassering

- I **skjemaer** plasseres handlingsknappene nederst, etter feltene, venstrejustert med skjemaet.
- I **dialoger** (`DsDialog`) plasseres knappene i bunnen; primærhandlingen er tydeligst.
- Unngå å spre relaterte knapper ut over flaten — hold dem samlet i én gruppe.

## Tilgjengelighet

- Knapperekkefølgen i visningen bør følge fokus-/leserekkefølgen.
- Bruk tydelige, handlingsorienterte ledetekster («Lagre endringer», ikke «OK»).
