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
import { Icon } from '@/components/Icon'
import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty, getAuthorization } from '@/utils/index'

import request from '@/axios'
import {
  exportTable
} from '@/utils/export'

const exportExcel = (() => {
  exportTable("#out-table", "table");
})



const typeids = ref<any[]>([])
const initData = async () => {
  console.log('initData')
  //let res = await request.post({ url: '/api/goods/selectGoodstypeA', data: {} })
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
  DeptCode: string
  DeptName: string
}
const ruleFormRef = ref<FormInstance>()
const rules = reactive<FormRules<RuleForm>>({
  DeptCode: [
    { required: true, message: '请输入编码', trigger: 'blur' }
  ],
  DeptName: [
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




interface formData {
  DeptCode: '',
  DeptParentCode: '',
  DeptName: '',
  Remarks: '',

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
const sorts = ref({ order: 'descending', prop: 'DeptCode' })
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
  const res = await request.post({ url: '/api/udept/selectUdeptPage', data })
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
  DeptCode: '',
  DeptParentCode: '',
  DeptName: '',
  Remarks: '',

})
const actionType = ref('')



const searchSchema = reactive<FormSchema[]>([
  {
    field: 'DeptName',
    label: '名称',
    component: 'Input'
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
  const res = await request.post({ url: '/api/udept/getUdept', data: { DeptCode: row.DeptCode } })
  form.value = res.data || {};
  dialogVisible.value = true

}

const delLoading = ref(false)
const ids = ref<string[]>([])
const delData = async (row: any | null) => {
  if (row == null) {
    ids.value = checkData.value.map((v: any) => v.DeptCode) || []
  } else {
    ids.value = [row.DeptCode]
  }
  if (ids.value.length == 0) {
    ElMessage.error('请选择要删除的数据')
    return
  } else {
    ElMessageBox.confirm('确定删除选中的数据吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(async () => {
      delLoading.value = true
      const res = await request.post({
        url: '/api/udept/deleteUdepts',
        data: {
          ids: ids.value
        }
      }).catch(() => {
        ElMessage.error('删除失败')
      }).finally(() => {
        delLoading.value = false
      })
      if (res && res.code === 0) {
        ElMessage.success('删除成功')
        getList()
      }
    })
  }

}

const dialogVisible = ref(false)
const dialogTitle = ref('')
const AddAction = async () => {
  dialogTitle.value = '增加'
  actionType.value = ''
  form.value = {
    DeptCode: '',
    DeptName: '',
    Remarks: '',
    DeptParentCode: '',

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
          url: actionType.value === 'edit' ? '/api/udept/updateUdept' : '/api/udept/insertUdept',
          data: formData
        }).catch(() => {
          ElMessage.error('保存失败')
        }).finally(() => {
          saveLoading.value = false
        })
        if (res && res.code === 0) {
          ElMessage.success('保存成功')
          dialogVisible.value = false
          getList()
        }
      }
    }
  })
}
import { Plus, View, Refresh, Delete, Document, Edit } from '@element-plus/icons-vue'
</script>

<template>
  <ContentWrap>
    
		<div style="border-bottom: 1px solid #e4e7ed;">
    <Search :schema="searchSchema" @reset="setSearchParams" @search="setSearchParams" />
		</div>
    <div class="mb-10px" style="margin-top: 10px;">
      <BaseButton type="primary" :icon="Plus" @click="AddAction">增加</BaseButton>
      <BaseButton :loading="delLoading" :icon="Delete" type="danger" @click="delData(null)">
        删除
      </BaseButton>
      <BaseButton type="warning" :icon="Document" @click="exportExcel">导出</BaseButton>
    </div>

    <el-table :data="tableData" @sort-change="handleSortChange" :default-sort="{
      prop: 'DeptCode',
      order: 'descending'
    }" style="width: 100%" :height="tableHeight" :header-cell-style="{ color: '#000000' }"
      @selection-change="handleSelectionChange" @row-dblclick="editData" id="out-table" stripe :border="true"
      ref="tableRef">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="DeptCode" label="编码" show-overflow-tooltip sortable="custom" width="180">
      </el-table-column>
      <el-table-column prop="DeptName" label="名称" show-overflow-tooltip sortable="custom" width="180">
      </el-table-column>
      <el-table-column prop="Remarks" label="备注" show-overflow-tooltip sortable="custom" width="180">
      </el-table-column>

      <el-table-column label="操作" min-width="120">
        <template #default="{ row }">
          <el-button type="primary" link :icon="Edit" @click="editData(row)" >
            编辑
          </el-button>
          <el-button type="danger" link :icon="Delete" @click="delData(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination style="margin-top: 8px;" v-model:current-page="currentPage" v-model:page-size="pageSize"
      :page-sizes="[100, 200, 300, 400]" :size="size" :disabled="total === 0" :background="background"
      layout="total, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
      @current-change="handleCurrentChange" />

  </ContentWrap>

  <Dialog v-model="dialogVisible" :title="dialogTitle">
    <el-form :model="form" label-width="auto" ref="ruleFormRef"  :rules="rules">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="编码" prop="DeptCode">
            <el-input :readonly="actionType === 'edit'" v-model="form.DeptCode" />
          </el-form-item>
        </el-col>
       
        <el-col :span="12">
          <el-form-item label="名称" prop="DeptName">
            <el-input v-model="form.DeptName" />
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="备注" prop="Remarks">
            <el-input v-model="form.Remarks" />
          </el-form-item>
        </el-col>

      </el-row>
    </el-form>
    <template #footer>
      <BaseButton v-if="actionType !== 'detail'" type="primary" :loading="saveLoading" @click="saveData(ruleFormRef)">
        保存
      </BaseButton>
      <BaseButton @click="dialogVisible = false">关闭</BaseButton>
    </template>
  </Dialog>
</template>

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
