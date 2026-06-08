<template>
    <ContentWrap>
        <el-splitter>
            <el-splitter-panel collapsible :max="400" :size="250" style="background-color: #fff;">
                <el-scrollbar :height="(winHeight - 110) + 'px'">
                    <el-menu class="el-menu-vertical-demo" active-text-color="#409EFF" background-color="#001529"
                        default-active="2" text-color="#fff">
                        <el-sub-menu :index="'' + (index + 1)" v-for="(item, index) in reportType">
                            <template #title>
                                <el-icon>
                                    <Notebook />
                                </el-icon>
                                <span>{{ item.name }}</span>
                            </template>

                            <el-menu-item @click="loadReportData(subItem)"
                                v-for="(subItem, subIndex) in reportData.filter(o => o.category === item.name)"
                                :index="'' + index + '-' + (subIndex + 1)" active-background-color="#409EFF">
                                <span>{{ subItem.name }}</span>
                            </el-menu-item>
                        </el-sub-menu>
                    </el-menu>
                </el-scrollbar>
            </el-splitter-panel>
            <el-splitter-panel>
                <el-container>
                    <el-header style="border-bottom: 1px solid #e4e7ed;background-color: #fff;padding-top: 13px;">
                        <el-button type="danger" :icon="Printer" @click="print">打印</el-button>
                        <el-button type="primary" :icon="Search" @click="preview">查询</el-button>
                        <el-dropdown>
                            <el-button type="primary" :icon="Document" style="margin-left: 10px;">
                                导出<el-icon class="el-icon--right"><arrow-down /></el-icon>
                            </el-button>
                            <template #dropdown>
                                <el-dropdown-menu>
                                    <el-dropdown-item @click="exportPDF">导出PDF</el-dropdown-item>
                                    <el-dropdown-item>导出Excel</el-dropdown-item>
                                </el-dropdown-menu>
                            </template>
                        </el-dropdown>
                    </el-header>
                    <el-main style="padding: 0px;background-color: #fff;">
                        <el-scrollbar :height="(winHeight - 170) + 'px'">
                            <!-- 预览区域 -->
                            <div class="preview-section">

                                <div ref="previewContainer" class="preview-container">
                                    <div v-if="!previewReady && !hasData" class="preview-placeholder">
                                        <div class="placeholder-icon">📄</div>
                                        <p>点击左边菜单，查看报表数据。</p>

                                    </div>
                                    <div v-else-if="previewLoading" class="preview-placeholder">
                                        <div class="loading-spinner"></div>
                                        <p>正在生成预览...</p>
                                    </div>
                                    <div v-else class="preview-content" v-html="previewHtml"></div>
                                </div>
                            </div>
                        </el-scrollbar>
                    </el-main>
                </el-container>
            </el-splitter-panel>
        </el-splitter>
    </ContentWrap>

</template>

<script setup lang="ts">
import { ref, computed, nextTick, onMounted } from 'vue'
import { hiprint } from 'vue-plugin-hiprint'
import { Notebook, Printer, Search, Document, ArrowDown } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

import request from '@/axios'
import { ElLoading } from 'element-plus'


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
const jQueryExists = computed(() => typeof window.jQuery !== 'undefined')
const jQueryVersion = computed(() => window.jQuery?.fn?.jquery || '未知')
const hiprintExists = computed(() => typeof hiprint !== 'undefined')
const hasData = computed(() => Object.keys(printData.value).length > 0)
const previewReady = computed(() => previewHtml.value !== '')
const canPreview = computed(() => hiprintTemplate.value && hasData.value)


onMounted(async () => {
    init()
    //loadTemplate('')
    //loadData({})
    //preview()
    loadReport()
})
const reportData = ref<any[]>([])
const reportType = ref<any[]>([])
const reportParams = ref<any[]>([])

const loadReport = async () => {
    let res = await request.post({ url: '/api/report/getReport', data: {} })
    reportData.value = res.data
    res = await request.post({ url: '/api/report/getCategory', data: {} })
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
          
        .hiprint-printPaper {
        border-bottom: 5px solid #eee;
        }

        </style>
      `

        previewHtml.value = baseStyle + previewHtml.value

        // console.log( previewHtml.value)
        //console.log('预览生成成功')

        // 滚动到预览区域
        // if (previewContainer.value) {
        //     previewContainer.value.scrollIntoView({ behavior: 'smooth', block: 'start' })
        // }

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
        // hiprintTemplate.value.toPdf(printData.value, '打印预览pdf');
        // type ''Blob,'arraybuffer','dataurl','bloburl','dataurlstring','pdfobjectnewwindow',,
        let type = 'dataurlstring';
        const loading = ElLoading.service({
            lock: true,
            text: '导出中',
            background: 'rgba(0, 0, 0, 0.7)',
        })
        hiprintTemplate.value.toPdf(printData.value, '测试导出pdf', { isDownload: false, type: type }).then((res) => {
            loading.close()
            console.log('type:', type);
            console.log(res);
        });


    } catch (err: any) {
        ElMessage.error('导出PDF失败: ' + err.message)
    }
}

const loadReportData = async (item) => {
    try {
        if (!hiprintTemplate.value) {
            ElMessage.error('请先初始化')
            return
        }
        //hiprintTemplate.value.clear();
        let res = await request.post({ url: '/api/report/getBrpt', data: { Code: item.code } })
        //hiprintTemplate.value.update({})     
        nextTick(() => {
            loadTemplate(res.data.rptJson)
        })
        await getReportParams(item.code)
        await getReportData(item)
        preview()
        console.log('报告加载成功')
    } catch (err: any) {
        ElMessage.error('报告加载失败: ' + err.message)
    }
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
const getReportData = async (item) => {
    try {
        let params = await getParams();
        let res = await request.post({ url: '/api/report/getReportData', data: { method: item.code, params: params } })
        let rptData: any = { ...params };
        rptData.table = res.data;
        console.log(888888)
        console.log(rptData)
        loadData(rptData)
    } catch (err: any) {
        ElMessage.error('报告数据加载失败: ' + err.message)
    }
}

</script>

<style scoped>
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