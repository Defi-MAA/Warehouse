<template>
  <ContentWrap>
    <div style="border-bottom: 1px solid #e4e7ed;">
      <Search :schema="searchSchema" @reset="setSearchParams" @search="setSearchParams" />
    </div>
    <div class="mb-10px" style="margin-top: 10px;">
      <BaseButton type="warning" :icon="Document" @click="exportExcel">导出</BaseButton>
    </div>

    <el-table :data="tableData" @sort-change="handleSortChange" :default-sort="{
      prop: 'tcode',
      order: 'descending'
    }" style="width: 100%" :height="tableHeight" :header-cell-style="{ color: '#000000' }"
      @selection-change="handleSelectionChange" id="out-table" stripe :border="true" ref="tableRef">
      <el-table-column prop="item" label="物资编码" width="100px">
      </el-table-column>
      <el-table-column prop="namespec" label="品名规格" width="100px">

      </el-table-column>
      <el-table-column prop="unit" label="库存单位" width="100px">
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100px">
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
      <el-table-column prop="expdate" label="保质期"  show-overflow-tooltip width="130px">
      </el-table-column>
      <el-table-column prop="tdate" label="事务日期" show-overflow-tooltip width="190px">
      </el-table-column>
      <el-table-column prop="usage" label="结存编号" width="100px">
      </el-table-column>




    </el-table>
    <el-pagination style="margin-top: 8px;" v-model:current-page="currentPage" v-model:page-size="pageSize"
      :page-sizes="[100, 200, 300, 400]" :size="size" :disabled="total === 0" :background="background"
      layout="total, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
      @current-change="handleCurrentChange" />

  </ContentWrap>

</template>
<script setup lang="tsx">
import { ContentWrap } from '@/components/ContentWrap'
import { reactive, ref, unref, nextTick, onMounted, onUpdated } from 'vue'
import { FormSchema } from '@/components/Form'
import { Search } from '@/components/Search'
import { BaseButton } from '@/components/Button'
import type { UploadProps } from 'element-plus'
import { createImageViewer } from '@/components/ImageViewer'
import { ElMessage, ElMessageBox, FormRules, FormInstance, ComponentSize, ElTable } from 'element-plus'

import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty, getAuthorization } from '@/utils/index'

import request from '@/axios'
import {
  exportTable
} from '@/utils/export'

const exportExcel = (() => {
  exportTable("#out-table", "table");
})

const getAuth = (() => {
  const userStore = useUserStoreWithOut()
  const token = userStore.getToken
  const tokenKey = userStore.getTokenKey
  return getAuthorization(token, tokenKey, userStore.getLoginInfo?.username || '')

})
const headers = ref({
  'Authorization': 'Bearer ' + getAuth()
})


const typeids = ref<any[]>([])
const initData = async () => {
  console.log('initData')
  //let res = await request.post({ url: '/api/goods/selectGoodstypeA',data:{} })
  //typeids.value = res.data || []
}
const isInit = ref(true)
onMounted(async () => {
  initData()
  await getList()
  nextTick(() => {
    isInit.value = false
  })
})
interface RuleForm {
  name: string
}
const ruleFormRef = ref<FormInstance>()
const rules = reactive<FormRules<RuleForm>>({
  name: [
    { required: true, message: '请输入名称', trigger: 'blur' }
  ]
})

const tableRef = ref<InstanceType<typeof ElTable> | null>(null);
onUpdated(async () => {
  // Vue3 的 nextTick 是独立 API，返回 Promise，推荐用 await 替代回调
  await nextTick();
  // 类型守卫：避免 ref 为空或 doLayout 方法不存在导致报错
  if (tableRef.value && typeof tableRef.value.doLayout === 'function') {
    tableRef.value.doLayout(); // 调用表格的 doLayout 方法
  }
});

const openView = (src) => {
  createImageViewer({
    urlList: [
      src
    ]
  })
}


