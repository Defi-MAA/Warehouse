<template>
    <ContentWrap>
        <el-splitter style="display: flex;" v-if="splitterReady">
            <el-splitter-panel collapsible :max="400" :size="250" style="background-color: #fff;width: 250px;">
                <el-scrollbar :height="(winHeight - 110) + 'px'" class="menuback">
                    <el-menu ref="menuRef" active-text-color="var(--left-menu-text-active-color)"
                        active-background-color="var(--left-menu-text-active-color)"
                        background-color="var(--left-menu-bg-color)" default-active="2"
                        text-color="var(--left-menu-text-color)">
                        <el-sub-menu :index="'' + (index + 1)" v-for="(item, index) in reportType">
                            <template #title>
                                <el-icon>
                                    <Notebook />
                                </el-icon>
                                <span>{{ item.name }}</span>
                            </template>

                            <el-menu-item @click="showReport(subItem)"
                                v-for="(subItem, subIndex) in reportData.filter(o => o.category === item.name)"
                                :index="'' + (index + 1) + '-' + (subIndex + 1)"
                                active-background-color="var(--left-menu-text-active-color)"
                                text-color="var(--left-menu-text-color)">
                                <span>{{ subItem.name }}</span>
                            </el-menu-item>
                        </el-sub-menu>
                    </el-menu>
                </el-scrollbar>
            </el-splitter-panel>
            <el-splitter-panel style="width: calc(100% - 250px);">
                <el-container>
                    <el-header style="border-bottom: 1px solid #e4e7ed;background-color: #fff;padding-top: 13px;">
                        <el-button type="primary" v-if="reportParams.length > 0" :icon="Search"
                            @click="serData">查询</el-button>
                        <el-button type="danger" :icon="Printer" @click="print">打印</el-button>


                        <el-dropdown>
                            <el-button type="primary" :icon="Document" style="margin-left: 10px;">
                                导出<el-icon class="el-icon--right"><arrow-down /></el-icon>
                            </el-button>
                            <template #dropdown>
                                <el-dropdown-menu>
                                    <el-dropdown-item @click="exportPDF">导出PDF</el-dropdown-item>
                                    <el-dropdown-item @click="exportExcel" v-if="!isChart">导出Excel</el-dropdown-item>
                                </el-dropdown-menu>
                            </template>
                        </el-dropdown>
                    </el-header>
                    <el-main style="padding: 0px;background-color: #fff;">
                        <el-scrollbar :height="(winHeight - 170) + 'px'">
                            <!-- 预览区域 -->
                            <div class="preview-section" ref="scrollableDivmRef">

                                <div ref="previewContainer">
                                    <div v-if="!previewReady && !hasData" class="preview-placeholder">
                                        <div class="placeholder-icon">📄</div>
                                        <p>点击左边菜单，查看报表数据。</p>

                                    </div>
                                    <div v-else-if="previewLoading" class="preview-placeholder">
                                        <div class="loading-spinner"></div>
                                        <p>正在生成预览...</p>
                                    </div>
                                    <div  v-else v-html="previewHtml" id="previewTable"  @click="handleClick"></div>
                                </div>
                            </div>
                        </el-scrollbar>
                    </el-main>
                </el-container>
            </el-splitter-panel>
        </el-splitter>
    </ContentWrap>

    <ConditionDialog ref="queryDialogRef" :list.sync="reportParams" @confirm="confirmDlg" />
    <Dialog v-model="dlgReport" width="65%" maxHeight="500px" :title="rptTitle">
        <Report1 ref="myrpt0"></Report1>
    </Dialog>
    <div ref="chartRef" v-show="false" style="width: 600px; height: 400px;"></div>

</template>

<script setup lang="ts">
import { ref, computed, nextTick, onMounted, onUnmounted, watch } from 'vue'
import { hiprint } from 'vue-plugin-hiprint'
import * as echarts from 'echarts'
import { Notebook, Printer, Search, Document, ArrowDown } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import ConditionDialog from '@/views/dialog/condition.vue'

