import { defineConfig } from 'vitepress'
import { writeFileSync, mkdirSync } from 'node:fs'
import { resolve, dirname } from 'node:path'

const base = '/komponentbibliotek-flutter/'

const redirects: Record<string, string> = {
  // komponenter/kjernekomponenter → komponenter
  'komponenter/kjernekomponenter/ds-alert': 'komponenter/ds-alert',
  'komponenter/kjernekomponenter/ds-badge': 'komponenter/ds-badge',
  'komponenter/kjernekomponenter/ds-button': 'komponenter/ds-button',
  'komponenter/kjernekomponenter/ds-card': 'komponenter/ds-card',
  'komponenter/kjernekomponenter/ds-checkbox': 'komponenter/ds-checkbox',
  'komponenter/kjernekomponenter/ds-chip': 'komponenter/ds-chip',
  'komponenter/kjernekomponenter/ds-divider': 'komponenter/ds-divider',
  'komponenter/kjernekomponenter/ds-link': 'komponenter/ds-link',
  'komponenter/kjernekomponenter/ds-radio': 'komponenter/ds-radio',
  'komponenter/kjernekomponenter/ds-spinner': 'komponenter/ds-spinner',
  'komponenter/kjernekomponenter/ds-switch': 'komponenter/ds-switch',
  'komponenter/kjernekomponenter/ds-tag': 'komponenter/ds-tag',
  'komponenter/kjernekomponenter/ds-textarea': 'komponenter/ds-textarea',
  'komponenter/kjernekomponenter/ds-textfield': 'komponenter/ds-textfield',
  // komponenter/navigasjon → komponenter
  'komponenter/navigasjon/ds-avatar': 'komponenter/ds-avatar',
  'komponenter/navigasjon/ds-avatar-stack': 'komponenter/ds-avatar-stack',
  'komponenter/navigasjon/ds-breadcrumbs': 'komponenter/ds-breadcrumbs',
  'komponenter/navigasjon/ds-dialog': 'komponenter/ds-dialog',
  'komponenter/navigasjon/ds-dropdown': 'komponenter/ds-dropdown',
  'komponenter/navigasjon/ds-pagination': 'komponenter/ds-pagination',
  'komponenter/navigasjon/ds-popover': 'komponenter/ds-popover',
  'komponenter/navigasjon/ds-search': 'komponenter/ds-search',
  'komponenter/navigasjon/ds-select': 'komponenter/ds-select',
  'komponenter/navigasjon/ds-suggestion': 'komponenter/ds-suggestion',
  'komponenter/navigasjon/ds-table': 'komponenter/ds-table',
  'komponenter/navigasjon/ds-tabs': 'komponenter/ds-tabs',
  'komponenter/navigasjon/ds-toggle-group': 'komponenter/ds-toggle-group',
  'komponenter/navigasjon/ds-tooltip': 'komponenter/ds-tooltip',
  // komponenter/skjema → komponenter
  'komponenter/skjema/ds-details': 'komponenter/ds-details',
  'komponenter/skjema/ds-error-summary': 'komponenter/ds-error-summary',
  'komponenter/skjema/ds-field': 'komponenter/ds-field',
  'komponenter/skjema/ds-fieldset': 'komponenter/ds-fieldset',
  'komponenter/skjema/ds-input': 'komponenter/ds-input',
  'komponenter/skjema/ds-list': 'komponenter/ds-list',
  'komponenter/skjema/ds-skeleton': 'komponenter/ds-skeleton',
  'komponenter/skjema/ds-skip-link': 'komponenter/ds-skip-link',
  // komponenter/typografi → komponenter
  'komponenter/typografi/ds-heading': 'komponenter/ds-heading',
  'komponenter/typografi/ds-label': 'komponenter/ds-label',
  'komponenter/typografi/ds-paragraph': 'komponenter/ds-paragraph',
  'komponenter/typografi/ds-validation-message': 'komponenter/ds-validation-message',
  // grunnleggende → kom-i-gang
  'grunnleggende/tilgjengelighet': 'kom-i-gang/tilgjengelighet',
  'grunnleggende/typografi': 'kom-i-gang/typografi',
  'grunnleggende/farger/index': 'kom-i-gang/farger/',
  'grunnleggende/storrelser/index': 'kom-i-gang/storrelser/',
  'grunnleggende/avrunding-og-skygger': 'kom-i-gang/avrunding-og-skygger',
  'grunnleggende/tema/index': 'kom-i-gang/tema/',
  // introduksjon → intro
  'introduksjon/om-designsystemet': 'intro/om-designsystemet',
  'introduksjon/om-flutter-biblioteket': 'intro/om-flutter-biblioteket',
}

