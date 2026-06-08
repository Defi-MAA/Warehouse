<template>


    <el-container>
        <el-header style="border-bottom: 1px solid #e4e7ed;background-color: #fff;padding-top: 13px;">
            <el-button type="danger" :icon="Printer" @click="print">打印</el-button>
            <el-button type="primary" v-if="reportParams.length > 0" :icon="Search" @click="serData">查询</el-button>
            <el-button type="success" :icon="Document" @click="exportPDF">导出PDF</el-button>
            <!-- <el-dropdown>
                <el-button type="primary" :icon="Document" style="margin-left: 10px;">
                    导出<el-icon class="el-icon--right"><arrow-down /></el-icon>
                </el-button>
                <template #dropdown>
                    <el-dropdown-menu>
                        <el-dropdown-item @click="exportPDF">导出PDF</el-dropdown-item>
                        <el-dropdown-item @click="exportExcel">导出Excel</el-dropdown-item>
                    </el-dropdown-menu>
                </template>
            </el-dropdown> -->
        </el-header>
        <el-main style="padding: 0px;background-color: #fff;">
            <el-scrollbar :height="(winHeight - 270) + 'px'" >
                <!-- 预览区域 -->
                <div class="preview-section" ref="scrollableDivRef">

                    <div ref="previewContainer" >
                        <div v-if="!previewReady && !hasData" class="preview-placeholder">
                            <div class="placeholder-icon">📄</div>
                            <p>无数据。</p>

                        </div>
                        <div v-else-if="previewLoading" class="preview-placeholder">
                            <div class="loading-spinner"></div>
                            <p>正在生成预览...</p>
                        </div>
                        <div v-else  v-html="previewHtml" ></div>
                    </div>
                </div>
            </el-scrollbar>
        </el-main>
    </el-container>
    <ConditionDialog ref="queryDialogRef" :list="reportParams" @confirm="confirmDlg" />

</template>

<script setup lang="ts">
import { ref, computed, nextTick, onMounted,onUnmounted } from 'vue'
import { hiprint } from 'vue-plugin-hiprint'
import { Notebook, Printer, Search, Document, ArrowDown } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import ConditionDialog from '@/views/dialog/condition.vue'

import request from '@/axios'
import { ElLoading } from 'element-plus'

const scrollableDivRef = ref<HTMLDivElement | null>(null);

// 拖动状态
const isDragging = ref(false);
const startX = ref(0);
const scrollLeft = ref(0);
let dragTimer: ReturnType<typeof setTimeout> | null = null;

// 鼠标移动处理函数（具名，方便移除）
function onMouseMove(e: MouseEvent) {
  if (!isDragging.value || !scrollableDivRef.value) return;
  const dx = e.clientX - startX.value;
  scrollableDivRef.value.scrollLeft = scrollLeft.value - dx;
}

// 鼠标按下：记录位置并启动长按定时器
function onMouseDown(e: MouseEvent) {
  const div = scrollableDivRef.value;
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
    document.addEventListener('mousedown', onMouseDown);
    document.addEventListener('mouseup', onMouseUp);
    init()
})

onUnmounted(() => {
  // 组件卸载时彻底清理
  document.removeEventListener('mouseup', onMouseUp);
  document.removeEventListener('mousemove', onMouseMove);
  if (dragTimer) clearTimeout(dragTimer);
});

const reportParams = ref<any[]>([])



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
        const baseStyle = `
        <style>
         
          table {
            user-select: text;
          }
               </style>
      `

        // 方法1: 使用 getHtml 获取 HTML
        let html = hiprintTemplate.value.getHtml(printData.value)
        console.log('getHtml 返回值:', html)
        // console.log('getHtml 返回类型:', typeof html)
        // console.log('getHtml 返回内容前200字符:', String(html).substring(0, 200))

        // 处理不同类型的返回值
        if (typeof html === 'string') {
            // 已经是字符串，直接使用
            previewHtml.value = html
        } else if (html && typeof html === 'object') {
            // 如果是 jQuery 对象，提取 HTML
            if (html.html && typeof html.html === 'function') {
                previewHtml.value =baseStyle +  html.html()
            } else if (html[0] && html[0].outerHTML) {
                previewHtml.value =baseStyle +  html[0].outerHTML
            } else {
                // 如果是普通对象，转为 JSON 字符串显示
                previewHtml.value = baseStyle + `<pre style="padding: 20px;">${JSON.stringify(html, null, 2)}</pre>`
            }
        } else {
            previewHtml.value =baseStyle +  String(html)
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
        // hiprintTemplate.value.toPdf(printData.value, '打印预览pdf');
        // type ''Blob,'arraybuffer','dataurl','bloburl','dataurlstring','pdfobjectnewwindow',,
        let type = '';
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

        console.log('导出 PDF...')
        // type ''Blob,'arraybuffer','dataurl','bloburl','dataurlstring','pdfobjectnewwindow',,
        let type = 'dataurl';
        const loading = ElLoading.service({
            lock: true,
            text: '导出中',
            background: 'rgba(0, 0, 0, 0.7)',
        })
        hiprintTemplate.value.toPdf(printData.value, 'data', { isDownload: false, type: type }).then( async (res) => {
            loading.close()
            //console.log('type:', type);
            //console.log(res);
            let result =  await request.post({ url: '/api/convert/pdf-to-excel',data: {base64Pdf:res} ,responseType: 'blob'})
            //console.log(result);
            // 处理返回的 blob 数据
             downloadExcel(result.data, 'converted.xlsx')
        });


    } catch (err: any) {
        ElMessage.error('导出PDF失败: ' + err.message)
    }
}
// 下载 Excel 文件
const downloadExcel = (blob: Blob, fileName: string) => {
  // 创建 blob URL
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = fileName
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  // 释放 blob URL
  window.URL.revokeObjectURL(url)
}

const curCode = ref('')
const loadReportData = async (code: string, params: any) => {
    curCode.value = code
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

const queryDialogRef = ref(ConditionDialog)
const serData = async () => {
    queryDialogRef.value.dlgCondition = true
}
const confirmDlg = async (params: any) => {
    // let paramsData = {};
    // params.forEach(param => {
    //     paramsData[param.Code] = param.CValue
    // })
    let paramsData = await getParams()
    await getReportData(curCode.value, paramsData)
    preview()
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

// 暴露方法给父组件
defineExpose({
    loadReportData
});
//http://8.134.65.175:7879/
</script>

<style scoped>
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
     /* 确保背景完整包裹表格内容区 */
     background: inherit; 
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
    padding: 2px;
    border: 1px solid #e2e8f0;
}

:deep(.preview-content td) {
    padding: 2px 2px;
    border: 1px solid #e2e8f0;
}

</style>