import Report1 from '@/views/dialog/report.vue'
import { Dialog } from '@/components/Dialog'

import request from '@/axios'
import { ElLoading } from 'element-plus'
import { isEmpty } from 'lodash-es'


const dlgReport = ref(false)
const handleClick = (e: MouseEvent) => {
    const target = e.target as HTMLAnchorElement
    // 判断点击的是不是a标签
    if (target.tagName === 'A') {
        // 阻止a默认跳转/锚点滚动
        e.preventDefault()
        const raw = target.dataset.id
        if (!isEmpty(raw)) {
            const json = decodeURIComponent(raw)
            console.log(json)
            const params = JSON.parse(json)
            if (params != null) {
                viewReport(params)
            }
        }
    }
}
const myrpt0 = ref<InstanceType<typeof Report1> | null>(null)
const rptTitle = ref('')
const viewReport = (params) => {

    dlgReport.value = true
    rptTitle.value = "报表"
    nextTick(async () => {
        if (myrpt0.value) {
            await myrpt0.value.loadReportData(
                params.rptcode,
                params
            )
        }
    })
}


const splitterReady = ref(false)
// DOM 引用
const previewContainer = ref(null)
const winHeight = ref(window.innerHeight)




// 状态
const hiprintTemplate = ref(null)
const printData = ref({})
const previewHtml = ref('')
const initializing = ref(false)
const previewLoading = ref(false)

// 计算属性

const hiprintExists = computed(() => typeof hiprint !== 'undefined')
const hasData = computed(() => Object.keys(printData.value).length > 0)
const previewReady = computed(() => previewHtml.value !== '')
const canPreview = computed(() => hiprintTemplate.value && hasData.value)

// 辅助函数：将 URL 查询字符串转换为对象
function param2Obj(url: string): Record<string, string> | null {
    const search = url.split('?')[1];
    if (!search) return null;
    const params: Record<string, string> = {};
    search.split('&').forEach(part => {
        const [key, val] = part.split('=');
        if (key) {
            params[decodeURIComponent(key)] = val ? decodeURIComponent(val) : '';
        }
    });
    return params;
}
// 定义外层 that 对象的类型（根据实际使用的方法和属性）
interface ThatContext {
    accid: string | number;
    openBill: () => void;
    openContract: (obj: Record<string, string>) => void;
    openArcBill: (obj: Record<string, string>) => void;
}

// 假设 that 已经在外部定义，此处仅用作类型声明
declare const that: ThatContext;
// popstate 事件处理函数（TypeScript 版本）
window.onpopstate = function (event: PopStateEvent): void {
    console.log(event)
    const obj = param2Obj(window.location.href);
    console.log(obj)
    if (obj != null) {
        const opentype = obj.opentype;
        if (!isEmpty(opentype)) {
            if (opentype === 'bill') {
                that.accid = obj.accid;
                if (that.accid === '0') return;
                that.openBill();
            }

            if (opentype === 'contract') {
                that.openContract(obj);
            } else if (opentype === 'arcbill') {
                that.openArcBill(obj);
            } else if (opentype === 'report') {
                const href = window.location.href;
                // 原代码中的 search 变量未使用，保留仅用于保持一致性
                const search = decodeURIComponent(href.split('?')[1]).replace(/\+/g, ' ');
                window.open(href, '_blank');
            }
        }
    }
};


const scrollableDivmRef = ref<HTMLDivElement | null>(null);

// 拖动状态
const isDragging = ref(false);
const startX = ref(0);
const scrollLeft = ref(0);
let dragTimer: ReturnType<typeof setTimeout> | null = null;

// 鼠标移动处理函数（具名，方便移除）
function onMouseMove(e: MouseEvent) {
    if (!isDragging.value || !scrollableDivmRef.value) return;
    const dx = e.clientX - startX.value;
    scrollableDivmRef.value.scrollLeft = scrollLeft.value - dx;
}

