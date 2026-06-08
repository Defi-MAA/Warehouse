<template>
    <div
      class="band"
      :class="{ selected }"
      :style="{ height: band.height + 'px' }"
      @click.stop="$emit('select')"
      v-dropzone="{ bandId: band.id, onDrop: handleDrop }"
    >
      <div class="band-header">
        <span class="band-title">{{ band.title }}</span>
        <span v-if="band.type === 'data'" class="band-datasource">
          数据源: {{ band.dataSource || '未设置' }}
        </span>
        <div class="band-controls">
          <button @click.stop="toggleVisible">👁</button>
          <input type="number" v-model.number="band.height" min="20" step="5" />
        </div>
      </div>
      
      <div class="band-content" v-show="band.visible">
        <!-- 渲染band内的控件 -->
        <Widget
          v-for="widget in band.widgets"
          :key="widget.id"
          :widget="widget"
          :selected="selectedWidgetId === widget.id"
          @select="selectWidget(widget.id)"
          @update="handleWidgetUpdate"
        />
      </div>
      
      <!-- 调整高度手柄 -->
      <div class="resize-handle" @mousedown="startResize"></div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed, ref } from 'vue';
  import { Band, ReportWidget } from '@/views/report/defreport/types';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  import Widget from './Widget.vue';
  import { vDropzone } from '@/views/report/defreport/directives/draggable';
  
  const props = defineProps<{
    band: Band;
    selected: boolean;
  }>();
  
  const emit = defineEmits(['select']);
  
  const store = useReportStore();
  
  const selectedWidgetId = computed(() => 
    store.selection.type === 'widget' && store.selection.bandId === props.band.id 
      ? store.selection.widgetId 
      : null
  );
  
  function selectWidget(id: string) {
    store.selectWidget(props.band.id, id);
  }
  
  function handleDrop({ dragData, position }: any) {
    if (dragData.type === 'new-widget') {
      store.addWidget(props.band.id, dragData.widgetType, position);
    } else if (dragData.type === 'move-widget' && dragData.widgetId) {
      // 移动现有控件
      const newX = position.x - (dragData.offsetX || 0);
      const newY = position.y - (dragData.offsetY || 0);
      store.updateWidgetRect(props.band.id, dragData.widgetId, { x: newX, y: newY });
    }
  }
  
  function handleWidgetUpdate(widgetId: string, updates: any) {
    store.updateWidgetRect(props.band.id, widgetId, updates);
  }
  
  function toggleVisible() {
    props.band.visible = !props.band.visible;
  }
  
  // 调整高度
  function startResize(e: MouseEvent) {
    const startY = e.clientY;
    const startHeight = props.band.height;
    
    const onMouseMove = (moveEvent: MouseEvent) => {
      const dy = moveEvent.clientY - startY;
      props.band.height = Math.max(30, startHeight + dy);
    };
    
    const onMouseUp = () => {
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('mouseup', onMouseUp);
    };
    
    document.addEventListener('mousemove', onMouseMove);
    document.addEventListener('mouseup', onMouseUp);
  }
  </script>
  
  <style scoped>
  .band {
    border: 1px solid #d9d9d9;
    background: #fafafa;
    margin-bottom: 4px;
    position: relative;
  }
  .band.selected {
    border: 2px solid #1890ff;
  }
  .band-header {
    background: #e6f7ff;
    padding: 4px 8px;
    font-size: 12px;
    display: flex;
    align-items: center;
    border-bottom: 1px solid #d9d9d9;
  }
  .band-title {
    font-weight: bold;
    margin-right: 10px;
  }
  .band-datasource {
    color: #666;
    font-size: 11px;
  }
  .band-controls {
    margin-left: auto;
    display: flex;
    gap: 5px;
  }
  .band-content {
    min-height: 20px;
    position: relative;
  }
  .resize-handle {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: transparent;
    cursor: ns-resize;
  }
  .resize-handle:hover {
    background: #1890ff;
  }
  </style>