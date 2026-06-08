<template>
  <div class="hiprint-demo">
    <h2>🖨️ vue-plugin-hiprint 完整示例 (带预览功能)</h2>
    
    <!-- 调试信息 -->
    <div class="debug-bar">
      <span>jQuery: {{ jQueryExists ? '✅' : '❌' }} v{{ jQueryVersion }}</span>
      <span>hiprint: {{ hiprintExists ? '✅' : '❌' }}</span>
      <span>模板: {{ hiprintTemplate ? '✅' : '❌' }}</span>
      <span>数据: {{ hasData ? '✅' : '❌' }}</span>
      <span>预览: {{ previewReady ? '✅' : '❌' }}</span>
    </div>

    <!-- 按钮组 -->
    <div class="buttons">
      <button @click="init" class="btn blue" :disabled="initializing">
        {{ initializing ? '初始化中...' : '1. 初始化' }}
      </button>
      <button @click="loadTemplate" class="btn green" :disabled="!hiprintTemplate">2. 加载模板</button>
      <button @click="loadData" class="btn orange" :disabled="!hiprintTemplate">3. 加载数据</button>
      <button @click="preview" class="btn purple" :disabled="!canPreview">👁️ 预览</button>
      <button @click="print" class="btn red" :disabled="!canPreview">🖨️ 打印</button>
      <button @click="exportPDF" class="btn gray" :disabled="!canPreview">📑 PDF</button>
    </div>

    <!-- 预览区域 -->
    <div class="preview-section">
      <div class="section-header">
        <span>📄 打印预览效果</span>
        <span v-if="previewReady" style="color: #67c23a; font-size: 12px;">✓ 已生成</span>
      </div>
      <div ref="previewContainer" class="preview-container">
        <div v-if="!previewReady && !hasData" class="preview-placeholder">
          <div class="placeholder-icon">📄</div>
          <p>点击「预览」按钮查看打印效果</p>
          <small>请先完成初始化、加载模板和数据</small>
        </div>
        <div v-else-if="previewLoading" class="preview-placeholder">
          <div class="loading-spinner"></div>
          <p>正在生成预览...</p>
        </div>
        <div v-else class="preview-content" v-html="previewHtml"></div>
      </div>
    </div>

    <!-- 数据面板 -->
    <div class="data-section">
      <div class="section-header">
        <span>📊 当前数据</span>
      </div>
      <div class="data-content">
        <pre v-if="hasData">{{ JSON.stringify(printData, null, 2) }}</pre>
        <div v-else class="data-placeholder">暂无数据，请点击「加载数据」</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, nextTick } from 'vue'
import { hiprint } from 'vue-plugin-hiprint'

// DOM 引用
const previewContainer = ref(null)

// 状态
const hiprintTemplate = ref(null)
const printData = ref({})
const previewHtml = ref('')
const initializing = ref(false)
const previewLoading = ref(false)

// 计算属性
const jQueryExists = computed(() => typeof window.jQuery !== 'undefined')
const jQueryVersion = computed(() => window.jQuery?.fn?.jquery || '未知')
const hiprintExists = computed(() => typeof hiprint !== 'undefined')
const hasData = computed(() => Object.keys(printData.value).length > 0)
const previewReady = computed(() => previewHtml.value !== '')
const canPreview = computed(() => hiprintTemplate.value && hasData.value)

// 简化模板 - 避免复杂元素
  
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
// 模拟数据
const mockData = {
  title: '销售出库单',
  orderNo: 'SO-20240321-001',
  date: '2024-03-21',
  customer: '深圳科技有限公司',
  remark: '请核对商品数量和金额，如有问题请及时联系',
  table: [
    { name: '华为 MateBook X Pro', qty: 2, price: '¥9,999.00' },
    { name: '罗技 MX Master 3S', qty: 3, price: '¥699.00' },
    { name: '小米 13 Ultra', qty: 1, price: '¥6,499.00' },
    { name: 'Anker 充电宝', qty: 5, price: '¥299.00' }
  ]
}

