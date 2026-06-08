// 控件类型
export type WidgetType = 'text' | 'field' | 'table' | 'image' | 'line' | 'subreport';

// 带区类型
export type BandType = 
  | 'pageHeader' 
  | 'reportTitle' 
  | 'dataHeader' 
  | 'data' 
  | 'dataFooter' 
  | 'pageFooter';

// 报表控件接口
export interface ReportWidget {
  id: string;
  type: WidgetType;
  bandId: string;
  rect: { x: number; y: number; width: number; height: number };
  props: {
    text?: string;                 // 静态文本
    expression?: string;           // 绑定表达式，如 "[params.hotelname]"
    fontSize?: number;
    fontWeight?: string;
    fontFamily?: string;
    alignment?: 'left' | 'center' | 'right';
    border?: boolean;
    backgroundColor?: string;
    // ... 更多属性
  };
}

// 带区定义
export interface Band {
  id: string;
  type: BandType;
  title: string;
  height: number;
  visible: boolean;
  dataSource?: string;             // 绑定的数据源名称（仅DataBand）
  widgets: ReportWidget[];
}

// 报表整体结构
export interface Report {
  pageSetup: {
    width: number;                 // 单位 mm
    height: number;
    orientation: 'portrait' | 'landscape';
    margins: { top: number; right: number; bottom: number; left: number };
    watermark?: string;
  };
  bands: Band[];
  dataSources: Record<string, any[]>;  // 模拟数据
  parameters: Record<string, any>;     // 报表参数
}

// 选中状态
export interface Selection {
  type: 'band' | 'widget' | 'none';
  bandId?: string;
  widgetId?: string;
}