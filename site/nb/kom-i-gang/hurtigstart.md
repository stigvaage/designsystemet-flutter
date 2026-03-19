# Hurtigstart

Et komplett minimalt eksempel som viser hvordan du kommer i gang.

## Minimalt eksempel

```dart
import 'package:komponentbibliotek_flutter/komponentbibliotek_flutter.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    DsTheme(
      data: DsThemeData.digdir(),
      child: const MinApp(),
    ),
  );
}

class MinApp extends StatelessWidget {
  const MinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DsHeading(text: 'Velkommen', level: DsHeadingLevel.lg),
        DsParagraph(text: 'Dette er en app med Designsystemet.'),
        DsButton(
          variant: DsButtonVariant.primary,
          onPressed: () => print('Trykket!'),
          child: Text('Klikk her'),
        ),
      ],
    );
  }
}
```

## Slik fungerer det

1. **`DsTheme`** pakker inn rot-widgeten og gjør tema-data tilgjengelig for alle komponenter nedover i treet.
2. **`DsThemeData.digdir()`** gir deg standardtemaet fra Digdir (Digitaliseringsdirektoratet).
3. Komponenter som `DsHeading`, `DsParagraph` og `DsButton` henter automatisk stil fra temaet.

## DsTheme er påkrevd

Alle komponenter krever en `DsTheme`-ancestor i widget-treet. Hvis en komponent ikke finner `DsTheme` lenger opp i treet, kastes en beskrivende feilmelding som forklarer hva som mangler.

Sorg derfor alltid for at `DsTheme` ligger rundt delen av appen som bruker komponentene.