// 鼠标按下：记录位置并启动长按定时器
function onMouseDown(e: MouseEvent) {
    const div = scrollableDivmRef.value;
    if (!div) return;

    startX.value = e.clientX;
    scrollLeft.value = div.scrollLeft;
    isDragging.value = true;

    // 清除可能存在的旧定时器，防止重复触发
    if (dragTimer) clearTimeout(dragTimer);

    dragTimer = setTimeout(() => {
        if (isDragging.value) {
            document.addEventListener('mousemove', onMouseMove);
        }
    }, 500);
}

// 鼠标松开：结束拖动并清理
function onMouseUp() {
    isDragging.value = false;

    if (dragTimer) {
        clearTimeout(dragTimer);
        dragTimer = null;
    }

    document.removeEventListener('mousemove', onMouseMove);
}



onMounted(async () => {
    document.addEventListener('mousedown', onMouseDown);
    document.addEventListener('mouseup', onMouseUp);
    nextTick(() => {
        splitterReady.value = true
    })

    init()
    loadReport()
})
onUnmounted(() => {
    // 组件卸载时彻底清理
    document.removeEventListener('mouseup', onMouseUp);
    document.removeEventListener('mousemove', onMouseMove);
    if (dragTimer) clearTimeout(dragTimer);
});

const reportData = ref<any[]>([])
const reportType = ref<any[]>([])
const reportParams = ref<any[]>([])
const menuRef = ref<any>(null)

const loadReport = async () => {
    let res = await request.post({ url: '/api/report/getReport', data: {} })
    reportData.value = res.data
    res = await request.post({ url: '/api/report/getCategory', data: { category: 0 } })
    reportType.value = res.data
    if (reportType.value.length > 0) {
        nextTick(() => {
            menuRef.value?.updateActiveIndex('1')
        })
    }

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



    } catch (err: any) {
        console.error('初始化失败:', err)
        ElMessage.error('❌ 初始化失败: ' + err.message)
    } finally {
        initializing.value = false
    }
}

// 加载模板
const loadTemplate = (templateJson) => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }

        // console.log('加载模板...')
        //console.log('模板内容:', templateJson)


        // hiprintTemplate.value.update(JSON.parse(templateJson)) //不生效 改成new hiprint.PrintTemplate
        hiprintTemplate.value = new hiprint.PrintTemplate({
            template: JSON.parse(templateJson) // 新的模板配置对象
        });

        // 清空预览
        previewHtml.value = ''

        console.log('模板加载成功')

    } catch (err: any) {
        console.error('加载模板失败:', err)
        ElMessage.error('❌ 加载模板失败: ' + err.message)
    }
}

// 加载数据
const loadData = (mockData) => {
    printData.value = { ...mockData }
    console.log('数据加载成功:', printData.value)
    // 清空预览
    previewHtml.value = ''

}

// 预览功能
const preview = async () => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage('请先初始化')
            return
        }

        if (!hasData.value) {
            ElMessage.error('请先加载数据')
            return
        }

        previewLoading.value = true

        await nextTick()

        console.log('生成预览...')
        console.log('数据:', printData.value)

        // 方法1: 使用 getHtml 获取 HTML
        let html = hiprintTemplate.value.getHtml(printData.value)

        // console.log('getHtml 返回类型:', typeof html)
        // console.log('getHtml 返回内容前200字符:', String(html).substring(0, 200))

        const baseStyle = `
        <style>
         
          table {
            user-select: text;
          }
               </style>
      `

        // 处理不同类型的返回值
        if (typeof html === 'string') {
            // 已经是字符串，直接使用
            previewHtml.value = html
        } else if (html && typeof html === 'object') {
            // 如果是 jQuery 对象，提取 HTML
            if (html.html && typeof html.html === 'function') {
                previewHtml.value = baseStyle + html.html()
            } else if (html[0] && html[0].outerHTML) {
                previewHtml.value = baseStyle + html[0].outerHTML
            } else {
                // 如果是普通对象，转为 JSON 字符串显示
                previewHtml.value = baseStyle + `<pre style="padding: 20px;">${JSON.stringify(html, null, 2)}</pre>`
            }
        } else {
            previewHtml.value = baseStyle + String(html)
        }

    } catch (err: any) {
        previewHtml.value = `<div style="color: red; padding: 20px; background: #fee; border-radius: 8px;">
        <strong>预览失败:</strong> ${err.message}<br>
        <small>请查看控制台获取详细信息</small>
      </div>`
        ElMessage.error('❌ 预览失败: ' + err.message)
    } finally {
        previewLoading.value = false
    }
}

