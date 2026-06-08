<template>
    <div
      class="report-widget"
      :class="{ selected }"
      :style="widgetStyle"
      @click.stop="$emit('select')"
      v-draggable="{ type: 'move-widget', widgetId: widget.id, bandId: widget.bandId }"
    >
      <!-- 根据类型渲染不同内容 -->
      <div v-if="widget.type === 'text'" class="widget-content" :style="textStyle">
        {{ widget.props.text }}
      </div>
      <div v-else-if="widget.type === 'field'" class="widget-content field" :style="textStyle">
        {{ evaluateExpression(widget.props.expression) }}
      </div>
      <div v-else class="widget-content">
        [{{ widget.type }}]
      </div>
      
      <!-- 调整大小手柄 -->
      <div class="resize-handle" @mousedown.stop="startResize($event, 'se')"></div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue';
  import { ReportWidget } from '@/views/report/defreport/types';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  import { vDraggable } from '@/views/report/defreport/directives/draggable';
  
  const props = defineProps<{
    widget: ReportWidget;
    selected: boolean;
  }>();
  
  const emit = defineEmits(['select', 'update']);
  
  const store = useReportStore();
  
  const widgetStyle = computed(() => ({
    position: 'absolute' as const,
    left: props.widget.rect.x + 'px',
    top: props.widget.rect.y + 'px',
    width: props.widget.rect.width + 'px',
    height: props.widget.rect.height + 'px',
    border: props.widget.props.border ? '1px solid #333' : 'none',
    backgroundColor: props.widget.props.backgroundColor || 'transparent',
    cursor: 'move'
  }));
  
  const textStyle = computed(() => ({
    fontSize: props.widget.props.fontSize + 'px',
    fontWeight: props.widget.props.fontWeight || 'normal',
    textAlign: props.widget.props.alignment || 'left',
    width: '100%',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    padding: '2px'
  }));
  
  // 简单表达式求值 (支持 [params.xxx] 和 [A.field])
  function evaluateExpression(expr?: string): string {
    if (!expr) return '';
    const match = expr.match(/\[([^\]]+)\]/);
    if (!match) return expr;
    
    const path = match[1].split('.');
    if (path[0] === 'params') {
      return store.report.parameters[path[1]]?.toString() || '';
    } else if (store.report.dataSources[path[0]]) {
      // 实际应该取当前数据行，这里简化返回第一条
      const data = store.report.dataSources[path[0]][0];
      return data?.[path[1]]?.toString() || '';
    }
    return expr;
  }
  
  function startResize(e: MouseEvent, direction: string) {
    e.stopPropagation();
    const startX = e.clientX;
    const startY = e.clientY;
    const startWidth = props.widget.rect.width;
    const startHeight = props.widget.rect.height;
    
    const onMouseMove = (moveEvent: MouseEvent) => {
      const dx = moveEvent.clientX - startX;
      const dy = moveEvent.clientY - startY;
      emit('update', {
        width: Math.max(20, startWidth + dx),
        height: Math.max(20, startHeight + dy)
      });
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
  .report-widget {
    box-sizing: border-box;
    user-select: none;
  }
  .report-widget.selected {
    outline: 2px solid #1890ff;
    outline-offset: -1px;
  }
  .widget-content {
    overflow: hidden;
    white-space: nowrap;
  }
  .field {
    background: #fff7e6;
    border: 1px dashed #faad14;
  }
  .resize-handle {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 8px;
    height: 8px;
    background: #1890ff;
    cursor: nwse-resize;
  }
  </style>