interface formData {
  tcode?: string,
  ttype?: string,
  tdate?: string,
  vndr?: string,
  wrhs?: string,
  dept?: string,
  refno?: string,
  arrdate?: string,
  apitem?: string,
  invoice?: string,
  man1?: string,
  man2?: string,
  man3?: string,
  man4?: string,
  man5?: string,
  pstdate?: string,
  status?: string,
  memo?: string,
  flag?: string,
  editor?: string,
  delivertype?: string,
  trnstat?: string,
  crtstat?: string,
  tplid?: string,
  tplline?: string,
  autogen?: string,
  ivadttype?: string,
  refno0?: string,
  prtcount?: string,
  apno?: string,
  pricedate?: string,
  prvndr1?: string,
  prvndr2?: string,
  prvndr3?: string,
  fistmp?: string,
  DiscardType?: string,

}

const tableHeight = ref(window.innerHeight - 300)
const tableData = ref<formData[]>([])
const currentPage = ref(1)
const pageSize = ref(100)
const size = ref<ComponentSize>('default')
const total = ref(0)
const background = ref(false)
const handleSizeChange = (val: number) => {
  currentPage.value = 1
  getList()
}
const handleCurrentChange = (val: number) => {
  if (isInit.value) return
  getList()
}
const sorts = ref({ order: 'descending', prop: 'tcode' })
const getSorts = () => {
  let order = "";
  if (sorts.value.order === 'descending') {
    order = 'desc'
  } else if (sorts.value.order === 'ascending') {
    order = 'asc'
  }
  return sorts.value.prop + ' ' + order
}
const getList = async () => {

  let params = { ...searchParams.value }
  let data = {
    page: unref(currentPage),
    limit: unref(pageSize),
    keys: params,
    orders: getSorts()
  }
  const res = await request.post({ url: '/api/store/selectIvstockPage', data })
  tableData.value = res.data.records || []
  total.value = res.data.totalRow
}

const handleSortChange = (sort: any) => {
  sorts.value = sort
  getList();
}
const checkData = ref<formData[]>([])
const handleSelectionChange = (val: formData[]) => {
  checkData.value = val
}

const form = ref<formData>({
  tcode: '',
  ttype: '',
  tdate: '',
  vndr: '',
  wrhs: '',
  dept: '',
  refno: '',
  arrdate: '',
  apitem: '',
  invoice: '',
  man1: '',
  man2: '',
  man3: '',
  man4: '',
  man5: '',
  pstdate: '',
  status: '',
  memo: '',
  flag: '',
  editor: '',
  delivertype: '',
  trnstat: '',
  crtstat: '',
  tplid: '',
  tplline: '',
  autogen: '',
  ivadttype: '',
  refno0: '',
  prtcount: '',
  apno: '',
  pricedate: '',
  prvndr1: '',
  prvndr2: '',
  prvndr3: '',
  fistmp: '',
  DiscardType: '',

})



const searchSchema = reactive<FormSchema[]>([
  {
    field: 'lot',
    label: '批次',
    component: 'Input'
  },
  {
    field: 'name',
    label: '品名',
    component: 'Input'
  },
  {
    field: 'tdate',
    label: '日期',
    component: 'DatePicker',
    componentProps: {
      type: 'date',
      valueFormat: 'YYYY-MM-DD'
    }
  }


])

const searchParams = ref({})
const setSearchParams = (data: any) => {
  searchParams.value = data
  currentPage.value = 1
  getList()
}


import { Plus, View, Refresh, Delete, Document, Edit } from '@element-plus/icons-vue'
</script>


<style lang="less" scoped>
.avatar-uploader {
  width: 178px;
  height: 178px;
  position: relative;
  border: 1px dashed var(--el-border-color);
}

.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;

  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
}

.avatarimg {
  width: 178px;
  height: 178px;
  color: #8c939d;
  text-align: center;
}

.delete-btn {
  position: absolute;
  top: 1px;
  right: 1px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #f56c6c;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  border: 2px solid white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  z-index: 10;
}

::v-deep .el-table .el-table__cell {
  z-index: inherit !important;
}
</style>