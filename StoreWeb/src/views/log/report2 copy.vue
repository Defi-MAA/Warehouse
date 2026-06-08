<template>
    <div class="hiprint-demo">
      <h2>🖨️ vue-plugin-hiprint 简单示例</h2>
      
      <!-- 调试信息 -->
      <div class="debug-bar">
        <span>jQuery: {{ jQueryExists ? '✅' : '❌' }}</span>
        <span>hiprint: {{ hiprintExists ? '✅' : '❌' }}</span>
        <span>容器: {{ designerRef ? '✅' : '❌' }}</span>
        <span>模板: {{ hiprintTemplate ? '✅' : '❌' }}</span>
      </div>
  
      <!-- 按钮组 -->
      <div class="buttons">
        <button @click="init" class="btn blue" :disabled="initializing">
          {{ initializing ? '初始化中...' : '1. 初始化' }}
        </button>
        <button @click="loadTemplate" class="btn green" :disabled="!hiprintTemplate">2. 加载模板</button>
        <button @click="loadData" class="btn orange" :disabled="!hiprintTemplate">3. 加载数据</button>
        <button @click="print" class="btn red" :disabled="!canPrint">🖨️ 打印</button>
        <button @click="exportPDF" class="btn gray" :disabled="!canPrint">📑 PDF</button>
      </div>
  
      <!-- 设计器容器 - 直接用 ref -->
      <div ref="designerRef" class="designer">
        <div v-if="!hiprintTemplate" class="placeholder">
          点击「初始化」按钮开始
        </div>
      </div>
  
      <!-- 隐藏的设置容器 -->
      <div ref="settingRef" style="display: none;"></div>
  
      <!-- 数据预览 -->
      <div v-if="Object.keys(printData).length" class="preview">
        <h4>当前数据：</h4>
        <pre>{{ JSON.stringify(printData, null, 2) }}</pre>
      </div>
    </div>
  </template>
  
  <script setup>

