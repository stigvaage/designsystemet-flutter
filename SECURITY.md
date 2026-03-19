# Sikkerhetspolicy

## Støttede versjoner

| Versjon | Støttet          |
|---------|-------------------|
| 0.x     | :white_check_mark: |

## Rapportere en sårbarhet

**Ikke opprett en offentlig issue for sikkerhetssårbarheter.**

Bruk i stedet [GitHub Security Advisories](https://github.com/stigvaage/designsystemet-flutter/security/advisories/new) for å rapportere sårbarheter privat.

### Hva du bør inkludere

- En beskrivelse av sårbarheten
- Steg for å reprodusere, eller et proof of concept
- Konsekvensene du har identifisert
- Eventuelt forslag til løsning (valgfritt)

Vi gjør vårt beste for å følge opp rapporter så raskt som mulig og holder deg informert underveis. Bidragsytere krediteres i rådgivningen med mindre de foretrekker å forbli anonyme.

## Sikkerhetsretningslinjer for bidragsytere

- **Ingen hemmeligheter i kode**: Aldri commit API-nøkler, tokens, passord eller andre legitimasjonsdetaljer. Bruk miljøvariabler eller GitHub Secrets for CI/CD.
- **Minst mulig tilgang i CI**: Arbeidsflyter skal kun be om de tillatelsene de trenger.
- **Hold avhengigheter oppdatert**: Bruk Dependabot-varsler og hold avhengigheter oppdatert.
- **Gjennomgå tredjepartskode**: Evaluer nye avhengigheter for kjente sårbarheter før du legger dem til.
