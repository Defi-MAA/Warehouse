declare module "vue-plugin-hiprint" {
    // 1. 默认导出（在 main.ts 中通过 app.use 使用的对象）
    const hiprint: {
      init: (config?: InitConfig) => void;
      setConfig: (config: PrintConfig) => void;
      PrintTemplate: typeof PrintTemplate;
      PrintDesigner: typeof PrintDesigner;
      parse: (templateJson: string) => any; // 根据模板JSON生成可打印对象
      // 其他你可能会用到的顶层API可以继续添加
    };
    export default hiprint;
   
    // 2. 初始化配置类型
    interface InitConfig {
      providers?: any[];
      optionItems?: any[];
      fontList?: string[];
      // 可根据实际需要补充
    }
   
    // 3. 打印配置类型（对应 hiprint.setConfig）
    interface PrintConfig {
      language?: string;
      printing?: boolean;
      dpi?: number;
      preview?: boolean;
      paper?: PaperConfig;
      font?: FontConfig;
    }
   
    interface PaperConfig {
      size?: string; // 如 'A4'
      width?: number;
      height?: number;
      margin?: MarginConfig;
    }
   
    interface MarginConfig {
      top?: number | string;
      right?: number | string;
      bottom?: number | string;
      left?: number | string;
    }
   
    interface FontConfig {
      family?: string;
      size?: number;
    }
   
    // 4. 打印模板类（对应 new hiprint.PrintTemplate()）
    declare class PrintTemplate {
      constructor(options?: any);
      getJson(): string; // 获取模板JSON
      print(data: any, options?: PrintOptions): void; // 执行打印
      print2(container: HTMLElement, data: any, options?: PrintOptions): void; // 在指定容器内预览
      updateOption(key: string, value: any): void;
      addPanel(panel: PanelOption): void;
      // 根据实际API文档补充更多方法
    }
   
    interface PrintOptions {
      title?: string;
      styleHandler?: () => string;
      callback?: () => void;
    }
   
    interface PanelOption {
      index: number;
      height: number | string;
      width?: number | string;
      elements: ElementOption[];
    }
   
    interface ElementOption {
      type: string; // 'text', 'table', 'image', 'rect', 'html' 等
      title?: string;
      field?: string; // 数据绑定字段
      options: ElementStyleOptions;
    }
   
    interface ElementStyleOptions {
      width: number | string;
      height: number | string;
      left?: number;
      top?: number;
      fontSize?: number;
      fontWeight?: string;
      textAlign?: "left" | "center" | "right";
      color?: string;
      borderWidth?: number;
      borderColor?: string;
      borderStyle?: string;
      // 更多样式选项...
    }
   
    // 5. 设计器类（对应 new hiprint.PrintDesigner()）
    declare class PrintDesigner {
      constructor(options: DesignerOptions);
      destroy(): void;
      addElement(element: ElementOption): void;
      // 根据实际API文档补充更多方法
    }
   
    interface DesignerOptions {
      el: string; // 如 '#designer'
      template?: any; // 模板JSON对象
      onCreated?: (template: any) => void;
      onUpdated?: (template: any) => void;
    }
  }