<template>
  <ContentWrap>
    <div style="border-bottom: 1px solid #e4e7ed;">
      <Search :schema="searchSchema" @reset="setSearchParams" @search="setSearchParams" />
    </div>
    <div class="mb-10px" style="margin-top: 10px;">
      <BaseButton type="primary" :icon="Money" @click="settleData()">收款</BaseButton>
      <BaseButton :loading="delLoading" :icon="Delete" type="danger" @click="voidData()">
        冲销
      </BaseButton>
      <BaseButton type="warning" :icon="Document" @click="exportExcel">导出</BaseButton>
    </div>

    <el-table :data="tableData" @sort-change="handleSortChange" :default-sort="{
      prop: 'id',
      order: 'descending'
    }" style="width: 100%" :height="tableHeight" :header-cell-style="{ color: '#000000' }"
      @selection-change="handleSelectionChange" id="out-table" stripe :border="true" ref="tableRef">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="status" label="状态" show-overflow-tooltip sortable="custom" width="90">
        <template #default="{ row }">
          {{ getStatus(row.status) }}
        </template>
      </el-table-column>

      <el-table-column prop="createtime" label="日期" show-overflow-tooltip sortable="custom" width="190">
      </el-table-column>
      <el-table-column prop="sourcetcode" label="单号" show-overflow-tooltip sortable="custom" width="130">
        <template #default="{ row }">
          <el-link type="primary" @click.stop="viewReport(row)">{{ row.sourcetcode }}</el-link>
        </template>
      </el-table-column>
      <el-table-column prop="vendorname" label="销售商" show-overflow-tooltip sortable="custom" width="150">
      </el-table-column>
      <el-table-column prop="amount" label="应收总额" show-overflow-tooltip sortable="custom" width="120">
      </el-table-column>
      <el-table-column prop="receivedamount" label="已收金额" show-overflow-tooltip sortable="custom" width="120">
      </el-table-column>
      <el-table-column prop="unpaidamount" label="未收金额" show-overflow-tooltip sortable="custom" width="120">
      </el-table-column>
      <el-table-column prop="duedate" label="到期日" show-overflow-tooltip sortable="custom" width="120">
      </el-table-column>

      <el-table-column label="操作" min-width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" v-if="row.status === '1' || row.status === '2'" link @click="viewPayed(row)"
            style="margin-right: 10px;">
            收款单
          </el-button>

          <el-button type="primary" v-if="row.status === '1' || row.status === '2'" link @click="viewDetail(row)"
            style="margin-right: 10px;">
            明细
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination style="margin-top: 8px;" v-model:current-page="currentPage" v-model:page-size="pageSize"
      :page-sizes="[100, 200, 300, 400]" :size="size" :disabled="total === 0" :background="background"
      layout="total, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
      @current-change="handleCurrentChange" />

  </ContentWrap>

  <Dialog v-model="dialogVisible" width="850px" max-height="400px" title="收款">

    <el-row :gutter="10">
      <el-table :data="settleList" :header-cell-style="{ color: '#000000' }" stripe :border="true" show-summary
        :summary-method="getSummaries" height="390px">
        <el-table-column prop="sourcetcode" label="单号" show-overflow-tooltip width="150">

        </el-table-column>
        <el-table-column prop="vendorname" label="销售商" show-overflow-tooltip width="150">
        </el-table-column>
        <el-table-column prop="amount" label="应收总额" show-overflow-tooltip width="120">
        </el-table-column>

        <el-table-column prop="paidamount" label="已收金额" show-overflow-tooltip sortable="custom" width="120">
        </el-table-column>
        <el-table-column prop="unpaidamount" label="实收金额" show-overflow-tooltip width="190">
          <template #default="{ row }">
            <el-input v-model="row.unpaidamount" type="number" placeholder="请输入实付金额" />
          </template>
        </el-table-column>
      </el-table>
    </el-row>

    <template #footer>
      <el-row :gutter="10">
        <el-form :model="form" :rules="rules" ref="ruleFormRef" label-width="120px">
          <el-form-item label="收款方式" prop="settlementdate">
            <el-select v-model="form.paytype" style="width: 200px; " placeholder="请选择">
              <el-option v-for="(item, index) in settlelist" :key="index" :label="item.name" :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
        <el-form :model="form" :rules="rules" ref="ruleFormRef" label-width="120px">
          <el-form-item label="备注" prop="remarks">
            <el-input v-model="form.remarks" placeholder="请输入备注" style="width: 250px; " />
          </el-form-item>
        </el-form>
      </el-row>
      <BaseButton v-if="actionType !== 'detail'" type="primary" :loading="saveLoading" @click="saveData(ruleFormRef)">
        确认收款
      </BaseButton>
      <BaseButton @click="dialogVisible = false">关闭</BaseButton>
    </template>


  </Dialog>
  <Dialog v-model="dlgPayed" width="80%" maxHeight="500px" title="收款单">
    <el-row :gutter="10">
      <el-col :span="12">
        <el-table :data="payList" :header-cell-style="{ color: '#000000' }" ref="payListRef" @row-click="rowClick"
          stripe :border="true" height="390px">
          <el-table-column prop="receipt_no" label="收款单号" show-overflow-tooltip width="150">

          </el-table-column>
          <el-table-column prop="amount" label="收款总额" show-overflow-tooltip width="120">

          </el-table-column>
          <el-table-column prop="payname" label="收款方式" show-overflow-tooltip width="120">

          </el-table-column>
          <el-table-column label="操作" min-width="180" fixed="right">
            <template #default="{ row }">
              <el-button type="primary" link @click="viewReportBill(row.receipt_no)" style="margin-right: 10px;">
                打印
              </el-button>

              <el-button type="primary" link @click="cancelReceipt(row)" style="margin-right: 10px;">
                取消
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
      <el-col :span="12">
        <el-table :data="payList1" :header-cell-style="{ color: '#000000' }" stripe :border="true" height="390px">
          <el-table-column prop="receipt_date" label="日期" show-overflow-tooltip width="170">

          </el-table-column>
          <el-table-column prop="source_tcode" label="单号" show-overflow-tooltip width="150">

          </el-table-column>
          <el-table-column prop="amount" label="收款金额" show-overflow-tooltip width="150">

          </el-table-column>

        </el-table>
      </el-col>
    </el-row>
  </Dialog>

  <Dialog v-model="dlgDetail" width="70%" maxHeight="500px" title="明细">

    <el-table :data="detailList" :header-cell-style="{ color: '#000000' }" stripe :border="true" height="390px">
      <el-table-column prop="receipt_date" label="日期" show-overflow-tooltip width="170">

      </el-table-column>
      <el-table-column prop="receipt_no" label="收款单号" show-overflow-tooltip width="150">

      </el-table-column>
      <el-table-column prop="source_tcode" label="单号" show-overflow-tooltip width="150">

      </el-table-column>
      <el-table-column prop="amount" label="收款金额" show-overflow-tooltip width="150">

      </el-table-column>

    </el-table>
  </Dialog>

  <Dialog v-model="dlgReport" width="70%" maxHeight="500px" :title="rptTitle">
    <Report ref="myrpt1"></Report>
  </Dialog>
