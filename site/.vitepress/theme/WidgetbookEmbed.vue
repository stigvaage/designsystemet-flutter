<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  component: string
}>()

const baseUrl = import.meta.env.BASE_URL ?? '/komponentbibliotek-flutter/'
const widgetbookUrl = computed(() => {
  const path = props.component
    .replace(/ /g, '-')
    .toLowerCase()
  return `${baseUrl}widgetbook/#/?path=${encodeURIComponent(path)}`
})

const componentName = computed(() => {
  const parts = props.component.split('/')
  return parts.length === 3 ? parts[1] : parts[parts.length - 1]
})
</script>

<template>
  <div class="widgetbook-link">
    <a :href="widgetbookUrl" target="_blank" rel="noopener noreferrer" class="widgetbook-link-card">
      <span class="widgetbook-link-icon" aria-hidden="true">&#9654;</span>
      <span class="widgetbook-link-text">
        <span class="widgetbook-link-title">Prøv {{ componentName }} i Widgetbook</span>
        <span class="widgetbook-link-desc">Interaktiv forhåndsvisning med justerbare egenskaper</span>
      </span>
      <span class="widgetbook-link-arrow" aria-hidden="true">&#8599;</span>
    </a>
  </div>
</template>

<style scoped>
.widgetbook-link {
  margin: 16px 0;
}

.widgetbook-link-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 16px 20px;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  background: var(--vp-c-bg-soft);
  text-decoration: none;
  color: inherit;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.widgetbook-link-card:hover {
  border-color: var(--vp-c-brand-1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.dark .widgetbook-link-card:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.24);
}

.widgetbook-link-card:focus-visible {
  outline: 2px solid var(--vp-c-brand-1);
  outline-offset: 2px;
}

.widgetbook-link-icon {
  font-size: 20px;
  color: var(--vp-c-brand-1);
  flex-shrink: 0;
}

.widgetbook-link-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex: 1;
}

.widgetbook-link-title {
  font-size: 15px;
  font-weight: 500;
  color: var(--vp-c-brand-1);
}

.widgetbook-link-desc {
  font-size: 13px;
  color: var(--vp-c-text-2);
}

.widgetbook-link-arrow {
  font-size: 16px;
  color: var(--vp-c-text-3);
  flex-shrink: 0;
}
</style>
