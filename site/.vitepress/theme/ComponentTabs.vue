<script setup lang="ts">
import { ref, onMounted, onUnmounted, nextTick } from 'vue'

const tabs = [
  { id: 'oversikt', label: 'Oversikt' },
  { id: 'kode', label: 'Kode' },
  { id: 'tilgjengelighet', label: 'Tilgjengelighet' },
]

const activeTab = ref('oversikt')
const tabRefs = ref<(HTMLButtonElement | null)[]>([])

function setTabFromQuery() {
  const fane = new URL(window.location.href).searchParams.get('fane')
  if (fane && tabs.some((t) => t.id === fane)) {
    activeTab.value = fane
  }
}

function selectTab(id: string) {
  activeTab.value = id
  // Lagre aktiv fane som query-parameter slik at vi ikke overskriver
  // overskrifts-ankere (#heading) eller høyre-TOC sin hash.
  const url = new URL(window.location.href)
  url.searchParams.set('fane', id)
  window.history.replaceState(null, '', url)
}

function onKeydown(e: KeyboardEvent, index: number) {
  let next = index
  if (e.key === 'ArrowRight') next = (index + 1) % tabs.length
  else if (e.key === 'ArrowLeft') next = (index - 1 + tabs.length) % tabs.length
  else if (e.key === 'Home') next = 0
  else if (e.key === 'End') next = tabs.length - 1
  else return
  e.preventDefault()
  selectTab(tabs[next].id)
  nextTick(() => tabRefs.value[next]?.focus())
}

onMounted(() => {
  setTabFromQuery()
  window.addEventListener('popstate', setTabFromQuery)
})

onUnmounted(() => {
  window.removeEventListener('popstate', setTabFromQuery)
})
</script>

<template>
  <div class="component-tabs">
    <nav class="component-tabs-nav" role="tablist">
      <button
        v-for="(tab, index) in tabs"
        :key="tab.id"
        :id="`tab-${tab.id}`"
        :ref="(el) => (tabRefs[index] = el as HTMLButtonElement | null)"
        role="tab"
        :aria-selected="activeTab === tab.id"
        :aria-controls="`panel-${tab.id}`"
        :tabindex="activeTab === tab.id ? 0 : -1"
        :class="['component-tab-btn', { active: activeTab === tab.id }]"
        @click="selectTab(tab.id)"
        @keydown="onKeydown($event, index)"
      >
        {{ tab.label }}
      </button>
    </nav>
    <div v-show="activeTab === 'oversikt'" id="panel-oversikt" role="tabpanel" aria-labelledby="tab-oversikt" class="component-tab-panel">
      <slot name="oversikt" />
    </div>
    <div v-show="activeTab === 'kode'" id="panel-kode" role="tabpanel" aria-labelledby="tab-kode" class="component-tab-panel">
      <slot name="kode" />
    </div>
    <div v-show="activeTab === 'tilgjengelighet'" id="panel-tilgjengelighet" role="tabpanel" aria-labelledby="tab-tilgjengelighet" class="component-tab-panel">
      <slot name="tilgjengelighet" />
    </div>
  </div>
</template>
