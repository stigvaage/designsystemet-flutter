import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'nb-NO',
  title: 'Designsystemet Flutter',
  description: 'Flutter-implementasjon av det norske offentlige designsystemet',

  srcDir: 'nb',
  base: '/komponentbibliotek-flutter/',

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/komponentbibliotek-flutter/favicon.svg' }],
  ],

  themeConfig: {
    logo: '/logo.svg',

    nav: [
      { text: 'Introduksjon', link: '/introduksjon/om-designsystemet' },
      { text: 'Kom i gang', link: '/kom-i-gang/forberedelser' },
      { text: 'Grunnleggende', link: '/grunnleggende/tema/' },
      { text: 'Komponenter', link: '/komponenter/' },
      { text: 'Widgetbook', link: '/widgetbook/', target: '_blank' },
    ],

    sidebar: {
      '/introduksjon/': [
        {
          text: 'Introduksjon',
          items: [
            { text: 'Om Designsystemet', link: '/introduksjon/om-designsystemet' },
            { text: 'Om Flutter-biblioteket', link: '/introduksjon/om-flutter-biblioteket' },
          ],
        },
      ],

      '/kom-i-gang/': [
        {
          text: 'Kom i gang',
          items: [
            { text: 'Forberedelser', link: '/kom-i-gang/forberedelser' },
            { text: 'Oppsett', link: '/kom-i-gang/oppsett' },
            { text: 'Hurtigstart', link: '/kom-i-gang/hurtigstart' },
          ],
        },
      ],

      '/grunnleggende/': [
        {
          text: 'Grunnleggende',
          items: [
            { text: 'Tema', link: '/grunnleggende/tema/' },
            { text: 'Farger', link: '/grunnleggende/farger/' },
            { text: 'Størrelser', link: '/grunnleggende/storrelser/' },
            { text: 'Typografi', link: '/grunnleggende/typografi' },
            { text: 'Avrunding og skygger', link: '/grunnleggende/avrunding-og-skygger' },
            { text: 'Tilgjengelighet', link: '/grunnleggende/tilgjengelighet' },
          ],
        },
      ],

      '/komponenter/': [
        {
          text: 'Komponenter',
          items: [
            { text: 'Oversikt', link: '/komponenter/' },
          ],
        },
        {
          text: 'Kjernekomponenter',
          collapsed: false,
          items: [
            { text: 'DsButton', link: '/komponenter/kjernekomponenter/ds-button' },
            { text: 'DsTextfield', link: '/komponenter/kjernekomponenter/ds-textfield' },
            { text: 'DsTextarea', link: '/komponenter/kjernekomponenter/ds-textarea' },
            { text: 'DsCheckbox', link: '/komponenter/kjernekomponenter/ds-checkbox' },
            { text: 'DsRadio', link: '/komponenter/kjernekomponenter/ds-radio' },
            { text: 'DsSwitch', link: '/komponenter/kjernekomponenter/ds-switch' },
            { text: 'DsAlert', link: '/komponenter/kjernekomponenter/ds-alert' },
            { text: 'DsCard', link: '/komponenter/kjernekomponenter/ds-card' },
            { text: 'DsTag', link: '/komponenter/kjernekomponenter/ds-tag' },
            { text: 'DsChip', link: '/komponenter/kjernekomponenter/ds-chip' },
            { text: 'DsBadge', link: '/komponenter/kjernekomponenter/ds-badge' },
            { text: 'DsSpinner', link: '/komponenter/kjernekomponenter/ds-spinner' },
            { text: 'DsDivider', link: '/komponenter/kjernekomponenter/ds-divider' },
            { text: 'DsLink', link: '/komponenter/kjernekomponenter/ds-link' },
          ],
        },
        {
          text: 'Navigasjon',
          collapsed: false,
          items: [
            { text: 'DsTabs', link: '/komponenter/navigasjon/ds-tabs' },
            { text: 'DsDialog', link: '/komponenter/navigasjon/ds-dialog' },
            { text: 'DsDropdown', link: '/komponenter/navigasjon/ds-dropdown' },
            { text: 'DsSelect', link: '/komponenter/navigasjon/ds-select' },
            { text: 'DsPagination', link: '/komponenter/navigasjon/ds-pagination' },
            { text: 'DsTable', link: '/komponenter/navigasjon/ds-table' },
            { text: 'DsBreadcrumbs', link: '/komponenter/navigasjon/ds-breadcrumbs' },
            { text: 'DsSearch', link: '/komponenter/navigasjon/ds-search' },
            { text: 'DsTooltip', link: '/komponenter/navigasjon/ds-tooltip' },
            { text: 'DsPopover', link: '/komponenter/navigasjon/ds-popover' },
            { text: 'DsAvatar', link: '/komponenter/navigasjon/ds-avatar' },
            { text: 'DsAvatarStack', link: '/komponenter/navigasjon/ds-avatar-stack' },
            { text: 'DsToggleGroup', link: '/komponenter/navigasjon/ds-toggle-group' },
            { text: 'DsSuggestion', link: '/komponenter/navigasjon/ds-suggestion' },
          ],
        },
        {
          text: 'Skjema',
          collapsed: false,
          items: [
            { text: 'DsField', link: '/komponenter/skjema/ds-field' },
            { text: 'DsFieldset', link: '/komponenter/skjema/ds-fieldset' },
            { text: 'DsInput', link: '/komponenter/skjema/ds-input' },
            { text: 'DsErrorSummary', link: '/komponenter/skjema/ds-error-summary' },
            { text: 'DsDetails', link: '/komponenter/skjema/ds-details' },
            { text: 'DsList', link: '/komponenter/skjema/ds-list' },
            { text: 'DsSkeleton', link: '/komponenter/skjema/ds-skeleton' },
            { text: 'DsSkipLink', link: '/komponenter/skjema/ds-skip-link' },
          ],
        },
        {
          text: 'Typografi',
          collapsed: false,
          items: [
            { text: 'DsHeading', link: '/komponenter/typografi/ds-heading' },
            { text: 'DsParagraph', link: '/komponenter/typografi/ds-paragraph' },
            { text: 'DsLabel', link: '/komponenter/typografi/ds-label' },
            { text: 'DsValidationMessage', link: '/komponenter/typografi/ds-validation-message' },
          ],
        },
      ],

      '/monstre/': [
        {
          text: 'Mønstre',
          items: [
            { text: 'Skjemavalidering', link: '/monstre/skjemavalidering' },
            { text: 'Feilhåndtering', link: '/monstre/feilhandtering' },
            { text: 'Obligatoriske felt', link: '/monstre/obligatoriske-felt' },
          ],
        },
      ],
    },

    search: {
      provider: 'local',
      options: {
        translations: {
          button: {
            buttonText: 'Søk',
            buttonAriaLabel: 'Søk',
          },
          modal: {
            displayDetails: 'Vis detaljert liste',
            resetButtonTitle: 'Tøm søk',
            backButtonTitle: 'Lukk søk',
            noResultsText: 'Ingen resultater for',
            footer: {
              selectText: 'for å velge',
              selectKeyAriaLabel: 'enter',
              navigateText: 'for å navigere',
              navigateUpKeyAriaLabel: 'pil opp',
              navigateDownKeyAriaLabel: 'pil ned',
              closeText: 'for å lukke',
              closeKeyAriaLabel: 'escape',
            },
          },
        },
      },
    },

    outline: {
      label: 'På denne siden',
    },

    docFooter: {
      prev: 'Forrige',
      next: 'Neste',
    },

    lastUpdated: {
      text: 'Sist oppdatert',
    },

    editLink: {
      pattern: 'https://github.com/stigvaage/komponentbibliotek-flutter/edit/main/site/nb/:path',
      text: 'Rediger denne siden på GitHub',
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/stigvaage/komponentbibliotek-flutter' },
    ],

    footer: {
      message: 'Utgitt under MIT-lisens.',
      copyright: 'Basert på Designsystemet fra Digitaliseringsdirektoratet.',
    },
  },
})