</template>
<script setup lang="tsx">
import { ContentWrap } from '@/components/ContentWrap'
import { reactive, ref, unref, nextTick, onMounted, onUpdated } from 'vue'
import { FormSchema } from '@/components/Form'
import { Search } from '@/components/Search'
import { BaseButton } from '@/components/Button'
import { Dialog } from '@/components/Dialog'
import type { UploadProps } from 'element-plus'
import { createImageViewer } from '@/components/ImageViewer'
import { ElMessage, ElMessageBox, FormRules, FormInstance, ComponentSize, ElTable } from 'element-plus'
import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty, getAuthorization } from '@/utils/index'
import Report from '../dialog/report.vue'

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

const getStatus = (status: string) => {
  if (status === '0') {
    return '未收款'
  } else if (status === '1') {
    return '部分收款'
  } else if (status === '2') {
    return '已收款'
  } else if (status === '3') {
    return '冲销'
  }
  else {
    return '未知状态'
  }
}



const typeids = ref<any[]>([])
const settlelist = ref<any[]>([])
const custlist = ref<any[]>([])
const initData = async () => {
  request.post({ url: '/api/config/getAllData', data: {} }).then(res => {
    custlist.value = res.data.sales
    settlelist.value = res.data.apiitemD
  }).catch(error => { })
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
  await nextTick();
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
  paytype?: string,
  remarks?: string
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
const sorts = ref({ order: 'descending', prop: 'id' })
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
  const res = await request.post({ url: '/api/ardetail/selectArdetailPage', data })
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
  paytype: '',
  remarks: ''

})
const actionType = ref('')


