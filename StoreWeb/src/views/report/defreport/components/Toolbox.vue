<template>
    <div class="toolbox">
      <h4>控件工具箱</h4>
      <div class="toolbox-items">
        <div
          v-for="item in widgetTypes"
          :key="item.type"
          class="toolbox-item"
          v-draggable="{ type: 'new-widget', widgetType: item.type }"
        >
          <span class="icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
        </div>
      </div>
      
      <h4 style="margin-top:20px">数据源字段</h4>
      <div class="field-list">
        <div
          v-for="field in availableFields"
          :key="field.name"
          class="field-item"
          v-draggable="{ type: 'new-widget', widgetType: 'field', field: field.name }"
        >
          {{ field.name }} ({{ field.type }})
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  import { vDraggable } from '@/views/report/defreport/directives/draggable';
  
  const store = useReportStore();
  
  const widgetTypes = [
    { type: 'text', label: '文本', icon: 'T' },
    { type: 'field', label: '字段', icon: 'F' },
    { type: 'table', label: '表格', icon: '📊' },
    { type: 'image', label: '图片', icon: '🖼' },
    { type: 'line', label: '线条', icon: '━' }
  ];
  
  const availableFields = computed(() => {
    // 从数据源A中提取字段（简化）
    const sample = store.report.dataSources['A']?.[0] || {};
    return Object.keys(sample).map(key => ({ name: key, type: typeof sample[key] }));
  });
  </script>
  
  <style scoped>
  .toolbox {
    width: 200px;
    background: white;
    border-right: 1px solid #e8e8e8;
    padding: 16px;
    overflow-y: auto;
  }
  .toolbox-items {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }
  .toolbox-item {
    padding: 10px;
    background: #f5f5f5;
    border-radius: 4px;
    cursor: grab;
    display: flex;
    align-items: center;
    gap: 8px;
    border: 1px solid transparent;
  }
  .toolbox-item:hover {
    background: #e6f7ff;
    border-color: #1890ff;
  }
  .icon {
    font-weight: bold;
    font-size: 18px;
  }
  .field-list {
    margin-top: 10px;
  }
  .field-item {
    padding: 6px 8px;
    background: #fff7e6;
    margin-bottom: 4px;
    border-radius: 4px;
    cursor: grab;
    font-size: 12px;
  }
  </style>