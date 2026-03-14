# Om Designsystemet

## Hva er Designsystemet?

[Designsystemet](https://designsystemet.no) er det felles designsystemet for norsk offentlig sektor, utviklet og forvaltet av Digitaliseringsdirektoratet (Digdir). Det gir et sett med retningslinjer, designtokens og ferdigbygde komponenter som offentlige virksomheter kan ta i bruk for å bygge digitale tjenester.

## Formål

Målet med Designsystemet er å sikre **konsistente, tilgjengelige og brukervennlige** digitale offentlige tjenester på tvers av etater og forvaltningsnivåer. Ved å samle seg om felles designprinsipper og komponentbiblioteker slipper hver virksomhet å finne opp hjulet på nytt, samtidig som innbyggerne får en gjenkjennelig og universelt utformet opplevelse uansett hvilken offentlig tjeneste de bruker.

Sentrale mål:

- **Konsistens** — Et enhetlig visuelt språk og interaksjonsmønster på tvers av alle offentlige digitale tjenester.
- **Tilgjengelighet** — Alle komponenter og retningslinjer følger WCAG 2.1 AA-kravene, slik at tjenestene er brukbare for alle.
- **Effektivitet** — Gjenbrukbare komponenter og tokens reduserer utviklingstid og vedlikeholdskostnad.

## Hva designsystemet.no tilbyr

Nettstedet [designsystemet.no](https://designsystemet.no) er den sentrale ressursen og inneholder:

- **Designtokens** — Farger, typografi, avstander, størrelser og andre visuelle verdier definert som gjenbrukbare tokens. Tokens kan eksporteres for ulike plattformer og rammeverk.
- **Komponenter** — Ferdige UI-komponenter med dokumentert oppførsel, tilstandshåndtering og tilgjengelighetskrav. Referanseimplementasjonen er i React.
- **Retningslinjer** — Veiledning for bruk av komponenter, designmønstre, universell utforming og innholdsstrategi.
- **Temaverktøy** — Verktøy for å generere egendefinerte temaer basert på virksomhetens profil, slik at komponentene tilpasses visuelt uten å bryte med de underliggende prinsippene.

## Hvorfor en Flutter-implementasjon?

Designsystemets referanseimplementasjon dekker webplattformen gjennom React-komponenter. Mange offentlige tjenester har imidlertid behov for native mobilapplikasjoner eller kryssplattformløsninger som dekker Android, iOS, desktop og web fra én kodebase.

Flutter er et naturlig valg for dette:

- **Én kodebase, alle plattformer** — Flutter støtter Android, iOS, Web, macOS, Linux og Windows.
- **Pikselpresist grensesnitt** — Flutter tegner sitt eget brukergrensesnitt og er ikke avhengig av plattformens native komponenter, noe som gir full kontroll over at Designsystemets spesifikasjoner følges nøyaktig.
- **Voksende bruk i offentlig sektor** — Stadig flere norske offentlige virksomheter evaluerer eller tar i bruk Flutter for sine mobilapplikasjoner.

`komponentbibliotek_flutter` er Flutter-implementasjonen av Designsystemet. Biblioteket gjenskaper alle 40 komponenter med tokens, tilgjengelighet og temaer som samsvarer med den offisielle spesifikasjonen — slik at Flutter-utviklere i offentlig sektor kan bygge tjenester som er i tråd med Designsystemet uten å måtte implementere komponentene selv.
