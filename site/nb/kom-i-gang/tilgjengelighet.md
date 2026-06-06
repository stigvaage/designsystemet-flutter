# Tilgjengelighet

Alle komponenter i biblioteket er bygget for å oppfylle WCAG 2.1 AA-kravene.

## Fargekontrast

Fargesystemet garanterer følgende minimumskontrastnivå i både lyst og mørkt modus:

| Token | Minimumkontrast | Målemetode |
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

- **Tab-navigasjon**: Alle interaktive elementer kan nås med Tab-tasten
- **Fokusindikator**: Synlig fokusring som bruker `borderStrong`-fargetokenet
- **Roterende fokus**: Tabgrupper, radiogrupper og bryterknappgrupper bruker piltaster for navigasjon innad i gruppen
- **Fokusfelle i dialoger**: Når en dialog er åpen, holdes fokus innenfor dialogen

### Eksempel på fokushåndtering

```dart
DsDialog(
  title: Text('Bekreft sletting'),
  // Fokus fanges automatisk innenfor dialogen
  child: Column(
    children: [
      DsParagraph(text: 'Er du sikker på at du vil slette?'),
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

Komponentene respekterer `MediaQuery.disableAnimations`. Når brukeren har slått på redusert bevegelighet i operativsystemet, hoppes animasjoner over eller kjøres med minimal varighet.

## Beste praksis

1. **Bruk alltid `DsField` rundt tekstfelt** for å sikre riktig kobling mellom etikett, hjelpetekst og feilmelding.

2. **Gi beskrivende etiketter** til alle interaktive elementer. Unngå generiske tekster som "Klikk her".

3. **Bruk `DsErrorSummary` for skjemafeil** slik at brukeren får en samlet oversikt over alle feil i skjemaet.

4. **Test med skjermleser** (TalkBack på Android, VoiceOver på iOS/macOS) for å verifisere at informasjonen er forståelig.

5. **Test tastaturnavigasjon** for å sikre at alle funksjoner er tilgjengelige uten mus.

6. **Bruk `DsSkipLink` for hopplenke** slik at tastaturbrukere raskt kan hoppe til hovedinnholdet.

```dart
DsSkipLink(
  label: 'Hopp til hovedinnhold',
  targetKey: hovedinnholdKey,
)
```
