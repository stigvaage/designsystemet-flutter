# Eksterne lenker

Eksterne lenker fører brukeren bort fra tjenesten. Marker dem tydelig slik at brukeren vet hva som skjer før de klikker.

## Prinsipper

- **Marker** at lenken er ekstern (ikon og/eller skjult tekst for skjermlesere).
- **Skriv ut målet** i lenketeksten der det er nyttig («Les mer på helsenorge.no»).
- Vær varsom med å åpne i ny fane — det kan forvirre og bryter «tilbake»-knappen. Hvis du gjør det, **informer** brukeren.

```dart
DsLink(
  onTap: () => åpne('https://helsenorge.no'),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text('Les mer på helsenorge.no'),
      SizedBox(width: 4),
      // Marker som ekstern; skjul ikonet for skjermlesere og forklar i teksten.
      Icon(DsIcons.arrowRight, size: 16),
    ],
  ),
)
```

## Tilgjengelighet

- Gi skjermlesere beskjed om at lenken er ekstern (for eksempel via `Semantics(label: '… (ekstern lenke)')`).
- Unngå generiske lenketekster som «klikk her» — lenketeksten skal gi mening alene.
- Ikoner som kun er dekorative skal skjules fra skjermlesere (`ExcludeSemantics`).