const statuslist = ref<any[]>([
  {
    label: '全部',
    value: '-1'
  },
  {
    label: '未收款',
    value: '0'
  },
  {
    label: '部分收款',
    value: '1'
  },
  {
    label: '已收款',
    value: '2'
  },
  {
    label: '冲销',
    value: '3'
  }
])
const overduelist = ref<any[]>([
  {
    label: '全部',
    value: '-1'
  },
  {
    label: '未逾期',
    value: '0'
  },
  {
    label: '已逾期',
    value: '1'
  }
  ,
  {
    label: '逾期30天以上',
    value: '30'
  },
  {
    label: '逾期60天以上',
    value: '60'
  },
  {
    label: '逾期90天以上',
    value: '90'
  }
])



const searchSchema = reactive<FormSchema[]>([
  {
    field: 'createtime',
    label: '日期',
    component: 'DatePicker',
    componentProps: {
      type: 'date',
      valueFormat: 'YYYY-MM-DD'
    }
  },
  {
    field: 'status',
    label: '状态',
    component: 'Select',
    componentProps: {
      multiple: true,
      options: statuslist.value
    }
  },
  {
    field: 'vendorid',
    label: '销售商',
    component: 'Select',

    optionApi: async () => {
      let data = custlist.value.map((v: any) => ({
        label: v.name,
        value: v.code
      }))
      return data
    }
  },
  {
    field: 'sourcetcode',
    label: '单号',
    component: 'Input',
  },
  {
    field: 'overdue',
    label: '逾期',
    component: 'Select',
    componentProps: {
      options: overduelist.value
    }
  },

])

const searchParams = ref({})
const setSearchParams = (data: any) => {
  searchParams.value = data
  currentPage.value = 1
  getList()
}

const editData = async (row: any) => {
  dialogTitle.value = '修改'
  actionType.value = 'edit'
  const res = await request.post({ url: '/api/apdetail/getArdetail', data: { id: row.id } })
  form.value = res.data || {};
  dialogVisible.value = true

}

const delLoading = ref(false)
const settleList = ref<any>([])
const settleData = async () => {
  if (checkData.value.length == 0) {
    ElMessage.error('请勾选数据')
    return
  }
  let data = checkData.value.filter((v: any) => v.status !== '0' && v.status !== '1') || []
  if (data.length > 0) {
    ElMessage.error('请勾选未结算数据')
    return
  }

  form.value = {
    paytype: '',
    remarks: ''
  }

  settleList.value = []
  checkData.value.forEach((item: any) => {
    settleList.value.push({
      sourcetcode: item.sourcetcode,
      paidamount: item.paidamount,
      vendorid: item.custid,
      amount: item.amount,
      vendorname: item.vendorname,
      unpaidamount: item.unpaidamount,
      id: item.id
    })
  })
  dialogVisible.value = true

}

const voidData = async () => {

  if (checkData.value.length == 0) {
    ElMessage.error('请勾选数据')
    return
  }
  let data = checkData.value.filter((v: any) => v.status !== '0') || []
  if (data.length > 0) {
    ElMessage.error('请勾选未收款数据')
    return
  }

  let fnum = 0;
  let n = checkData.value.length
  ElMessageBox.confirm('确定冲销选中的数据吗？', '冲销确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {

    checkData.value.forEach(async (item: any) => {
      request.post({ url: '/api/finance/voidReceipt', data: { id: item.id } }).then(res => {
        fnum++
        if (fnum >= n) {
          ElMessage.success('冲销成功')
          getList()
        }
      }).catch(error => {
        fnum++
        if (fnum >= n) {
          ElMessage.success('冲销成功')
          getList()
        }
      })
    })

  })

}