import { ref, computed,nextTick } from 'vue'
  import { hiprint } from 'vue-plugin-hiprint'
  
  // refs - 不需要类型
  const designerRef = ref(null)
  const settingRef = ref(null)
  
  // 状态
  const hiprintTemplate = ref(null)
  const printData = ref({})
  const initializing = ref(false)
  
  // 计算属性
  const jQueryExists = computed(() => typeof window.jQuery !== 'undefined')
  const hiprintExists = computed(() => typeof hiprint !== 'undefined')
  const canPrint = computed(() => hiprintTemplate.value && Object.keys(printData.value).length > 0)
  
  // 模板
  const templateJson = {
  "panels": [
    {
      "index": 0,
      "name": 1,
      "height": 297,
      "width": 210,
      "paperHeader": 49.5,
      "paperFooter": 780.0000000000001,
      "printElements": [
        {
          "options": {
            "left": 0,
            "top": 0,
            "height": 22.5,
            "width": 114,
            "title": "为了看打印边距(Safari)",
            "right": 82.5,
            "bottom": 9.75,
            "vCenter": 41.25,
            "hCenter": 4.875,
            "coordinateSync": false,
            "widthHeightSync": false,
            "color": "#ffffff",
            "backgroundColor": "#57b3ff",
            "textAlign": "center",
            "textContentVerticalAlign": "middle",
            "qrCodeLevel": 0
          },
          "printElementType": {
            "title": "这是更新后的元素",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 175.5,
            "top": 10.5,
            "height": 27,
            "width": 259,
            "title": "HiPrint自定义模块打印插件",
            "fontSize": 19,
            "fontWeight": "600",
            "textAlign": "center",
            "lineHeight": 26,
            "coordinateSync": true,
            "widthHeightSync": true,
            "draggable": false
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 27,
            "height": 13,
            "width": 52,
            "title": "页眉线",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 570,
            "top": 51,
            "height": 109.5,
            "width": 24,
            "title": "为了看打印边距",
            "right": 597,
            "bottom": 159.75,
            "vCenter": 585,
            "hCenter": 105,
            "coordinateSync": false,
            "widthHeightSync": false,
            "letterSpacing": 4.5,
            "color": "#ffffff",
            "backgroundColor": "#57b3ff",
            "textAlign": "center",
            "textContentVerticalAlign": "middle",
            "qrCodeLevel": 0
          },
          "printElementType": {
            "title": "这是更新后的元素",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 0,
            "top": 51,
            "height": 109.5,
            "width": 24,
            "title": "为了看打印边距",
            "right": -3,
            "bottom": 154.5,
            "vCenter": -15,
            "hCenter": 99.75,
            "coordinateSync": false,
            "widthHeightSync": false,
            "letterSpacing": 4.5,
            "color": "#ffffff",
            "backgroundColor": "#57b3ff",
            "textAlign": "center",
            "textContentVerticalAlign": "middle",
            "qrCodeLevel": 0
          },
          "printElementType": {
            "title": "这是更新后的元素",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 25.5,
            "top": 57,
            "height": 705,
            "width": 9,
            "fixed": true,
            "borderStyle": "dotted"
          },
          "printElementType": {
            "type": "vline"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 61.5,
            "height": 48,
            "width": 87,
            "src": "",
            "fit": "contain"
          },
          "printElementType": {
            "title": "图片",
            "type": "image"
          }
        },
        {
          "options": {
            "left": 153,
            "top": 64.5,
            "height": 39,
            "width": 276,
            "title": "二维码以及条形码均采用svg格式打印。不同打印机打印不会造成失真。图片打印：不同DPI打印可能会导致失真，",
            "fontFamily": "微软雅黑",
            "textAlign": "center",
            "lineHeight": 18
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 457.5,
            "top": 79.5,
            "height": 13,
            "width": 120,
            "title": "姓名",
            "field": "name",
            "testData": "古力娜扎",
            "color": "#f00808",
            "textDecoration": "underline",
            "textAlign": "center",
            "fields": [
              {
                "text": "id",
                "field": "id"
              },
              {
                "text": "姓名",
                "field": "name"
              },
              {
                "text": "性别",
                "field": "gender"
              },
              {
                "text": "数量",
                "field": "count"
              }
            ]
          },
          "printElementType": {
            "title": "文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 110,
            "height": 19,
            "width": 213,
            "title": "所有打印元素都可已拖拽的方式来改变元素大小",
            "fontFamily": "微软雅黑",
            "textAlign": "center",
            "lineHeight": 18
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 483,
            "top": 115,
            "height": 60,
            "width": 60,
            "title": "123456789",
            "textAlign": "center",
            "textType": "qrcode"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 285,
            "top": 125,
            "height": 40,
            "width": 175,
            "title": "123456789",
            "fontFamily": "微软雅黑",
            "textAlign": "center",
            "textType": "barcode"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 140,
            "top": 130,
            "height": 40,
            "width": 120,
            "title": "barcode",
            "field": "barcode",
            "testData": "barcode",
            "barcodeType": "code128"
          },
          "printElementType": {
            "title": "条形码",
            "type": "barcode"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 130,
            "height": 60,
            "width": 60,
            "title": "qrcode",
            "field": "qrcode",
            "testData": "qrcode",
            "qrcodeType": "qrcode"
          },
          "printElementType": {
            "title": "二维码",
            "type": "qrcode"
          }
        },
        {
          "options": {
            "left": 153,
            "top": 189,
            "height": 13,
            "width": 238,
            "title": "单击元素，右侧可自定义元素属性",
            "textAlign": "center",
            "fontFamily": "微软雅黑"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 190.5,
            "height": 13,
            "width": 51,
            "title": "横线",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 415.5,
            "top": 190.5,
            "height": 13,
            "width": 164,
            "title": "可以配置各属性的默认值",
            "textAlign": "center",
            "fontFamily": "微软雅黑"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 214.5,
            "height": 10,
            "width": 475.5,
            "borderWidth": 0.75
          },
          "printElementType": {
            "title": "横线",
            "type": "hline"
          }
        },
        {
          "options": {
            "left": 235.5,
            "top": 220.5,
            "height": 32,
            "width": 342,
            "title": "自定义表格：用户可左键选中表头，右键查看可操作项，操作类似Excel，双击表头单元格可进行编辑。内容：title#field",
            "fontFamily": "微软雅黑",
            "textAlign": "center",
            "lineHeight": 15
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 156,
            "top": 265.5,
            "height": 13,
            "width": 94,
            "title": "表头列大小可拖动",
            "fontFamily": "微软雅黑",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 265.5,
            "height": 13,
            "width": 90,
            "title": "红色区域可拖动",
            "fontFamily": "微软雅黑",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 285,
            "height": 56,
            "width": 511.5,
            "field": "table",
            "tableFooterRepeat": "",
            "tableBorder": "noBorder",
            "tableHeaderBorder": "topBorder",
            "tableHeaderCellBorder": "border",
            "tableBodyRowBorder": "topBorder",
            "tableFooterBorder": "topBorder",
            "fields": [
              {
                "text": "id",
                "field": "id"
              },
              {
                "text": "姓名",
                "field": "name"
              },
              {
                "text": "性别",
                "field": "gender"
              },
              {
                "text": "数量",
                "field": "count"
              }
            ],
            "columns": [
              [
                {
                  "width": 102.30000000000001,
                  "checked": true,
                  "fixed": false,
                  "rowspan": 1,
                  "colspan": 1
                },
                {
                  "width": 102.30000000000001,
                  "title": "姓名",
                  "field": "name",
                  "checked": true,
                  "columnId": "name",
                  "fixed": false,
                  "rowspan": 1,
                  "colspan": 1,
                  "align": "center",
                  "tableSummary": "count"
                },
                {
                  "width": 102.30000000000001,
                  "title": "数量",
                  "field": "count",
                  "checked": true,
                  "columnId": "count",
                  "fixed": false,
                  "rowspan": 1,
                  "colspan": 1,
                  "align": "center",
                  "tableSummary": "sum"
                },
                {
                  "width": 102.30000000000001,
                  "checked": true,
                  "fixed": false,
                  "rowspan": 1,
                  "colspan": 1
                },
                {
                  "width": 102.30000000000001,
                  "checked": true,
                  "fixed": false,
                  "rowspan": 1,
                  "colspan": 1
                },
                {
                  "width": 85.25,
                  "title": "性别",
                  "field": "gender",
                  "checked": false,
                  "columnId": "gender",
                  "fixed": false,
                  "rowspan": 1,
                  "colspan": 1
                }
              ]
            ]
          },
          "printElementType": {
            "title": "表格",
            "type": "table",
            "editable": true,
            "columnDisplayEditable": true,
            "columnDisplayIndexEditable": true,
            "columnTitleEditable": true,
            "columnResizable": true,
            "columnAlignEditable": true,
            "isEnableEditField": true,
            "isEnableContextMenu": true,
            "isEnableInsertRow": true,
            "isEnableDeleteRow": true,
            "isEnableInsertColumn": true,
            "isEnableDeleteColumn": true,
            "isEnableMergeCell": true
          }
        },
        {
          "options": {
            "left": 21,
            "top": 346.5,
            "height": 61.5,
            "width": 15,
            "title": "装订线",
            "lineHeight": 18,
            "fixed": true,
            "contentPaddingTop": 3.75,
            "backgroundColor": "#ffffff"
          },
          "printElementType": {
            "type": "text"
          }
        },
        {
          "options": {
            "left": 225,
            "top": 355,
            "height": 13,
            "width": 346.5,
            "title": "自定义模块：主要为开发人员设计，能够快速，简单，实现自己功能",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 370.5,
            "height": 18,
            "width": 79,
            "title": "配置项表格",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 225,
            "top": 385.5,
            "height": 38,
            "width": 346.5,
            "title": "配置模块：主要为客户使用，开发人员可以配置属性，字段，标题等，客户直接使用，配置模块请参考实例2",
            "fontFamily": "微软雅黑",
            "lineHeight": 15,
            "textAlign": "center",
            "color": "#d93838"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 487.5,
            "height": 13,
            "width": 123,
            "title": "长文本会自动分页",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 507,
            "height": 40,
            "width": 511.5,
            "field": "longText"
          },
          "printElementType": {
            "title": "长文",
            "type": "longText"
          }
        },
        {
          "options": {
            "left": 475.5,
            "top": 565.5,
            "height": 100,
            "width": 100
          },
          "printElementType": {
            "title": "矩形",
            "type": "rect"
          }
        },
        {
          "options": {
            "left": 174,
            "top": 568.5,
            "height": 13,
            "width": 90,
            "title": "竖线",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 60,
            "top": 574.5,
            "height": 100,
            "width": 10
          },
          "printElementType": {
            "title": "竖线",
            "type": "vline"
          }
        },
        {
          "options": {
            "left": 210,
            "top": 604.5,
            "height": 13,
            "width": 120,
            "title": "横线",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 130.5,
            "top": 625.5,
            "height": 10,
            "width": 277,
            "borderWidth": 0.75
          },
          "printElementType": {
            "title": "横线",
            "type": "hline"
          }
        },
        {
          "options": {
            "left": 364.5,
            "top": 649.5,
            "height": 13,
            "width": 101,
            "title": "矩形",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 525,
            "top": 784.5,
            "height": 13,
            "width": 63,
            "title": "页尾线",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 12,
            "top": 786,
            "height": 49,
            "width": 49
          },
          "printElementType": {
            "title": "html",
            "type": "html"
          }
        },
        {
          "options": {
            "left": 75,
            "top": 790.5,
            "height": 13,
            "width": 137,
            "title": "红色原型是自动定义的Html",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 334.5,
            "top": 810,
            "height": 13,
            "width": 205,
            "title": "页眉线已上。页尾下以下每页都会重复打印",
            "textAlign": "center"
          },
          "printElementType": {
            "title": "自定义文本",
            "type": "text"
          }
        },
        {
          "options": {
            "left": 0,
            "top": 816,
            "height": 22.5,
            "width": 114,
            "title": "为了看打印边距(Safari)",
            "right": 99.99609375,
            "bottom": 845.49609375,
            "vCenter": 42.99609375,
            "hCenter": 834.24609375,
            "coordinateSync": false,
            "widthHeightSync": false,
            "color": "#ffffff",
            "backgroundColor": "#57b3ff",
            "textAlign": "center",
            "textContentVerticalAlign": "middle",
            "qrCodeLevel": 0
          },
          "printElementType": {
            "title": "这是更新后的元素",
            "type": "text"
          }
        }
      ],
      "paperNumberLeft": 565.5,
      "paperNumberTop": 573,
      "paperNumberContinue": true,
      "watermarkOptions": {
        "content": "vue-plugin-hiprint",
        "rotate": 25,
        "timestamp": true,
        "format": "YYYY-MM-DD HH:mm"
      },
      "panelLayoutOptions": {}
    }
  ]
}
  
  // 数据
  const mockData = {
    title: '销售出库单',
    orderNo: 'SO-20240319-001'
  }
  
  // 初始化
  const init = async () => {
    initializing.value = true
    
    try {
      console.log('开始初始化...')
      
      // 检查容器
      if (!designerRef.value) {
        throw new Error('容器不存在')
      }
      
      // 清空容器
      designerRef.value.innerHTML = ''
      
      // 初始化 hiprint
      hiprint.init?.()
      console.log(settingRef.value)
      await nextTick()
      // 创建模板实例
      hiprintTemplate.value = new hiprint.PrintTemplate({
        settingContainer: settingRef.value
      })
      
      console.log(hiprintTemplate)
      // 挂载设计器
      hiprintTemplate.value.design(designerRef.value)
      
      console.log('初始化成功')
     // alert('初始化成功')
      
    } catch (err) {
      console.error('初始化失败:', err)
      alert('初始化失败: ' + err.message)
    } finally {
      initializing.value = false
    }
  }
  
  // 加载模板
  const loadTemplate = () => {
    try {
      hiprintTemplate.value?.update(templateJson)

      $('#preview_content_design').html(hiprintTemplate.value.getHtml(printData.value))
      console.log('模板加载成功')
      alert('模板加载成功')
    } catch (err) {
      alert('加载失败: ' + err.message)
    }
  }
  
  // 加载数据
  const loadData = () => {
    printData.value = { ...mockData }
    console.log('数据:', printData.value)
    alert('数据加载成功')
  }
  
  // 打印
  const print = () => {
    try {
      hiprintTemplate.value?.print(printData.value)
    } catch (err) {
      alert('打印失败: ' + err.message)
    }
  }
  
  // 导出PDF
  const exportPDF = () => {
    try {
      hiprintTemplate.value?.print(printData.value, {
        styleHandler: () => '<style>body { -webkit-print-color-adjust: exact; }</style>'
      })
      alert('请在打印对话框选择「另存为PDF」')
    } catch (err) {
      alert('导出失败: ' + err.message)
    }
  }
  </script>
  
  <style scoped>
  .hiprint-demo {
    max-width: 1000px;
    margin: 20px auto;
    padding: 20px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }
  
  .debug-bar {
    display: flex;
    gap: 20px;
    padding: 10px;
    background: #f5f5f5;
    border-radius: 4px;
    margin-bottom: 20px;
    font-size: 14px;
  }
  
  .buttons {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
  }
  
  .btn {
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    color: white;
    cursor: pointer;
    font-size: 14px;
  }
  
  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
  .btn.blue { background: #409eff; }
  .btn.green { background: #67c23a; }
  .btn.orange { background: #e6a23c; }
  .btn.red { background: #f56c6c; }
  .btn.gray { background: #909399; }
  
  .designer {
    min-height: 400px;
    border: 2px dashed #409eff;
    border-radius: 4px;
    margin-bottom: 20px;
    background: #fafafa;
  }
  
  .placeholder {
    height: 400px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #999;
    font-size: 16px;
  }
  
  .preview {
    background: #f5f7fa;
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 15px;
  }
  
  .preview pre {
    margin: 10px 0 0;
    padding: 10px;
    background: white;
    border-radius: 4px;
    overflow: auto;
    max-height: 150px;
  }
  </style>