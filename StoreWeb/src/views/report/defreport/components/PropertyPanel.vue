<template>
    <div class="property-panel">
      <h4>属性</h4>
      
      <div v-if="selection.type === 'none'">
        <p>未选中任何对象</p>
      </div>
      
      <div v-else-if="selection.type === 'band' && selectedBand">
        <div class="prop-group">
          <label>标题</label>
          <input v-model="selectedBand.title" />
        </div>
        <div class="prop-group">
          <label>高度 (px)</label>
          <input type="number" v-model.number="selectedBand.height" />
        </div>
        <div class="prop-group" v-if="selectedBand.type === 'data'">
          <label>数据源</label>
          <select v-model="selectedBand.dataSource">
            <option v-for="ds in dataSources" :key="ds" :value="ds">{{ ds }}</option>
          </select>
        </div>
      </div>
      
      <div v-else-if="selection.type === 'widget' && selectedWidget">
        <div class="prop-group">
          <label>类型</label>
          <span>{{ selectedWidget.type }}</span>
        </div>
        <div class="prop-group">
          <label>X</label>
          <input type="number" v-model.number="selectedWidget.rect.x" />
        </div>
        <div class="prop-group">
          <label>Y</label>
          <input type="number" v-model.number="selectedWidget.rect.y" />
        </div>
        <div class="prop-group">
          <label>宽度</label>
          <input type="number" v-model.number="selectedWidget.rect.width" />
        </div>
        <div class="prop-group">
          <label>高度</label>
          <input type="number" v-model.number="selectedWidget.rect.height" />
        </div>
        
        <div class="prop-group" v-if="selectedWidget.type === 'text' || selectedWidget.type === 'field'">
          <label>文本/表达式</label>
          <textarea v-model="selectedWidget.props.text" v-if="selectedWidget.type === 'text'"></textarea>
          <textarea v-model="selectedWidget.props.expression" v-else placeholder="[params.xxx] 或 [数据源.字段]"></textarea>
        </div>
        
        <div class="prop-group">
          <label>字体大小</label>
          <input type="number" v-model.number="selectedWidget.props.fontSize" />
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue';
  import { useReportStore } from '@/views/report/defreport/stores/reportStore';
  
  const store = useReportStore();
  const selection = computed(() => store.selection);
  const selectedBand = computed(() => store.selectedBand);
  const selectedWidget = computed(() => store.selectedWidget);
  const dataSources = computed(() => Object.keys(store.report.dataSources));
  </script>
  
  <style scoped>
  .property-panel {
    width: 260px;
    background: white;
    border-left: 1px solid #e8e8e8;
    padding: 16px;
    overflow-y: auto;
  }
  .prop-group {
    margin-bottom: 12px;
  }
  .prop-group label {
    display: block;
    font-size: 12px;
    color: #666;
    margin-bottom: 4px;
  }
  .prop-group input, .prop-group select, .prop-group textarea {
    width: 100%;
    padding: 6px;
    border: 1px solid #d9d9d9;
    border-radius: 2px;
  }
  </style>