<template>
  <Dialog v-model="dlgCondition" width="550px" max-height="400px" modal append-to-body :show-close="false"
    :close-on-click-modal="false" title="查询条件">
    <!-- <template #header>
      <div style="display: flex; height: 40px; line-height: 40px; background-color: #409EFF; margin: -20px;">
        <div style="flex: 1; text-align: left; color: #FFFFFF; margin-left: 20px;">查询</div>
        <div style="flex: 1; text-align: center; color: #FFFFFF;"></div>
        <div style="flex: 1; text-align: right;">
          <i class="el-icon-close closeico"
            style="color: #FFFFFF; font-size: 20px; line-height: 40px; margin-right: 20px; cursor: pointer"
            @click="dlgCondition = false"></i>
        </div>
      </div>
    </template> -->

    <el-table v-loading="listLoading" :data="list" border style="width: 100%" height="350px" id="out-table"
      size="small">
      <el-table-column align="left" prop="Name" label="项目" width="150px" />

      <el-table-column align="center" prop="CValue" label="值" width="250px">
        <template #default="{ row }">
          <!-- 年月选择器 -->
          <template v-if="row.DataType === 2 && row.SelCode === 'yyyy-MM'">
            <el-date-picker v-model="row.CValue" type="month" value-format="yyyy-MM" placeholder="选择日期"
              style="width: 175px" />
          </template>

          <!-- 日期选择器（有IsBillDate标记） -->
          <template v-else-if="row.IsBillDate && row.DataType === 2">
            <el-date-picker v-model="row.CValue" type="date" value-format="YYYY-MM-DD" placeholder="选择日期"
              style="width: 175px" />
          </template>

          <!-- 日期选择器（默认） -->
          <template v-else-if="row.DataType === 2">
            <el-date-picker v-model="row.CValue" type="date" value-format="YYYY-MM-DD" placeholder="选择日期"
              style="width: 175px" />
          </template>

          <!-- 数字输入框 -->
          <template v-else-if="row.DataType === 1">
            <el-input clearable v-model="row.CValue" type="number" placeholder="请输入查询值" style="width: 175px" />
          </template>

          <!-- 用户选择器 -->
          <template v-else-if="row.DataType === 0 && row.SelCode === 'uUser'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" filterable style="width: 175px">
              <el-option v-for="item in listData.usrs"  :label="item.name" :value="item.code" />
            </el-select>
          </template>

          <template v-else-if="row.DataType === 0 && row.SelCode === 'ItemCode'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" filterable style="width: 175px">
              <el-option v-for="item in listData.items"  :label="item.name" :value="item.code" />
            </el-select>
          </template>
       

          <!-- 状态选择器 -->
          <template v-else-if="row.DataType === 0 && row.SelCode === 'wrhsstat'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" style="width: 175px">
              <el-option v-for="item in wrhsstats" :label="item.label" :value="item.value" />

            </el-select>
          </template>
          <template v-else-if="row.DataType === 0 && row.SelCode === 'itemclass'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" style="width: 175px">
              <el-option v-for="item in listData.itemclass" :label="item.name" :value="item.code" />

            </el-select>
          </template>
          <template v-else-if="row.DataType === 0 && row.SelCode === 'itemgrade'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" style="width: 175px">
              <el-option v-for="item in levels" :label="item.label" :value="item.value+''" />

            </el-select>
          </template>
          

          <template v-else-if="row.DataType === 0 && row.Code === 'Level'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" filterable style="width: 175px">
              <el-option v-for="item in listData.levels"  :label="item.name" :value="item.code" />
            </el-select>
          </template>

          <template v-else-if="row.DataType === 0 && row.Code === 'Pos'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" filterable style="width: 175px">
              <el-option v-for="item in listData.storesdepts"  :label="item.name" :value="item.code" />
            </el-select>
          </template>

          
          <template v-else-if="row.DataType === 0 && row.Code === 'Dept'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" style="width: 175px">
              <el-option v-for="item in listData.depts" :label="item.name" :value="item.code" />
            </el-select>
          </template>

          <template v-else-if="row.DataType === 0 && row.Code === 'Cust'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" style="width: 175px">
              <el-option v-for="item in listData.custs" :label="item.name" :value="item.code" />
            </el-select>
          </template>

          <template v-else-if="row.DataType === 0 && row.Code === 'Wrhs'">
            <el-select clearable v-model="row.CValue" placeholder="请选择" style="width: 175px">
              <el-option v-for="item in listData.storesdepts" :label="item.name" :value="item.code" />
            </el-select>
          </template>

          

          <!-- 默认文本输入框 -->
          <template v-else>
            <el-input clearable v-model="row.CValue" placeholder="请输入查询值" style="width: 175px" />
          </template>
        </template>
      </el-table-column>
    </el-table>

    <el-row style="display: flex; justify-content: flex-end;margin-top: 15px;">
      <el-button type="primary" @click="confirmDlg">确定</el-button>
      <el-button @click="dlgCondition = false">关闭</el-button>
    </el-row>
  </Dialog>
</template>

<script setup lang="ts">
import { Dialog } from '@/components/Dialog'
import { ref,onMounted } from 'vue'
import request from '@/axios'
// 定义Props接口
interface Props {
  listLoading?: boolean
  list?: any[]
  alldata?: {
    clerk?: any[]
    item?: any[]
    shift?: any[]
    dtype?: any[]
    ctype?: any[]
    market?: any[]
    source?: any[]
    rmtype?: any[]
    coupon?: any[]
    ratecode?: any[]
  }
}

const wrhsstats = ref<any[]>([{
  value: '',
  label: '全部'
},
{
  value: '0',
  label: '仓库'
},
{
  value: '1',
  label: '部门'
}
])
const levels = ref<any[]>([{
	value: 0,
	label: '无级别'
},
{
	value: 1,
	label: '一级分类'
},
{
	value: 2,
	label: '二级分类'
},
{
	value: 3,
	label: '三级分类'
},
{
	value: 4,
	label: '四级分类'

},
{
	value: 5,
	label: '五级分类'
}
])

// 定义Emits
interface Emits {
  (e: 'update:visible', value: boolean): void
  (e: 'confirm'): void
}

// 接收Props
const props = withDefaults(defineProps<Props>(), {
  listLoading: false,
  list: () => []
})



const emit = defineEmits<Emits>()

// 弹窗显示控制
const dlgCondition = ref(false)

// 确认按钮处理
const confirmDlg = () => {
  emit('confirm')
  dlgCondition.value = false
}

const listData = ref<any>({
  usrs: [],
  items: [],
  levels: [],
  storesdepts: []
})

const initData = () => {
  request.post({ url: '/api/config/getRptData', data: {} }).then(res => {
    listData.value = res.data
  })
 
}
initData()  
// 暴露给父组件使用的方法
defineExpose({
  dlgCondition
})
</script>

<style scoped>
.closeico {
  cursor: pointer;
}

.closeico:hover {
  opacity: 0.8;
}
</style>