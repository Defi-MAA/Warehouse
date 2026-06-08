<template>
    <ContentWrap>
        <el-splitter style="display: flex;" v-if="splitterReady">
            <el-splitter-panel collapsible :max="400" :size="250" style="background-color: #fff;width: 250px;">
                <el-scrollbar :height="(winHeight - 110) + 'px'" class="menuback">
                    <el-menu active-text-color="var(--left-menu-text-active-color)"
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
                                :index="'' + index + '-' + (subIndex + 1)"
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
                        <el-button type="danger" :icon="Printer" @click="print">打印</el-button>
                        <el-button type="primary" v-if="reportParams.length > 0" :icon="Search"
                            @click="serData">查询</el-button>
                        <el-button type="success" :icon="Document" @click="exportPDF">导出PDF</el-button>
                        <!-- <el-dropdown>
                            <el-button type="primary" :icon="Document" style="margin-left: 10px;">
                                导出<el-icon class="el-icon--right"><arrow-down /></el-icon>
                            </el-button>
                            <template #dropdown>
                                <el-dropdown-menu>
                                    <el-dropdown-item @click="exportPDF">导出PDF</el-dropdown-item>
                                    <el-dropdown-item>导出Excel</el-dropdown-item>
                                </el-dropdown-menu>
                            </template>
                        </el-dropdown> -->
                    </el-header>
                    <el-main style="padding: 0px;background-color: #fff;">
                        <el-scrollbar :height="(winHeight - 170) + 'px'">
                            <!-- 预览区域 -->
                            <div class="preview-section">

                                <div ref="previewContainer">
                                    <div v-if="!previewReady && !hasData" class="preview-placeholder">
                                        <div class="placeholder-icon">📄</div>
                                        <p>点击左边菜单，查看报表数据。</p>

                                    </div>
                                    <div v-else-if="previewLoading" class="preview-placeholder">
                                        <div class="loading-spinner"></div>
                                        <p>正在生成预览...</p>
                                    </div>
                                    <div v-else v-html="previewHtml"></div>
                                </div>
                            </div>
                        </el-scrollbar>
                    </el-main>
                </el-container>
            </el-splitter-panel>
        </el-splitter>
    </ContentWrap>

    <ConditionDialog ref="queryDialogRef" :list="reportParams" @confirm="confirmDlg" />



</template>

<script setup lang="ts">
import { ref, computed, nextTick, onMounted, watch } from 'vue'
import { hiprint } from 'vue-plugin-hiprint'
import { Notebook, Printer, Search, Document, ArrowDown } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import ConditionDialog from '@/views/dialog/condition.vue'

import request from '@/axios'
import { ElLoading } from 'element-plus'





const splitterReady = ref(false)
// DOM 引用
const previewContainer = ref(null)
const winHeight = ref(window.innerHeight)

const activeIndex = ref('')


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


onMounted(async () => {
    
    nextTick(() => {
        splitterReady.value = true
    })

    init()
    loadReport()
})
const reportData = ref<any[]>([])
const reportType = ref<any[]>([])
const reportParams = ref<any[]>([])

const loadReport = async () => {
    let res = await request.post({ url: '/api/report/getReport', data: {} })
    reportData.value = res.data
    res = await request.post({ url: '/api/report/getCategory', data: {category:0} })
    reportType.value = res.data
    activeIndex.value = reportType.value[0].name
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
                previewHtml.value = baseStyle +  html.html()
            } else if (html[0] && html[0].outerHTML) {
                previewHtml.value = baseStyle +  html[0].outerHTML
            } else {
                // 如果是普通对象，转为 JSON 字符串显示
                previewHtml.value = baseStyle + `<pre style="padding: 20px;">${JSON.stringify(html, null, 2)}</pre>`
            }
        } else {
            previewHtml.value = baseStyle +  String(html)
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
        let type = 'dataurlstring';
        // const loading = ElLoading.service({
        //     lock: true,
        //     text: '导出中',
        //     background: 'rgba(0, 0, 0, 0.7)',
        // })
        hiprintTemplate.value.toPdf(printData.value, '数据', { isDownload: true, type: type }).then((res) => {
            //loading.close()
            console.log('type:', type);
            console.log(res);
        });

    } catch (err: any) {
        ElMessage.error('导出PDF失败: ' + err.message)
    }
}

const queryDialogRef = ref(ConditionDialog)
const serData = async () => {
    queryDialogRef.value.dlgCondition = true
}
const confirmDlg = async (params: any) => {
    let paramsData = await getParams()
    await loadReportData(curCode.value, paramsData)
}
const curCode = ref('')
const loadReportData = async (code: string, params: any) => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }
        //hiprintTemplate.value.clear();
        let res = await request.post({ url: '/api/report/getBrpt', data: { Code: code } })
        //hiprintTemplate.value.update({})     
        nextTick(() => {
            loadTemplate(res.data.rptJson)
        })
        await getReportParams(code)
        await getReportData(code, params)
        preview()
        console.log('报告加载成功')
    } catch (err: any) {
        ElMessage.error('报告加载失败: ' + err.message)
    }
}
const showReport = async (item) => {
    curCode.value = item.code
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
const getReportData = async (code: string, params: any) => {
    try {
        let res = await request.post({ url: '/api/report/getReportData', data: { method: code, params: params } })
        let rptData: any = { ...params }
        Object.keys(res.data).forEach(key => {
            rptData[key] = res.data[key]
        });
        console.log(rptData)
        loadData(rptData)
    } catch (err: any) {
        ElMessage.error('报告数据加载失败: ' + err.message)
    }
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
    overflow: hidden;
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
</style>