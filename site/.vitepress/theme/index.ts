import DefaultTheme from 'vitepress/theme'
import WidgetbookEmbed from './WidgetbookEmbed.vue'
import './style.css'

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('WidgetbookEmbed', WidgetbookEmbed)
  },
}
