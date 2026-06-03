# Representasjon

Innhold og illustrasjoner skal være inkluderende og speile mangfoldet blant brukerne. God representasjon bygger tillit og gjør at flere kjenner seg igjen.

## Prinsipper

- **Bruk inkluderende språk** — kjønnsnøytralt der det er mulig, og unngå antakelser om brukeren.
- **Avatarer og initialer** (`DsAvatar`) bør ikke anta kjønn eller bakgrunn; bruk nøytrale fallbacks.
- **Eksempeldata** (navn, bilder) bør vise bredde, ikke bare ett mønster.
- Unngå stereotypier i tekst og illustrasjon.

```dart
DsAvatar(
  name: 'Jordan Hansen', // kjønnsnøytralt eksempelnavn
)
```

## Skjemaer og personopplysninger

- Spør kun om opplysninger du faktisk trenger (for eksempel kjønn) — og tilby nøytrale alternativer.
- La navnefelt være romslige nok for ulike navn og tegn (æ, ø, å og andre).

## Tilgjengelighet

- Alternativ tekst på bilder skal beskrive innholdet saklig, uten antakelser.
- Sørg for at fargebruk ikke er eneste bærer av mening (jf. kontrast- og fargeretningslinjene).
