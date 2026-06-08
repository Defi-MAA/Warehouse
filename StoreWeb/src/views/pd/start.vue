<template>
  <ContentWrap>
    <div>
      <div style="display:inline-block;">
        <label class="radio-label" style="padding-left:10px;">编码</label>
        <el-input v-model="keys.code" placeholder="" style="width: 150px;" />
      </div>
      <div style="display:inline-block;">
        <label class="radio-label" style="padding-left:10px;">名称</label>
        <el-input v-model="keys.name" placeholder="" style="width: 150px;" />
      </div>

      <el-button style="margin:0 0 0px 20px;" type="primary" :icon="Search" @click="search">
        查询
      </el-button>
      <el-button style="margin:0 0 0px 20px;" :icon="Refresh" @click="reload">
        重置
      </el-button>


      <el-table v-loading="listLoading" :data="list" :height="tableHeight" border fit highlight-current-row
        style="width: 100%;margin-top: 10px;" @sort-change="sort" id="out-table" :header-cell-style="{ color: '#000000' }" ref="tableRef">
        <el-table-column align="center" prop="code" label="仓库编码" width="150px" />
        <el-table-column align="center" prop="name" label="仓库名称" width="150px" />
        <el-table-column align="center" prop="wrhsstat" label="仓库类型" width="150px">
          <template #default="{ row }">
            {{ row.wrhsstat == '0' ? '仓库' : '部门' }}
          </template>
        </el-table-column>
        <el-table-column align="center" prop="islock" label="盘点状态" width="150px">
          <template #default="{ row }">
            {{ row.islock == 1 ? '开' : '关' }}
          </template>
        </el-table-column>

        <el-table-column align="center" width="220">
          <template #default="{ row }">
            <el-button v-if="row.islock == 0" type="primary" :icon="Open" @click="SetSwicth(row)">
              打开
            </el-button>
            <el-button v-else type="danger" :icon="Close" @click="SetSwicth(row)">
              关闭
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>


  </ContentWrap>
</template>

<script setup lang="ts">
import { ContentWrap } from '@/components/ContentWrap'
import { ref, reactive, onMounted, onUnmounted, nextTick,onUpdated  } from 'vue'
import { ElMessage, FormInstance, FormRules,ElTable } from 'element-plus'
import { isEmpty } from '@/utils'
import { exportTable } from '@/utils/export.js'

import { Search, Refresh, Open, Close } from '@element-plus/icons-vue'
import request from '@/axios'
// --- 类型定义 ---
interface StoreItem {
  id?: string
  code: string
  name: string
  wrhsstat: string // '0' 仓库, '1' 部门
  islock: boolean
  manager?: string
  place?: string
  area?: string
  accno?: string
  wrhslevel?: string
  category?: string
  widept?: string
  memo?: string
  flag?: boolean | string
  status?: boolean | string
  ictowi?: boolean | string
}

interface OptionItem {
  code: string
  name: string
}

// 响应式数据
const list = ref<StoreItem[]>([])
const listLoading = ref(false)
const downloadLoading = ref(false)
const dlgEdit = ref(false)
const loading = ref(false)
const dlgTitle = ref('新增')
const isedit = ref(false)
const page = ref(1)
const limit = ref(100)
const total = ref(0)
const orders = ref('')
const tableHeight = ref(window.innerHeight - 250)
const dialogWidth = ref('980px')
const category = ref<OptionItem[]>([])
const storetype = ref<OptionItem[]>([])

// 搜索条件
const keys = reactive({
  code: '',
  name: ''
})

// 表单数据
const form = reactive<StoreItem>({
  code: '',
  name: '',
  wrhsstat: '',
  islock: false,
  manager: '',
  place: '',
  area: '',
  accno: '',
  wrhslevel: '',
  category: '',
  widept: '',
  memo: '',
  flag: true,
  status: true,
  ictowi: true
})

// 表单引用
const dlgForm = ref<FormInstance>()

const tableRef = ref<InstanceType<typeof ElTable> | null>(null);
onUpdated(async () => {
	// Vue3 的 nextTick 是独立 API，返回 Promise，推荐用 await 替代回调
	await nextTick();
	// 类型守卫：避免 ref 为空或 doLayout 方法不存在导致报错
	if (tableRef.value && typeof tableRef.value.doLayout === 'function') {
		tableRef.value.doLayout(); // 调用表格的 doLayout 方法
	}
});
 

// 验证规则
const validatename = (_rule: any, value: string, callback: (err?: Error) => void) => {
  if (isEmpty(value)) {
    callback(new Error('请输入名称！'))
  } else {
    callback()
  }
}

const rules = reactive<FormRules<StoreItem>>({
  name: [{ required: true, trigger: 'blur', validator: validatename }],
  code: [{ required: true, trigger: 'blur', validator: validatename }]
})

// --- 方法 ---
const setDialogWidth = () => {
  const val = document.body.clientWidth
  const def = 980
  dialogWidth.value = val < def ? '100%' : def + 'px'
}

const sort = (obj: { prop: string; order: string | null }) => {
  const { prop, order } = obj
  if (order) {
    orders.value = `${prop} ${order === 'descending' ? 'desc' : 'asc'}`
    refData()
  }
}

const refData = (pg?: number) => {
  if (pg) page.value = pg
  else page.value = 1
  list.value = []
  getList()
}

const getList = async () => {
  listLoading.value = true
  try {
    const params = {
      keys: keys,
      orderBy: orders.value,
      page: page.value,
      limit: limit.value
    }
    const res = await request.post({
      url: '/api/ivwrhs/selectIvwrhsPage', data: params
    })
    list.value = res.data.records
    total.value = res.data.totalPage
  } catch (error) {
    console.error(error)
    ElMessage.error('获取数据失败')
  } finally {
    listLoading.value = false
  }
}

const search = () => {
  getList()
}

const reload = () => {
  keys.code = ''
  keys.name = ''
  refData()
}

const add = () => {
  dlgTitle.value = '新增'
  isedit.value = false
  dlgEdit.value = true
  nextTick(() => {
    dlgForm.value?.resetFields()
    Object.assign(form, {
      id: undefined,
      code: '',
      name: '',
      wrhsstat: '',
      manager: '',
      place: '',
      area: '',
      accno: '',
      wrhslevel: '',
      category: '',
      widept: '',
      memo: '',
      flag: true,
      status: true,
      ictowi: true
    })
  })
}




const SetSwicth = async (item: StoreItem) => {
  item.islock = !item.islock
  const lcs = list.value.filter(o => o.islock).map(o => o.code).join(',')
  try {
    const res = await request.post({
      url: '/api/store/setSwicth', data: { chklock: lcs }
    })
    if (res.code == 0) {
      refData(page.value)
    }
  } catch (error) {
    console.error(error)
    ElMessage.error('请求失败')
  }
}




onMounted(() => {
  getList()
})



</script>

<style lang="less" scoped>
.radio-label {
  font-size: 14px;
  color: #606266;
  font-weight: normal;
  line-height: 40px;
  padding: 0 12px 0 30px;
}

:deep(.el-form-item__label) {
  text-align: right;
  font-weight: normal;
  vertical-align: middle;
  float: left;
  font-size: 14px;
  color: #606266;
  line-height: 40px;
  padding: 0 12px 0 0;
  box-sizing: border-box;
}

.el-form-item--small.el-form-item {
  margin-bottom: 8px;
}

.el-form-item {
  margin-bottom: 2px;
}

.closeico:hover {
  cursor: pointer;
}
</style>