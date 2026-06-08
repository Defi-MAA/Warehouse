<template>
    <div>
        <div>

            <!-- <el-button style="margin:0 0 20px 20px;" :icon="Refresh" @click="reload">
                重置
            </el-button> -->

            <el-table v-loading="listLoading" :data="list" border fit highlight-current-row style="width: 100%"
                :height="tableHeight" @row-dblclick="sel" :header-cell-style="{ color: '#000000' }">

                <el-table-column prop="item" label="物资编码" width="100px">
                </el-table-column>
                <el-table-column prop="namespec" label="品名规格" width="100px">

                </el-table-column>
                <el-table-column prop="unit" label="库存单位" width="100px">
                </el-table-column>
                <el-table-column prop="locationname" label="位置" width="100px">
                </el-table-column>
                <el-table-column prop="lot" label="批次" show-overflow-tooltip width="140px">
                </el-table-column>
                <el-table-column prop="qty" label="数量" width="100px">
                </el-table-column>
                <el-table-column prop="price" label="单价" width="100px">
                </el-table-column>
                <el-table-column prop="amt" label="金额" width="100px">
                </el-table-column>
                <el-table-column prop="expdate" label="保质期" width="130px">
                </el-table-column>
                <el-table-column prop="tdate" label="事务日期" show-overflow-tooltip width="190px">
                </el-table-column>
                <el-table-column prop="usage" label="结存编号" width="100px">
                </el-table-column>
                <el-table-column label="操作" fixed="right" width="120">
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

            <el-button @click="closeDlg">关闭</el-button>
        </el-row>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/axios'

import { Refresh, Search } from '@element-plus/icons-vue'

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
    (e: 'setlot', row: Item): voids
    (e: 'lotClose', value: boolean): void
}>()



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
        const res = await request.post({
            url: '/api/store/selectIvstockPage', data: {
                page: page.value,
                limit: limit.value,
                keys: keys,
                orders: orders.value
            }
        })
        list.value = res.data.records
        total.value = res.data.totalPage ?? 0
    } catch (error) {
        console.error(error)
    } finally {
        listLoading.value = false
    }
}

const sel = (row: Item) => {
    emit('setlot', row)
}

const loadData = (item: string, wrhs: string) => {
    keys.item = item
    keys.location = wrhs
    refData()
}

const closeDlg = () => {
    emit('lotClose', true)
}
defineExpose({
    loadData
});

</script>

<style scoped>
/* 保持原样式 */
</style>