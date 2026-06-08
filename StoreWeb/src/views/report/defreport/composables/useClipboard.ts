import { ref ,computed} from 'vue';
import { useReportStore } from '@/views/report/defreport/stores/reportStore';
import { ReportWidget } from '@/views/report/defreport/types';

export function useClipboard() {
  const store = useReportStore();
  const clipboardData = ref<ReportWidget | null>(null);
  
  const hasData = computed(() => clipboardData.value !== null);
  
  function cut() {
    if (store.selection.type === 'widget' && store.selection.bandId && store.selection.widgetId) {
      const band = store.report.bands.find(b => b.id === store.selection.bandId);
      const widget = band?.widgets.find(w => w.id === store.selection.widgetId);
      if (widget) {
        clipboardData.value = JSON.parse(JSON.stringify(widget)); // 深拷贝
        store.deleteSelected();
      }
    }
  }
  
  function copy() {
    if (store.selection.type === 'widget' && store.selection.bandId && store.selection.widgetId) {
      const band = store.report.bands.find(b => b.id === store.selection.bandId);
      const widget = band?.widgets.find(w => w.id === store.selection.widgetId);
      if (widget) {
        clipboardData.value = JSON.parse(JSON.stringify(widget));
      }
    }
  }
  
  function paste() {
    if (!clipboardData.value) return;
    
    // 确定粘贴位置：当前选中的band，或者鼠标最后点击的band
    let targetBandId = store.selection.bandId;
    if (!targetBandId && store.report.bands.length > 0) {
      targetBandId = store.report.bands[0].id;
    }
    if (!targetBandId) return;
    
    const newWidget = JSON.parse(JSON.stringify(clipboardData.value));
    newWidget.id = `widget-${Date.now()}-${Math.random()}`;
    newWidget.bandId = targetBandId;
    // 偏移一点避免完全重叠
    newWidget.rect.x += 20;
    newWidget.rect.y += 20;
    
    const band = store.report.bands.find(b => b.id === targetBandId);
    if (band) {
      band.widgets.push(newWidget);
      store.selectWidget(targetBandId, newWidget.id);
    }
  }
  
  return { clipboardData, hasData, cut, copy, paste };
}