const getSummaries = (param) => {
  const { columns, data } = param
  const sums = []
  columns.forEach((column, index) => {
    if (index === 0) {
      sums[index] = '合计'
      return
    }
    const values = data.map((item) => Number(item[column.property]))
    if (!values.every((value) => Number.isNaN(value))) {
      sums[index] = `${values.reduce((prev, curr) => {
        const value = Number(curr)
        if (!Number.isNaN(value)) {
          return prev + curr
        } else {
          return prev
        }
      }, 0)}`
    } else {
      sums[index] = ''
    }
  })

  return sums
}






const dialogVisible = ref(false)
const dialogTitle = ref('')
const AddAction = async () => {
  dialogTitle.value = '增加'
  actionType.value = ''
  form.value = {
    amount: '',
    createtime: '',
    duedate: '',
    invoiceno: '',
    paidamount: '',
    sourcetcode: '',
    status: '',
    unpaidamount: '',
    vendorid: '',

  };

  dialogVisible.value = true
}

const saveLoading = ref(false)
const saveData = async (formEl: FormInstance | undefined) => {
  if (!formEl) return
  await formEl.validate(async (valid) => {
    if (valid) {
      let formData = { ...form.value }
      if (formData) {
        saveLoading.value = true
        const res = await request.post({
          url: '/api/finance/receipt',
          data: {
            paymentData: settleList.value,
            payType: formData.paytype,
            remarks: formData.remarks
          }
        }).catch(() => {
          ElMessage.error('保存失败')
        }).finally(() => {
          saveLoading.value = false
        })
        if (res && res.code === 0) {
          ElMessage.success('收款成功')
          dialogVisible.value = false
          getList()
          viewReportBill(res.message)
        }
      }
    }
  })
}

const dlgReport = ref(false)
const rptTitle = ref('')
const myrpt1 = ref<Report>()
const viewReport = (row: any) => {
  console.log(11111)
  dlgReport.value = true
  rptTitle.value = "报表"
  nextTick(() => {
    if (myrpt1.value) {
      myrpt1.value.loadReportData(
        row.ttype + 'Bill',
        { TCode: row.sourcetcode }
      )
    }
  })
}

const viewReportBill = (code: any) => {
  dlgReport.value = true
  rptTitle.value = "报表"
  nextTick(() => {
    if (myrpt1.value) {
      myrpt1.value.loadReportData(
        'ReceiptBill',
        { code: code }
      )
    }
  })
}


const payList = ref<any>([])
const payList1 = ref<any>([])
const dlgPayed = ref(false)
const payListRef = ref<InstanceType<typeof ElTable> | null>(null);
const currentRow = ref<any>({})
const viewPayed = async (row: any) => {
  currentRow.value = row
  dlgPayed.value = true
  payList.value = []
  payList1.value = []
  const res = await request.post({ url: '/api/finance/getReceiptList', data: { id: row.id } })
  if (res && res.code === 0) {
    payList.value = res.data || []
    if (res.data && res.data.length > 0) {
      payListRef.value?.setCurrentRow(payList.value[0])
      rowClick(payList.value[0])
    }


  }
}

const rowClick = async (row: any) => {
  const res1 = await request.post({ url: '/api/finance/getReceiptDetailList', data: { no: row.receipt_no } })
  if (res1 && res1.code === 0) {
    payList1.value = res1.data || []
  }
}


const detailList = ref<any>([])
const dlgDetail = ref(false)
const viewDetail = async (row: any) => {
  detailList.value = []
  dlgDetail.value = true
  const res = await request.post({ url: '/api/finance/getReceiptDetail', data: { id: row.id } })
  if (res && res.code === 0) {
    detailList.value = res.data || []
  }
}

const cancelReceipt = async (row: any) => {
  ElMessageBox.confirm('确定取消选中的收款吗？', '取消确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const res = await request.post({ url: '/api/finance/cancelReceipt', data: { no: row.receipt_no } })
    if (res && res.code === 0) {
      ElMessage.success('取消成功')
      viewPayed(currentRow.value)
      getList()
    }
  })

}






import { Plus, View, Refresh, Delete, Document, Edit, Money } from '@element-plus/icons-vue'

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