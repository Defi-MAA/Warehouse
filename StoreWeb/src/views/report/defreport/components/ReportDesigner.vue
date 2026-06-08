<template>
    <div class="report-designer">
      <Toolbar />
      
      <div class="designer-main">
        <Toolbox />
        
        <div class="canvas-wrapper">
          <div class="canvas-toolbar">
            <div class="page-size-controls">
              <label>页面大小</label>
              <select v-model="report.pageSetup.width" @change="updatePageSize">
                <option :value="210">A4 (210x297)</option>
                <option :value="297">A4 横向</option>
                <option :value="0">自定义</option>
              </select>
              <input v-if="report.pageSetup.width === 0" v-model.number="customWidth" type="number" /> x
              <input v-if="report.pageSetup.width === 0" v-model.number="customHeight" type="number" /> mm
            </div>
            <div class="orientation">
              <button @click="toggleOrientation">定向: {{ report.pageSetup.orientation }}</button>
            </div>
            <div class="margins">
              <span>页边距:</span>
              <input v-model.number="report.pageSetup.margins.top" size="3" /> 
              <input v-model.number="report.pageSetup.margins.right" size="3" /> 
              <input v-model.number="report.pageSetup.margins.bottom" size="3" /> 
              <input v-model.number="report.pageSetup.margins.left" size="3" />
            </div>
            <button @click="addWatermark">水印...</button>
          </div>
          
          <Canvas />
        </div>
        
        <PropertyPanel />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  import Toolbar from './Toolbar.vue';
  import Toolbox from './Toolbox.vue';
  import Canvas from './Canvas.vue';
  import PropertyPanel from './PropertyPanel.vue';
  
  const store = useReportStore();
  const report = computed(() => store.report);
  
  const customWidth = computed({
    get: () => report.value.pageSetup.width,
    set: (val) => store.report.pageSetup.width = val
  });
  const customHeight = computed({
    get: () => report.value.pageSetup.height,
    set: (val) => store.report.pageSetup.height = val
  });
  
  function updatePageSize(e: Event) {
    const val = (e.target as HTMLSelectElement).value;
    if (val === '210') {
      store.report.pageSetup.width = 210;
      store.report.pageSetup.height = 297;
      store.report.pageSetup.orientation = 'portrait';
    } else if (val === '297') {
      store.report.pageSetup.width = 297;
      store.report.pageSetup.height = 210;
      store.report.pageSetup.orientation = 'landscape';
    }
  }
  
  function toggleOrientation() {
    const old = store.report.pageSetup;
    [old.width, old.height] = [old.height, old.width];
    old.orientation = old.orientation === 'portrait' ? 'landscape' : 'portrait';
  }
  
  function addWatermark() {
    const text = prompt('输入水印文字');
    if (text) store.report.pageSetup.watermark = text;
  }
  </script>
  
  <style scoped>
  .report-designer {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background: #f0f2f5;
  }
  .designer-main {
    display: flex;
    flex: 1;
    overflow: hidden;
  }
  .canvas-wrapper {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #e0e0e0;
    padding: 16px;
  }
  .canvas-toolbar {
    background: white;
    padding: 8px 16px;
    border-radius: 4px 4px 0 0;
    display: flex;
    gap: 20px;
    align-items: center;
    flex-wrap: wrap;
  }
  </style>