// 初始化
const init = async () => {
  initializing.value = true
  
  try {
    console.log('=== 开始初始化 ===')
    
    if (!jQueryExists.value) {
      throw new Error('jQuery 未加载')
    }
    console.log('jQuery 版本:', jQueryVersion.value)
    
    if (!hiprintExists.value) {
      throw new Error('hiprint 未加载')
    }
    
    // 初始化 hiprint
    if (hiprint.init) {
      hiprint.init()
      console.log('hiprint 初始化完成')
    }
    
    // 创建打印模板实例
    hiprintTemplate.value = new hiprint.PrintTemplate()
    console.log('模板实例创建成功')
    
    alert('✅ 初始化成功')
    
  } catch (err) {
    console.error('初始化失败:', err)
    alert('❌ 初始化失败: ' + err.message)
  } finally {
    initializing.value = false
  }
}

// 加载模板
const loadTemplate = () => {
  try {
    if (!hiprintTemplate.value) {
      alert('请先初始化')
      return
    }
    
    console.log('加载模板...')
    console.log('模板内容:', templateJson)
    
    hiprintTemplate.value.update(templateJson)
    
    // 清空预览
    previewHtml.value = ''
    
    console.log('模板加载成功')
    alert('✅ 模板加载成功')
    
  } catch (err) {
    console.error('加载模板失败:', err)
    alert('❌ 加载模板失败: ' + err.message)
  }
}

// 加载数据
const loadData = () => {
  printData.value = { ...mockData }
  console.log('数据加载成功:', printData.value)
  
  // 清空预览
  previewHtml.value = ''
  
  alert('✅ 数据加载成功')
}

