import { defineStore } from 'pinia';
import { Report, Band, ReportWidget, Selection, WidgetType } from '@/views/report/defreport/types';

export const useReportStore = defineStore('report', {
  state: () => ({
    report: {
      pageSetup: {
        width: 210,
        height: 297,
        orientation: 'portrait',
        margins: { top: 10, right: 10, bottom: 10, left: 10 }
      },
      bands: [
        { id: 'band-pageheader', type: 'pageHeader', title: '页眉', height: 60, visible: true, widgets: [] },
        { id: 'band-title', type: 'reportTitle', title: '报表标题', height: 80, visible: true, widgets: [] },
        { id: 'band-data', type: 'data', title: '数据区', height: 200, visible: true, dataSource: 'A', widgets: [] },
      ] as Band[],
      dataSources: {
        'A': [
          { dtamt: 12000, mtamt: 11500, rnnight: 85, rums: 82, chuzulv: 0.78, pingjunfangzui: 380 },
          // ...更多数据
        ]
      },
      parameters: {
        hotelname: '阳光大酒店',
        clerkname: '张三',
        AccDate: '2024-01-15'
      }
    } as Report,
    
    selection: { type: 'none' } as Selection,
    
    // 辅助方法
    selectedBand: (state) => state.report.bands.find(b => b.id === state.selection.bandId),
    selectedWidget: (state) => {
      if (state.selection.type !== 'widget') return null;
      const band = state.report.bands.find(b => b.id === state.selection.bandId);
      return band?.widgets.find(w => w.id === state.selection.widgetId);
    }
  }),
  
  actions: {
    // 添加控件到指定band
    addWidget(bandId: string, widgetType: WidgetType, position: { x: number; y: number }) {
      const band = this.report.bands.find(b => b.id === bandId);
      if (!band) return;
      
      const newWidget: ReportWidget = {
        id: `widget-${Date.now()}-${Math.random()}`,
        type: widgetType,
        bandId,
        rect: { x: position.x, y: position.y, width: 100, height: 30 },
        props: {
          text: widgetType === 'text' ? '文本' : '',
          fontSize: 12,
          alignment: 'left'
        }
      };
      
      band.widgets.push(newWidget);
      this.selectWidget(bandId, newWidget.id);
    },
    
    // 删除选中项
    deleteSelected() {
      if (this.selection.type === 'widget' && this.selection.bandId && this.selection.widgetId) {
        const band = this.report.bands.find(b => b.id === this.selection.bandId);
        if (band) {
          band.widgets = band.widgets.filter(w => w.id !== this.selection.widgetId);
        }
      } else if (this.selection.type === 'band' && this.selection.bandId) {
        // 删除band (保留至少一个band)
        if (this.report.bands.length > 1) {
          this.report.bands = this.report.bands.filter(b => b.id !== this.selection.bandId);
        }
      }
      this.selection = { type: 'none' };
    },
    
    // 选中控件
    selectWidget(bandId: string, widgetId: string) {
      this.selection = { type: 'widget', bandId, widgetId };
    },
    
    // 选中band
    selectBand(bandId: string) {
      this.selection = { type: 'band', bandId };
    },
    
    // 更新控件位置/大小
    updateWidgetRect(bandId: string, widgetId: string, rect: Partial<ReportWidget['rect']>) {
      const band = this.report.bands.find(b => b.id === bandId);
      const widget = band?.widgets.find(w => w.id === widgetId);
      if (widget) Object.assign(widget.rect, rect);
    },
    
    // 更新控件属性
    updateWidgetProps(bandId: string, widgetId: string, props: Partial<ReportWidget['props']>) {
      const band = this.report.bands.find(b => b.id === bandId);
      const widget = band?.widgets.find(w => w.id === widgetId);
      if (widget) Object.assign(widget.props, props);
    }
  }
});