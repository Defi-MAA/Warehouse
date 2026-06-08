<template>
    <div class="toolbar">
      <div class="toolbar-group">
        <button @click="clipboard.cut" :disabled="!hasSelection">剪切</button>
        <button @click="clipboard.copy" :disabled="!hasSelection">复制</button>
        <button @click="clipboard.paste" :disabled="!clipboard.hasData">粘贴</button>
        <button @click="deleteSelected" :disabled="!hasSelection">删除</button>
      </div>
      
      <div class="toolbar-group">
        <button @click="applyFormat('bold')"><b>B</b></button>
        <button @click="applyFormat('italic')"><i>I</i></button>
        <button @click="applyFormat('underline')"><u>U</u></button>
        <select v-model="fontSize" @change="applyFormat('fontSize', fontSize)">
          <option v-for="s in [8,10,12,14,16,18,20,24]" :key="s" :value="s">{{ s }}</option>
        </select>
      </div>
      
      <div class="toolbar-group">
        <button @click="alignLeft">左对齐</button>
        <button @click="alignCenter">居中</button>
        <button @click="alignRight">右对齐</button>
      </div>
      
      <div class="toolbar-group">
        <button @click="toggleBorder">边框</button>
        <input type="color" @change="setBackgroundColor" />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from 'vue';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  import { useClipboard } from '@/views/report/defreport/composables/useClipboard';
  
  const store = useReportStore();
  const clipboard = useClipboard();
  
  const hasSelection = computed(() => store.selection.type !== 'none');
  const fontSize = ref(12);
  
  function deleteSelected() {
    store.deleteSelected();
  }
  
  function applyFormat(prop: string, value?: any) {
    if (store.selection.type === 'widget' && store.selection.bandId && store.selection.widgetId) {
      if (prop === 'bold') {
        const current = store.selectedWidget?.props.fontWeight === 'bold' ? 'normal' : 'bold';
        store.updateWidgetProps(store.selection.bandId, store.selection.widgetId, { fontWeight: current });
      } else if (prop === 'fontSize') {
        store.updateWidgetProps(store.selection.bandId, store.selection.widgetId, { fontSize: value });
      }
    }
  }
  
  function alignLeft() { setAlignment('left'); }
  function alignCenter() { setAlignment('center'); }
  function alignRight() { setAlignment('right'); }
  function setAlignment(align: string) {
    if (store.selection.type === 'widget' && store.selection.bandId && store.selection.widgetId) {
      store.updateWidgetProps(store.selection.bandId, store.selection.widgetId, { alignment: align });
    }
  }
  
  function toggleBorder() {
    if (store.selection.type === 'widget' && store.selection.bandId && store.selection.widgetId) {
      const current = store.selectedWidget?.props.border || false;
      store.updateWidgetProps(store.selection.bandId, store.selection.widgetId, { border: !current });
    }
  }
  
  function setBackgroundColor(e: Event) {
    const color = (e.target as HTMLInputElement).value;
    if (store.selection.type === 'widget' && store.selection.bandId && store.selection.widgetId) {
      store.updateWidgetProps(store.selection.bandId, store.selection.widgetId, { backgroundColor: color });
    }
  }
  </script>
  
  <style scoped>
  .toolbar {
    background: #fff;
    border-bottom: 1px solid #e8e8e8;
    padding: 8px 16px;
    display: flex;
    gap: 16px;
  }
  .toolbar-group {
    display: flex;
    gap: 4px;
  }
  button {
    padding: 4px 10px;
    border: 1px solid #d9d9d9;
    background: white;
    border-radius: 2px;
    cursor: pointer;
  }
  button:hover { background: #f5f5f5; }
  button:disabled { opacity: 0.5; cursor: not-allowed; }
  </style>