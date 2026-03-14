# DsAvatarStack

Stablet gruppe av avatarer.

## Interaktiv forhåndsvisning

<WidgetbookEmbed component="Navigasjon og layout/DsAvatarStack" :height="300" />

## Egenskaper

| Egenskap | Type | Standard | Beskrivelse |
|----------|------|----------|-------------|
| avatars | List\<DsAvatar\> | påkrevd | Liste over avatarer som skal vises |
| maxVisible | int | 3 | Maks antall synlige avatarer |
| size | DsSize? | null | Størrelse på avatarene |

## Eksempel

```dart
DsAvatarStack(
  maxVisible: 4,
  avatars: [
    DsAvatar(child: Text('AB')),
    DsAvatar(child: Text('CD')),
    DsAvatar(child: Text('EF')),
    DsAvatar(child: Text('GH')),
    DsAvatar(child: Text('IJ')),
  ],
)
```

## Tilgjengelighet

- Viser antall skjulte avatarer for skjermlesere slik at all informasjon er tilgjengelig.
