# Eksterne lenker

Eksterne lenker fører brukeren bort fra tjenesten. Marker dem tydelig slik at brukeren vet hva som skjer før de klikker.

## Prinsipper

- **Marker** at lenken er ekstern (ikon og/eller skjult tekst for skjermlesere).
- **Skriv ut målet** i lenketeksten der det er nyttig («Les mer på helsenorge.no»).
- Vær varsom med å åpne i ny fane — det kan forvirre og bryter «tilbake»-knappen. Hvis du gjør det, **informer** brukeren.

`DsLink` tar selve lenketeksten via `text` og en `onTap`-handling. Marker at lenken er ekstern både i selve teksten og for skjermlesere ved å pakke lenken inn i `Semantics`:

```dart
Semantics(
  label: 'Les mer på helsenorge.no (ekstern lenke)',
  child: DsLink(
    text: 'Les mer på helsenorge.no',
    onTap: () => åpne('https://helsenorge.no'),
  ),
)
```

Trenger du et eksternt ikon ved siden av lenken, plasser det utenfor `DsLink` og skjul det for skjermlesere (lenketeksten beskriver allerede målet):

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    DsLink(
      text: 'Les mer på helsenorge.no',
      onTap: () => åpne('https://helsenorge.no'),
    ),
    const SizedBox(width: 4),
    // Rent dekorativt ikon; skjules for skjermlesere.
    const ExcludeSemantics(child: Icon(DsIcons.externalLink, size: 16)),
  ],
)
```

## Tilgjengelighet

- Gi skjermlesere beskjed om at lenken er ekstern (for eksempel via `Semantics(label: '… (ekstern lenke)')`).
- Unngå generiske lenketekster som «klikk her» — lenketeksten skal gi mening alene.
- Ikoner som kun er dekorative skal skjules fra skjermlesere (`ExcludeSemantics`).
