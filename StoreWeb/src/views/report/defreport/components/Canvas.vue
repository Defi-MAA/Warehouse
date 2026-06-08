<template>
    <div class="canvas-container" :style="canvasStyle">
      <div class="report-page" :style="pageStyle" @click="deselect">
        <!-- 水印 -->
        <div v-if="report.pageSetup.watermark" class="watermark">{{ report.pageSetup.watermark }}</div>
        
        <!-- 渲染所有Band -->
        <Band
          v-for="band in report.bands"
          :key="band.id"
          :band="band"
          :selected="selection.type === 'band' && selection.bandId === band.id"
          @select="$event => selectBand(band.id)"
        />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  import Band from './Band.vue';
  
  const store = useReportStore();
  const report = computed(() => store.report);
  const selection = computed(() => store.selection);
  
  // 缩放比例 (简化，固定)
  const zoom = 1;
  
  const pageStyle = computed(() => ({
    width: `${report.value.pageSetup.width * zoom}mm`,
    minHeight: `${report.value.pageSetup.height * zoom}mm`,
    background: 'white',
    margin: '0 auto',
    position: 'relative' as const,
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    padding: `${report.value.pageSetup.margins.top}mm ${report.value.pageSetup.margins.right}mm ${report.value.pageSetup.margins.bottom}mm ${report.value.pageSetup.margins.left}mm`
  }));
  
  const canvasStyle = computed(() => ({
    overflow: 'auto',
    flex: 1,
    padding: '20px',
    background: '#e0e0e0'
  }));
  
  function selectBand(id: string) {
    store.selectBand(id);
  }
  
  function deselect(e: MouseEvent) {
    // 点击空白区域取消选中
    if ((e.target as HTMLElement).classList.contains('report-page')) {
      store.selection = { type: 'none' };
    }
  }
  </script>
  
  <style scoped>
  .report-page {
    transition: box-shadow 0.2s;
  }
  .watermark {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-30deg);
    font-size: 60px;
    color: rgba(0,0,0,0.08);
    pointer-events: none;
    white-space: nowrap;
  }
  </style>