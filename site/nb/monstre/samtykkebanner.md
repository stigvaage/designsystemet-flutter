# Samtykkebanner

Et samtykkebanner ber brukeren om å godta innsamling av data (for eksempel statistikk) før det skjer. Det skal være tydelig, balansert og enkelt å svare på.

## Prinsipper

- **Nødvendige** informasjonskapsler kan ikke velges bort og forklares som det.
- **Valgfri** datainnsamling (statistikk/analyse) krever aktivt samtykke.
- «Godta» og «Avslå» skal ha **lik visuell vekt** — ikke gjør det vanskeligere å avslå enn å godta.
- Brukeren skal kunne **endre valget** sitt senere.

```dart
DsAlert(
  severity: DsSeverity.info,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const DsParagraph(text: 'Vil du godta at vi samler inn data om bruk av nettsiden?'),
      const SizedBox(height: 12),
      Row(
        children: [
          DsButton(
            variant: DsButtonVariant.secondary,
            onPressed: avslå,
            child: const Text('Avslå'),
          ),
          const SizedBox(width: 8),
          DsButton(
            variant: DsButtonVariant.primary,
            onPressed: godta,
            child: const Text('Godta'),
          ),
        ],
      ),
    ],
  ),
)
```

## Tilgjengelighet

- Banneret skal kunne nås og betjenes med tastatur.
- Ikke blokker hele innholdet bak samtykke med mindre det er strengt nødvendig.
- Bruk klarspråk: forklar kort hva dataene brukes til.