// 打印
const print = () => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }

        if (!hasData.value) {
            ElMessage.error('请先加载数据')
            return
        }

        console.log('开始打印...')
        hiprintTemplate.value.print(printData.value)

    } catch (err) {
        console.error('打印失败:', err)
    }
}

// 导出PDF
const exportPDF = () => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }

        if (!hasData.value) {
            ElMessage.error('请先加载数据')
            return
        }

        console.log('导出 PDF...')

        //type ''Blob,'arraybuffer','dataurl','bloburl','dataurlstring','pdfobjectnewwindow',,
        let type = 'dataurlstring';
        // const loading = ElLoading.service({
        //     lock: true,
        //     text: '导出中',
        //     background: 'rgba(0, 0, 0, 0.7)',
        // })
        hiprintTemplate.value.toPdf(printData.value, curName.value, { isDownload: true, type: type }).then((res) => {
            //loading.close()
            console.log('type:', type);
            console.log(res);
        });

    } catch (err: any) {
        ElMessage.error('导出PDF失败: ' + err.message)
    }
}

// 导出Excel
const exportExcel = () => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }

        if (!hasData.value) {
            ElMessage.error('请先加载数据')
            return
        }

        const table = document.getElementById("previewTable") as HTMLElement
        htmlTableToExcel(table, curName.value)

    } catch (err: any) {
        ElMessage.error('导出Excel失败: ' + err.message)
    }
}

import * as XLSX from 'xlsx'

/**
 * html table 导出Excel
 * @param tableDom 表格DOM对象
 * @param fileName 文件名
 */
const htmlTableToExcel = (tableDom: HTMLElement, fileName = "报表") => {
    // 转换table为工作表
    const workbook = XLSX.utils.table_to_book(tableDom, { sheet: "Sheet1" })
    // 导出文件
    XLSX.writeFile(workbook, `${fileName}.xlsx`)
}





const queryDialogRef = ref(ConditionDialog)
const serData = async () => {
    queryDialogRef.value.dlgCondition = true
}
const confirmDlg = async () => {
    let paramsData = await getParams()
    await loadReportData(curCode.value, paramsData)
}
const curCode = ref('')
const curName = ref('')
const originTemplate = ref('')
const loadReportData = async (code: string, params: any) => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }
        //hiprintTemplate.value.clear();
        let res = await request.post({ url: '/api/report/getBrpt', data: { Code: code } })
        //hiprintTemplate.value.update({})     
        originTemplate.value = res.data.rptJson
        nextTick(() => {
            loadTemplate(res.data.rptJson)
        })
        await getReportData(code, params)
        console.log('报告加载成功')
    } catch (err: any) {
        ElMessage.error('报告加载失败: ' + err.message)
    }
}
const showReport = async (item) => {
    curCode.value = item.code
    curName.value = item.name
    await getReportParams(item.code)
    await loadReportData(item.code, {})
}

const getReportParams = async (code) => {
    try {
        let res = await request.post({ url: '/api/report/getRportParams', data: { code: code } })
        reportParams.value = res.data
    } catch (err: any) {
        ElMessage.error('报表类型加载失败: ' + err.message)
    }
}

