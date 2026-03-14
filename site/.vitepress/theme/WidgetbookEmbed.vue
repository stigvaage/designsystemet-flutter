<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  component: string
  height?: number
}>(), {
  height: 400,
})

const baseUrl = import.meta.env.BASE_URL ?? '/komponentbibliotek-flutter/'
const src = computed(() => {
  const path = encodeURIComponent(props.component)
  return `${baseUrl}widgetbook/?path=${path}`
})
</script>

<template>
  <div class="widgetbook-embed">
    <iframe
      :src="src"
      :style="{ height: `${height}px` }"
      frameborder="0"
      loading="lazy"
      allow="clipboard-write"
      title="Interaktiv komponentforhåndsvisning i Widgetbook"
    />
  </div>
</template>

<style scoped>
.widgetbook-embed {
  margin: 16px 0;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  overflow: hidden;
}

.widgetbook-embed iframe {
  width: 100%;
  display: block;
  background: var(--vp-c-bg);
}
</style>
