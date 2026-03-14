# Tilgjengelighet

Alle komponenter i biblioteket er bygget for a oppfylle WCAG 2.1 AA-kravene.

## Fargekontrast

Fargesystemet garanterer folgende minimumskontrastniva i bade lyst og morkt modus:

| Token | Minimumkontrast | Malemetode |
|---|---|---|
| `textDefault` | >= 4.5:1 | Mot bakgrunn |
| `textSubtle` | >= 4.5:1 | Mot bakgrunn |
| `borderDefault` | >= 3:1 | Mot bakgrunn |
| `baseContrastDefault` | >= 4.5:1 | Mot base |

## Semantikk

Alle interaktive komponenter eksponerer riktig semantikk gjennom Flutters `Semantics`-widget:

- **Knapper**: `button: true`
- **Tekstfelt**: `textField: true`
- **Avkrysningsbokser og bryterknapper**: `checked: true/false`
- **Deaktiverte elementer**: `enabled: false`

Dette sikrer at skjermlesere annonserer komponentene korrekt.

## Tastaturnavigasjon

### Fokusstyring

- **Tab-navigasjon**: Alle interaktive elementer kan nas med Tab-tasten
- **Fokusindikator**: Synlig fokusring som bruker `borderStrong`-fargetokenet
- **Roterende fokus**: Tabgrupper, radiogrupper og bryterknappgrupper bruker piltaster for navigasjon innad i gruppen
- **Fokusfelle i dialoger**: Nar en dialog er apen, holdes fokus innenfor dialogen

### Eksempel pa fokushandtering

```dart
DsDialog(
  title: 'Bekreft sletting',
  // Fokus fanges automatisk innenfor dialogen
  child: Column(
    children: [
      DsParagraph(text: 'Er du sikker pa at du vil slette?'),
      DsButton(
        variant: DsButtonVariant.primary,
        onPressed: () => bekreft(),
        child: Text('Slett'),
      ),
    ],
  ),
)
```

## Redusert bevegelighet

Komponentene respekterer `MediaQuery.disableAnimations`. Nar brukeren har slatt pa redusert bevegelighet i operativsystemet, hoppes animasjoner over eller kjores med minimal varighet.

## Beste praksis

1. **Bruk alltid `DsField` rundt tekstfelt** for a sikre riktig kobling mellom etikett, hjelpetekst og feilmelding.

2. **Gi beskrivende etiketter** til alle interaktive elementer. Unnga generiske tekster som "Klikk her".

3. **Bruk `DsErrorSummary` for skjemafeil** slik at brukeren far en samlet oversikt over alle feil i skjemaet.

4. **Test med skjermleser** (TalkBack pa Android, VoiceOver pa iOS/macOS) for a verifisere at informasjonen er forstaelig.

5. **Test tastaturnavigasjon** for a sikre at alle funksjoner er tilgjengelige uten mus.

6. **Bruk `DsSkipLink` for hopplenke** slik at tastaturbrukere raskt kan hoppe til hovedinnholdet.

```dart
DsSkipLink(
  label: 'Hopp til hovedinnhold',
  targetKey: hovedinnholdKey,
)
```