const getParams = async () => {
    let params = {};
    reportParams.value.forEach(param => {
        params[param.Code] = param.CValue
    })
    return params
}
const isChart = ref(false)
const getReportData = async (code: string, params: any) => {
    try {
        let res = await request.post({ url: '/api/report/getReportData', data: { method: code, params: params } })
        let rptData: any = { ...params }

        Object.keys(res.data).forEach(key => {
            rptData[key] = res.data[key]
        });

        console.log(rptData)
        isChart.value = false;
        if (rptData.CrossReport) {
            // 交叉表
            crossReport(rptData, rptData.CrossRows, rptData.CrossColumns, rptData.CrossMeasures, rptData.CrossMeaNames, rptData.ColWidth)
            preview()
        }
        else if (rptData.ChartReport) {
            isChart.value = true;
            // 图表
            initChart(rptData);
            setTimeout(() => {
                const imgBase64 = chartIns.getDataURL({
                    pixelRatio: 3,
                    backgroundColor: '#fff'
                })
                // 传给hiprint模板数据
                const printData = {
                    lineImg: imgBase64
                }
                loadData(printData)
                preview()
            }, 300);


        }
        else {
            loadData(rptData)
            preview()
        }

    } catch (err: any) {
        ElMessage.error('报告数据加载失败: ' + err.message)
    }
}








/** 表格单列配置 */
interface TableColumnOption {
    width: string | number
    title: string
    field: string
    checked: boolean
    columnId: string
    fixed: boolean
    rowspan: number
    colspan: number
    align: string
}

/** table 元素 options */
interface TablePrintOptions {
    left: number
    top: number
    height: number
    width: number
    right: number
    bottom: number
    vCenter: number
    hCenter: number
    field: string
    coordinateSync: boolean
    widthHeightSync: boolean
    columns: TableColumnOption[][]
    css?: string
}

/** 打印元素基础结构 */
interface PrintElement {
    options: Record<string, any>
    printElementType: {
        type: 'text' | 'table' | 'hline'
        title?: string
        [key: string]: any
    }
}

/** 打印面板 */
interface PanelItem {
    index: number
    name: string
    height: number
    width: number
    paperHeader: number
    paperFooter: number
    printElements: PrintElement[]
    paperNumberLeft: number
    paperNumberTop: number
    paperNumberContinue: boolean
    watermarkOptions: Record<string, any>
    panelLayoutOptions: Record<string, any>
}

/** 完整打印模板JSON */
interface PrintTemplateJSON {
    panels: PanelItem[]
}



// ========== 类型定义 ==========
interface SourceItem {
    [key: string]: any;
}

interface PivotConfig {
    rows: string[];          // 行维度字段列表（如 ['region', 'city', 'product']）
    columns: string[];       // 列维度字段列表（如 ['year', 'quarter']）
    measures: string[];      // 数值字段列表（如 ['sales', 'profit']）
    aggregator?: (values: number[]) => number; // 聚合函数，默认求和
    showGrandTotal?: boolean; // 是否显示总计行
}

interface CrossRow {
    [key: string]: any;
}

interface PivotResult {
    colHeaders: string[];
    crossRows: CrossRow[];
}

// ========== 工具函数 ==========
// 默认求和聚合
function sum(values: number[]): number {
    return values.reduce((a, b) => a + b, 0);
}

// 获取所有列组合（去重），返回字符串键数组（用 '||' 拼接）
function getUniqueCombinations(list: SourceItem[], colFields: string[]): string[] {
    const set = new Set<string>();
    list.forEach(item => {
        const key = colFields.map(f => String(item[f] ?? '')).join('||');
        set.add(key);
    });
    return Array.from(set);
}



// 格式化列头（将组合键转换为可读字符串）
function formatColHeader(comboKey: string, colFields: string[]): string {
    const parts = comboKey.split('||');
    return parts.join('-'); // 例如 ['2024','Q1'] → '2024-Q1'
}