export default defineConfig({
  lang: 'nb-NO',
  title: 'Designsystemet Flutter',
  description: 'Flutter-implementasjon av det norske offentlige designsystemet',

  srcDir: 'nb',
  base,

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: `${base}favicon.svg` }],
  ],

  buildEnd(siteConfig) {
    const outDir = siteConfig.outDir
    for (const [from, to] of Object.entries(redirects)) {
      const htmlPath = resolve(outDir, `${from}.html`)
      mkdirSync(dirname(htmlPath), { recursive: true })
      const target = to.endsWith('/') ? `${base}${to}` : `${base}${to}.html`
      writeFileSync(
        htmlPath,
        `<!DOCTYPE html><html><head><meta charset="utf-8"><meta http-equiv="refresh" content="0; url=${target}"><link rel="canonical" href="${target}"></head><body><a href="${target}">Moved here</a></body></html>`,
      )
    }
  },

  themeConfig: {
    logo: '/logo.svg',

    nav: [
      { text: 'Intro', link: '/intro/om-designsystemet' },
      { text: 'Kom i gang', link: '/kom-i-gang/forberedelser' },
      { text: 'Komponenter', link: '/komponenter/' },
      { text: 'Mønstre', link: '/monstre/' },
      { text: 'God praksis', link: '/god-praksis/' },
      { text: 'Widgetbook', link: '/widgetbook/', target: '_blank' },
    ],

    sidebar: {
      '/intro/': [
        {
          text: 'Introduksjon',
          items: [
            { text: 'Om Designsystemet', link: '/intro/om-designsystemet' },
            { text: 'Om Flutter-biblioteket', link: '/intro/om-flutter-biblioteket' },
          ],
        },
      ],

      '/kom-i-gang/': [
        {
          text: 'Start her',
          items: [
            { text: 'Forberedelser', link: '/kom-i-gang/forberedelser' },
            { text: 'Hurtigstart', link: '/kom-i-gang/hurtigstart' },
          ],
        },
        {
          text: 'Kode',
          items: [
            { text: 'Oppsett', link: '/kom-i-gang/oppsett' },
            { text: 'MCP-server', link: '/kom-i-gang/mcp-server' },
          ],
        },
        {
          text: 'Tema',
          items: [
            { text: 'Temaer', link: '/kom-i-gang/tema/' },
            { text: 'Farger', link: '/kom-i-gang/farger/' },
            { text: 'Størrelser og avstander', link: '/kom-i-gang/storrelser/' },
            { text: 'Typografi', link: '/kom-i-gang/typografi' },
            { text: 'Avrunding og skygger', link: '/kom-i-gang/avrunding-og-skygger' },
            { text: 'Tilgjengelighet', link: '/kom-i-gang/tilgjengelighet' },
          ],
        },
      ],

      '/komponenter/': [
        {
          text: 'Komponenter',
          items: [
            { text: 'Oversikt', link: '/komponenter/' },
            { text: 'Alert', link: '/komponenter/ds-alert' },
            { text: 'Avatar', link: '/komponenter/ds-avatar' },
            { text: 'AvatarStack', link: '/komponenter/ds-avatar-stack' },
            { text: 'Badge', link: '/komponenter/ds-badge' },
            { text: 'Breadcrumbs', link: '/komponenter/ds-breadcrumbs' },
            { text: 'Button', link: '/komponenter/ds-button' },
            { text: 'Card', link: '/komponenter/ds-card' },
            { text: 'Checkbox', link: '/komponenter/ds-checkbox' },
            { text: 'Chip', link: '/komponenter/ds-chip' },
            { text: 'Details', link: '/komponenter/ds-details' },
            { text: 'Dialog', link: '/komponenter/ds-dialog' },
            { text: 'Divider', link: '/komponenter/ds-divider' },
            { text: 'Dropdown', link: '/komponenter/ds-dropdown' },
            { text: 'ErrorSummary', link: '/komponenter/ds-error-summary' },
            { text: 'Field', link: '/komponenter/ds-field' },
            { text: 'Fieldset', link: '/komponenter/ds-fieldset' },
            { text: 'Heading', link: '/komponenter/ds-heading' },
            { text: 'Input', link: '/komponenter/ds-input' },
            { text: 'Label', link: '/komponenter/ds-label' },
            { text: 'Link', link: '/komponenter/ds-link' },
            { text: 'List', link: '/komponenter/ds-list' },
            { text: 'Pagination', link: '/komponenter/ds-pagination' },
            { text: 'Paragraph', link: '/komponenter/ds-paragraph' },
            { text: 'Popover', link: '/komponenter/ds-popover' },
            { text: 'Radio', link: '/komponenter/ds-radio' },
            { text: 'Search', link: '/komponenter/ds-search' },
            { text: 'Select', link: '/komponenter/ds-select' },
            { text: 'Skeleton', link: '/komponenter/ds-skeleton' },
            { text: 'SkipLink', link: '/komponenter/ds-skip-link' },
            { text: 'Spinner', link: '/komponenter/ds-spinner' },
            { text: 'Suggestion', link: '/komponenter/ds-suggestion' },
            { text: 'Switch', link: '/komponenter/ds-switch' },
            { text: 'Table', link: '/komponenter/ds-table' },
            { text: 'Tabs', link: '/komponenter/ds-tabs' },
            { text: 'Tag', link: '/komponenter/ds-tag' },
            { text: 'Textarea', link: '/komponenter/ds-textarea' },
            { text: 'Textfield', link: '/komponenter/ds-textfield' },
            { text: 'ToggleGroup', link: '/komponenter/ds-toggle-group' },
            { text: 'Tooltip', link: '/komponenter/ds-tooltip' },
            { text: 'ValidationMessage', link: '/komponenter/ds-validation-message' },
          ],
        },
      ],

      '/monstre/': [
        {
          text: 'Mønstre',
          items: [
            { text: 'Oversikt', link: '/monstre/' },
            { text: 'Skjemavalidering', link: '/monstre/skjemavalidering' },
            { text: 'Feilhåndtering', link: '/monstre/feilhandtering' },
            { text: 'Obligatoriske felt', link: '/monstre/obligatoriske-felt' },
            { text: 'Systemvarsler', link: '/monstre/systemvarsler' },
            { text: 'Dato og klokkeslett', link: '/monstre/dato-og-klokkeslett' },
          ],
        },
      ],

      '/god-praksis/': [
        {
          text: 'God praksis',
          items: [
            { text: 'Oversikt', link: '/god-praksis/' },
          ],
        },
        {
          text: 'Tilgjengelighet',
          items: [
            { text: 'Deaktiverte tilstander', link: '/god-praksis/tilgjengelighet/deaktiverte-tilstander' },
            { text: 'Synshemming', link: '/god-praksis/tilgjengelighet/synshemming' },
            { text: 'WCAG-krav', link: '/god-praksis/tilgjengelighet/wcag-krav' },
          ],
        },
        {
          text: 'Innholdsarbeid',
          items: [
            { text: 'Skrive for alle', link: '/god-praksis/innholdsarbeid/skrive-for-alle' },
            { text: 'Tydelig språk', link: '/god-praksis/innholdsarbeid/tydelig-sprak' },
            { text: 'Skannbart innhold', link: '/god-praksis/innholdsarbeid/skannbart-innhold' },
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