// 预览功能
const preview = async () => {
  try {
    if (!hiprintTemplate.value) {
      alert('请先初始化')
      return
    }
    
    if (!hasData.value) {
      alert('请先加载数据')
      return
    }
    
    previewLoading.value = true
    
    await nextTick()
    
    console.log('生成预览...')
    console.log('数据:', printData.value)
    
    // 方法1: 使用 getHtml 获取 HTML
    let html = hiprintTemplate.value.getHtml(printData.value)
    
    console.log('getHtml 返回类型:', typeof html)
    console.log('getHtml 返回内容前200字符:', String(html).substring(0, 200))
    
    // 处理不同类型的返回值
    if (typeof html === 'string') {
      // 已经是字符串，直接使用
      previewHtml.value = html
    } else if (html && typeof html === 'object') {
      // 如果是 jQuery 对象，提取 HTML
      if (html.html && typeof html.html === 'function') {
        previewHtml.value = html.html()
      } else if (html[0] && html[0].outerHTML) {
        previewHtml.value = html[0].outerHTML
      } else {
        // 如果是普通对象，转为 JSON 字符串显示
        previewHtml.value = `<pre style="padding: 20px;">${JSON.stringify(html, null, 2)}</pre>`
      }
    } else {
      previewHtml.value = String(html)
    }
    
    // 添加基础样式
    const baseStyle = `
      <style>
        .hiprint-paper {
          background: white;
          padding: 30px;
          margin: 0 auto;
          box-shadow: 0 4px 12px rgba(0,0,0,0.1);
          border-radius: 4px;
          max-width: 800px;
        }
        table {
          border-collapse: collapse;
          width: 100%;
          margin: 15px 0;
        }
        th, td {
          border: 1px solid #ddd;
          padding: 10px;
          text-align: center;
        }
        th {
          background-color: #f5f5f5;
          font-weight: bold;
        }
        .hiprint-item {
          margin: 5px 0;
        }
      </style>
    `
    
    previewHtml.value = baseStyle + previewHtml.value
    
    console.log('预览生成成功')
    
    // 滚动到预览区域
    if (previewContainer.value) {
      previewContainer.value.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
    
  } catch (err) {
    console.error('预览失败:', err)
    console.error('错误堆栈:', err.stack)
    previewHtml.value = `<div style="color: red; padding: 20px; background: #fee; border-radius: 8px;">
      <strong>预览失败:</strong> ${err.message}<br>
      <small>请查看控制台获取详细信息</small>
    </div>`
    alert('❌ 预览失败: ' + err.message)
  } finally {
    previewLoading.value = false
  }
}

// 打印
const print = () => {
  try {
    if (!hiprintTemplate.value) {
      alert('请先初始化')
      return
    }
    
    if (!hasData.value) {
      alert('请先加载数据')
      return
    }
    
    console.log('开始打印...')
    hiprintTemplate.value.print(printData.value)
    
  } catch (err) {
    console.error('打印失败:', err)
    alert('打印失败: ' + err.message)
  }
}

// 导出PDF
const exportPDF = () => {
  try {
    if (!hiprintTemplate.value) {
      alert('请先初始化')
      return
    }
    
    if (!hasData.value) {
      alert('请先加载数据')
      return
    }
    
    console.log('导出 PDF...')
    hiprintTemplate.value.print(printData.value, {
      styleHandler: () => {
        return '<style>body { -webkit-print-color-adjust: exact; }</style>'
      }
    })
    
    alert('📑 请在打印对话框中选择「另存为 PDF」')
    
  } catch (err) {
    console.error('导出PDF失败:', err)
    alert('导出PDF失败: ' + err.message)
  }
}
</script>

<style scoped>
.hiprint-demo {
  max-width: 1200px;
  margin: 20px auto;
  padding: 24px;
  background: #f5f7fa;
  border-radius: 16px;
}

h2 {
  margin: 0 0 20px 0;
  color: #1f2f3d;
  font-size: 24px;
  padding-bottom: 12px;
  border-bottom: 3px solid #409eff;
  display: inline-block;
}

.debug-bar {
  display: flex;
  gap: 20px;
  padding: 12px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  margin-bottom: 24px;
  color: white;
  font-size: 13px;
  flex-wrap: wrap;
}

.buttons {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.btn {
  padding: 10px 24px;
  border: none;
  border-radius: 8px;
  color: white;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s;
}

.btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn.blue { background: #3b82f6; }
.btn.green { background: #10b981; }
.btn.orange { background: #f59e0b; }
.btn.purple { background: #8b5cf6; }
.btn.red { background: #ef4444; }
.btn.gray { background: #6b7280; }

.preview-section,
.data-section {
  background: white;
  border-radius: 12px;
  margin-bottom: 20px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
  font-weight: 600;
  color: #1e293b;
}

.preview-container {
  min-height: 500px;
  background: #f1f5f9;
  padding: 20px;
  overflow: auto;
}

.preview-placeholder {
  height: 460px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
}

.placeholder-icon {
  font-size: 64px;
  margin-bottom: 16px;
  opacity: 0.5;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #e2e8f0;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.preview-content {
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  min-height: 460px;
}

.data-content {
  padding: 20px;
}

.data-content pre {
  margin: 0;
  padding: 16px;
  background: #f8fafc;
  border-radius: 8px;
  overflow: auto;
  max-height: 250px;
  font-size: 13px;
  border: 1px solid #e2e8f0;
}

.data-placeholder {
  color: #94a3b8;
  text-align: center;
  padding: 40px;
}

/* 预览内容样式 */
:deep(.preview-content .hiprint-paper) {
  background: white;
  padding: 30px;
}

:deep(.preview-content table) {
  border-collapse: collapse;
  width: 100%;
  margin: 15px 0;
}

:deep(.preview-content th) {
  background: #f8fafc;
  font-weight: 600;
  padding: 12px;
  border: 1px solid #e2e8f0;
}

:deep(.preview-content td) {
  padding: 10px 12px;
  border: 1px solid #e2e8f0;
}
</style>