// ========== 核心透视函数 ==========
function getPivotData(
    list: SourceItem[],
    config: PivotConfig
): PivotResult {
    const {
        rows,
        columns,
        measures,
        aggregator = sum,
        showGrandTotal = true
    } = config;

    // 1. 提取所有列组合（扁平化）
    const colCombos = getUniqueCombinations(list, columns);
    const colHeaders = colCombos.map(combo => formatColHeader(combo, columns));

    // 2. 按行维度分组
    const rowGroups = new Map<string, CrossRow>();

    list.forEach(item => {
        // 行键：由 rows 字段值拼接
        const rowKey = rows.map(f => String(item[f] ?? '')).join('||');
        // 列键：由 columns 字段值拼接
        const colKey = columns.map(f => String(item[f] ?? '')).join('||');

        if (!rowGroups.has(rowKey)) {
            // 初始化行，包含所有行维度字段
            const initRow: CrossRow = {};
            rows.forEach(f => initRow[f] = item[f]);
            // 初始化所有指标 × 所有列组合为 0
            measures.forEach(measure => {
                colHeaders.forEach(col => {
                    initRow[`${measure}_${col}`] = 0;
                });
            });
            rowGroups.set(rowKey, initRow);
        }

        const targetRow = rowGroups.get(rowKey)!;
        // 对每个指标累加（按列组合定位）
        measures.forEach(measure => {
            const val = Number(item[measure]) || 0;
            // 找到当前行数据对应的列索引（根据 colKey）
            const colIndex = colCombos.indexOf(colKey);
            if (colIndex === -1) return; // 理论上不会发生
            const colHeader = colHeaders[colIndex];
            const key = `${measure}_${colHeader}`;
            targetRow[key] = (targetRow[key] || 0) + val;
        });
    });

    const crossRows = Array.from(rowGroups.values());

    // 3. 总计行（可选）
    if (showGrandTotal) {
        const totalRow: CrossRow = {};
        //rows.forEach(f => totalRow[f] = '合计');
        rows.forEach((f, index) => {
            totalRow[f] = index === 0 ? '合计' : '';
        });
        measures.forEach(measure => {
            colHeaders.forEach(col => {
                const key = `${measure}_${col}`;
                let total = 0;
                crossRows.forEach(r => total += Number(r[key] || 0));
                totalRow[key] = total;
            });
        });
        crossRows.push(totalRow);
    }

    return { colHeaders, crossRows };
}

// ===================== 动态替换表格列配置 =====================
function resetTableColumns(
    colHeaders: string[],
    CrossMeasures: string[],
    CrossMeaNames: string[],
    colWidth: number
): PrintTemplateJSON {
    const newTpl = JSON.parse(originTemplate.value) as PrintTemplateJSON
    const panel = newTpl.panels[0]

    const tableEl = panel.printElements.find(el => el.printElementType.type === "table")
    if (!tableEl) return newTpl

    const tableOpts = tableEl.options as TablePrintOptions
    //const totalColCount = 1 + colHeaders.length
    //const singleColWidth = tableTotalWidth / totalColCount
    tableOpts.width = 800.5
    const newColumns: TableColumnOption[] = tableEl.options.columns[0]

    // 动态生成所有维度列
    colHeaders.forEach(col => {
        CrossMeasures.forEach(measure => {
            newColumns.push({
                width: colWidth,
                title: col + CrossMeaNames[CrossMeasures.indexOf(measure)],
                field: measure + `_${col}`,
                checked: true,
                columnId: col,
                fixed: false,
                rowspan: 1,
                colspan: 1,
                align: "right"
            })
        })
    })

    tableOpts.columns[0] = newColumns
    tableOpts.field = "data0"
    // 合计行样式
    tableOpts.css = `
    tr:last-child td {
      background:#eee;
      font-weight:bold;
    }
  `

    return newTpl
}


// 定义数据类型，替换 any
interface ChartRow {
    [key: string]: string | number;
}
interface PrintData {
    data0: ChartRow[];
    legendName: string;
    xAxisName: string;
    ChartType: 'bar' | 'line';
    ChartValue: string;
}

// 外部变量建议ref存放，这里仅示例
let chartIns: echarts.ECharts | null = null;
const chartRef = ref(null);

