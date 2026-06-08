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

                    <el-main style="padding: 0px;background-color: #fff;">

                        <div  :height="(winHeight - 100) + 'px'"
                            style="height: 100%;width: 100%;">
                            <iframe v-if="reportUrl" :src="reportUrl" width="100%" :height="(winHeight - 100) + 'px'"
                                frameborder="0" style="padding: 5px;"></iframe>
                            <div v-else class="preview-placeholder" :style="{height: (winHeight - 100) + 'px'}">
                                <div class="placeholder-icon">📄</div>
                                <p>点击左边菜单，查看报表数据。</p>

                            </div>

                        </div>
                    </el-main>
                </el-container>
            </el-splitter-panel>
        </el-splitter>
    </ContentWrap>

</template>

<script setup lang="ts">
import { ref, computed, nextTick, onMounted } from 'vue'
import { Notebook, Printer, Search, Document, ArrowDown } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

import request from '@/axios'
import { useUserStoreWithOut } from '@/store/modules/user'
import { ElLoading } from 'element-plus'

const winHeight = ref(window.innerHeight)
const activeIndex = ref('')
const reportUrl = ref('')

onMounted(async () => {
    loadReport()
})
const reportData = ref<any[]>([])
const reportType = ref<any[]>([])

const loadReport = async () => {
    let res = await request.post({ url: '/api/report/getReport', data: {} })
    reportData.value = res.data
    res = await request.post({ url: '/api/report/getCategory', data: {} })
    reportType.value = res.data
    activeIndex.value = reportType.value[0].name
}
// 后端API地址，建议从环境变量中读取
const BASE_API_URL = import.meta.env.VITE_REPORT_API_BASE_PATH;
const userStore = useUserStoreWithOut()
const token = userStore.getToken
const loadReportData = (item: any) => {
    console.log(`${BASE_API_URL}/jmreport/view/${item.jimucode}?token=${token}`)
    reportUrl.value = `${BASE_API_URL}/jmreport/view/${item.jimucode}?token=${token}`;
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
    height: 100%;
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

.jimu-report-container {
    width: 100%;
    height: 100%;
    /* 确保容器有明确的高度 */
    overflow: hidden;
}
</style>