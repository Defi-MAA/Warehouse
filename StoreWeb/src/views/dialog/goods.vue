<template>
    <div>
        <div>
            <div style="display:inline-block;">
                <label class="radio-label" style="padding-left:10px;">分类: </label>
                <el-select v-model="keys.category" placeholder="请选择" filterable style="width: 120px;">
                    <el-option v-for="(item, index) in category" :key="index" :label="item.name" :value="item.code" />
                </el-select>
            </div>
            <div style="display:inline-block;">
                <label class="radio-label" style="padding-left:10px;">名称: </label>
                <el-input v-model="keys.name" placeholder="" style="width:200px;" />
            </div>

            <el-button style="margin:0 0 20px 20px;" type="primary" :icon="Search" @click="search">
                查询
            </el-button>
            <el-button style="margin:0 0 20px 20px;" :icon="Refresh" @click="reload">
                重置
            </el-button>

            <el-table v-loading="listLoading" :data="list" border fit highlight-current-row style="width: 100%"
                :height="tableHeight"  @row-dblclick="sel" @selection-change="setCheck" :header-cell-style="{ color: '#000000' }">
                <el-table-column  type="selection" width="35" />
                <el-table-column  prop="code" label="物资编码" width="100px" />
                <el-table-column  prop="name" label="物资名称" width="120px" />
                <el-table-column  prop="spec" label="规格型号" width="100px" />
                <el-table-column  prop="En_Spec" label="英文规格" width="100px" />
                <el-table-column  prop="unit" label="库存单位" width="100px" />
                <el-table-column  prop="category" label="物资类别" width="100px" />
                <el-table-column  prop="maxqty" label="最高存量" width="100px" />
                <el-table-column  prop="minqty" label="最低存量" width="100px" />
                <el-table-column  prop="reorder" label="再订购点" width="100px" />
                <el-table-column  prop="costing" label="计价方法" width="100px" />
                <el-table-column  prop="oqnum" label="经济批量" width="100px" />
                <el-table-column  prop="levels" label="级别" width="100px" />
                <el-table-column  prop="stat" label="状态" width="100px" />
                <el-table-column  prop="flag" label="标志" width="100px" />
                <el-table-column  prop="accno" label="库存商品科目" width="100px" />
                <el-table-column  prop="cust4" label="辅助帐号项目" width="100px" />
                <el-table-column  prop="Overacc" label="短益科目" width="100px" />
                <el-table-column  prop="usage" label="用途" width="100px" />

                <el-table-column  label="操作" fixed="right" width="120">
                    <template #default="{ row }">
                        <el-button type="success" @click="sel(row)"> 选择 </el-button>
                    </template>
                </el-table-column>
            </el-table>

            <el-pagination style="margin-top: 8px;" v-model:current-page="page" v-model:page-size="limit"
                :page-sizes="[100, 200, 300, 400]" :disabled="total === 0"
                layout="total, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" />
            
        </div>
        <el-row style="margin-bottom: -20px; margin-top: 10px; display: flex; justify-content: flex-end;">
            <el-button type="primary" @click="confirmDlg">确定</el-button>
            <el-button @click="closeDlg">关闭</el-button>
        </el-row>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/axios'

import {  Refresh, Search } from '@element-plus/icons-vue'

// --- 类型定义 ---
interface Item {
    code: string
    name: string
    spec: string
    En_Spec: string
    unit: string
    category: string
    maxqty: number | string
    minqty: number | string
    reorder: number | string
    costing: string
    oqnum: number | string
    levels: string
    stat: string
    flag: string
    accno: string
    cust4: string
    Overacc: string
    usage: string
    [key: string]: any
}

interface CategoryItem {
    name: string
    code: string
}

interface SearchKeys {
    category?: string
    name?: string
    [key: string]: any
}

interface ApiResponse<T> {
    data: T
    total?: number
    [key: string]: any
}

// --- 响应式数据 ---
const list = ref<Item[]>([])
const page = ref(1)
const limit = ref(100)
const total = ref(0)
const listLoading = ref(false)
const keys = reactive<SearchKeys>({})
const tableHeight = ref('300px')
const category = ref<CategoryItem[]>([])
const checkList = ref<Item[]>([])
const orders = ref('code desc') // 原代码中用到，补充定义

// --- 事件定义（用于父组件）---
const emit = defineEmits<{
    (e: 'setGoods', row: Item): void
    (e: 'setMoreGoods', items: Item[]): void
    (e: 'goodsClose', value: boolean): void
}>()

// --- 方法 ---
const initData = async () => {
    try {
        const res = await request.post({ url: '/api/ivitem/getTClass', data: {
        } })
        category.value = res.data
    } catch (error) {
        console.error(error)
    }
}

const setCheck = (val: Item[]) => {
    checkList.value = val
}

const search = () => {
    refData(1)
}

const reload = () => {
    // 重置 keys 对象
    Object.keys(keys).forEach(key => {
        delete keys[key]
    })
    refData()
}

const refData = (pg?: number) => {
    if (pg !== undefined) {
        page.value = pg
    } else {
        page.value = 1
    }
    list.value = []
    getList()
}

const currentPage = ref(1)
const handleSizeChange = (val: number) => {
    currentPage.value = 1
    getList()
}
const isInit = ref(true)
const handleCurrentChange = (val: number) => {
    if (isInit.value) return
    getList()
}


const getList = async () => {
    listLoading.value = true
    keys.flag = 1
    try {
        const res = await request.post({ url: '/api/ivitem/selectIvitemPage', data: {
            page: page.value,
            limit: limit.value,
            keys: keys,
            orders: orders.value    
        }})
        list.value = res.data.records
        total.value = res.data.totalPage ?? 0
    } catch (error) {
        console.error(error)
    } finally {
        listLoading.value = false
    }
}

const sel = (row: Item) => {
    emit('setGoods', row)
}

const confirmDlg = () => {
    if (checkList.value.length === 0) {
        ElMessage.error('请勾择商品!')
        return
    }
    console.log(checkList.value)
    emit('setMoreGoods', checkList.value)
}

const closeDlg = () => {
    emit('goodsClose', true)
}

// --- 生命周期 ---
onMounted(() => {
    initData()
    getList()
})
</script>

<style scoped>
/* 保持原样式 */
</style>