const initChart = (printData: PrintData) => {
    // 1. 前置校验，防止字段为空报错
    if (!printData?.data0?.length || !chartRef.value) return;
    const list: ChartRow[] = printData.data0;
    const { legendName, xAxisName, ChartType, ChartValue } = printData;

    // 2. 销毁旧图表实例，避免重复初始化
    if (chartIns) {
        chartIns.dispose();
        chartIns = null;
    }
    chartIns = echarts.init(chartRef.value);

    // 3. 有序去重（保留原始出现顺序，解决坐标轴错位）
    const getDistinctArr = <T>(arr: T[]) => {
        const set = new Set<T>();
        return arr.filter(item => {
            if (set.has(item)) return false;
            set.add(item);
            return true;
        });
    };
    const rawLegend = list.map(item => item[legendName] as string);
    const rawXAxis = list.map(item => item[xAxisName] as string);
    const legendData = getDistinctArr(rawLegend);
    const xAxisData = getDistinctArr(rawXAxis);

    // 4. 构建映射表，优化查询性能，避免双层findIndex
    const dataMap = new Map<string, number>();
    list.forEach(item => {
        const key = `${item[xAxisName]}|${item[legendName]}`;
        dataMap.set(key, Number(item[ChartValue]) || 0);
    });

    // 5. 组装series，无数据填充0，保证数组长度和xAxis完全匹配
    const seriesData = legendData.map(legend => {
        const data = xAxisData.map(x => {
            const key = `${x}|${legend}`;
            return dataMap.get(key) ?? 0; // 无数据补0，不会缺项
        });
        return {
            name: legend,
            barWidth: 28,
            type: ChartType,
            // 柱子顶部文字
            label: {
                show: true,        // 开启显示数值
                position: 'top',   // 位置：top顶部 / inside内部 / bottom底部
                fontSize: 10, // 不小于12
                color: '#000000', // 纯黑，杜绝浅灰
                fontWeight: 'bold', // 加粗，提升对比度
                textShadowColor: '#fff', // 加白色描边/阴影，隔绝柱子底色
                textShadowBlur: 2,
                textShadowOffsetX: 0,
                textShadowOffsetY: 0,
                formatter: '{c}'   // {c} = 当前数值，可自定义拼接文字
            },
            data
        };
    });

    console.log(seriesData)

    // 6. 完整option，补充tooltip、自适应
    const option = {
        tooltip: { trigger: 'axis' }, // 悬浮提示必备
        legend: { data: legendData },
        xAxis: {
            type: 'category',
            data: xAxisData
        },
        yAxis: { type: 'value' },
        series: seriesData
    };
    chartIns.setOption(option);

    // 窗口大小自适应
    //const resizeHandler = () => chartIns?.resize();
    //window.addEventListener('resize', resizeHandler);
    // 组件销毁时移除监听（补充在onUnmounted）
};




// ===================== （仅需修改入参适配不同业务字段） =====================
const crossReport = (sourceData: any, crossRows: string, crossColumns: string, crossMeasures: string, crossMeaNames: string, colWidth: number) => {

    const config: PivotConfig = {
        rows: crossRows.split(','),   // 三级行维度
        columns: crossColumns.split(','),          // 两级列维度
        measures: crossMeasures.split(','),         // 两个指标
        showGrandTotal: true
    };

    const result = getPivotData(sourceData.data0, config);
    // 更新模板列
    const newTemplate = resetTableColumns(result.colHeaders, crossMeasures.split(','), crossMeaNames.split(','), colWidth)
   
    
    loadTemplate(JSON.stringify(newTemplate))
    sourceData.data0 = result.crossRows
    loadData(sourceData)
}

</script>


<style lang="less" scoped>
.menuback {
    background-color: var(--left-menu-bg-color, #f0f0f0);
}


.preview-section,
.data-section {
    background: white;
    border-radius: 12px;
    margin-bottom: 20px;
    overflow-x: scroll;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
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
    to {
        transform: rotate(360deg);
    }
}

.preview-content {
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

:deep .el-menu .el-menu-item.is-active {
    color: var(--left-menu-text-active-color) !important;
    background-color: var(--left-menu-bg-active-color) !important;
}
</style>