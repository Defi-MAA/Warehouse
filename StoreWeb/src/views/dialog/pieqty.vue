<template>
  <Dialog v-model="dlgPie" width="500px" :fullscreen="false" max-height="300px" modal append-to-body :show-close="false"
    :close-on-click-modal="false" title="辅助数量" @opened="handleOpened">
   
    <el-row>
      <el-col :span="24">
        <el-form-item label="辅助单位" prop="querytype">
          <el-input v-model="pieData.purunit" placeholder="" readonly></el-input>
        </el-form-item>        
      </el-col>
      <el-col :span="24">
        <el-form-item label="转换因子" prop="querytype">
          <el-input v-model="pieData.cvrnum" placeholder="" readonly></el-input>
        </el-form-item>        
      </el-col>
      <el-col :span="24">
        <el-form-item label="库存数量" prop="querytype">
          <el-input v-model="pieData.qty" placeholder="" readonly></el-input>
        </el-form-item>        
      </el-col>
      <el-col :span="24">
        <el-form-item label="辅助数量" prop="querytype">
          <el-input ref="pieqtyRef" v-model="pieData.pieqty"  @input="setQty" placeholder="请输入辅助数量" type="number"></el-input>
        </el-form-item>        
      </el-col>
      <el-col :span="24">
        <el-form-item label="" prop="querytype">
          说明：库存数量 = 辅助数量*转换因子
        </el-form-item>   
      </el-col>
    </el-row>
   

    <el-row style="display: flex; justify-content: flex-end;margin-top: 15px;">
      <el-button type="primary" @click="confirmDlg">确定</el-button>
      <el-button @click="dlgPie = false">关闭</el-button>
    </el-row>
  </Dialog>
</template>

<script setup lang="ts">
import { Dialog } from '@/components/Dialog'
import { ref,onMounted ,nextTick} from 'vue'
import { ElInput } from 'element-plus'
// 定义Props接口
interface Props {
  listLoading?: boolean
  list?: any[]
  pieData?: {
    purunit?: string
    cvrnum?: string
    pieqty?: string
    qty?: string
  }
}

// 定义Emits
interface Emits {
  (e: 'confirm',qty:number): void
}

// 接收Props
const props = withDefaults(defineProps<Props>(), {
  listLoading: false,
  list: () => [],
  pieData: {
    purunit: '',
    cvrnum: '',
    pieqty: '',
    qty: ''
  }
})


const emit = defineEmits<Emits>()

// 弹窗显示控制
const dlgPie = ref(false)

// 确认按钮处理
const confirmDlg = () => {
  let qty = Number(props.pieData.pieqty)*Number(props.pieData.cvrnum)
  emit('confirm',qty)
  dlgPie.value = false
}

const setQty = () => {
  let qty = Number(props.pieData.pieqty)*Number(props.pieData.cvrnum) 
  props.pieData.qty = qty.toFixed(2)
}

const pieqtyRef = ref<InstanceType<typeof ElInput> | null>(null);

// 弹窗动画完全结束后执行聚焦
const handleOpened = () => {
  pieqtyRef.value?.focus()
}

const initData = () => {
 
}
initData()  
// 暴露给父组件使用的方法
defineExpose({
  dlgPie
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