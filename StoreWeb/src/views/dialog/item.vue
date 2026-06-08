<template> 
	<el-form :model="form" label-width="auto" ref="ruleFormRef" >
			<el-row :gutter="10">

				<el-col :span="6">
					<el-form-item label="物资编码" prop="code">
						<el-input v-model="form.code"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="物资名称" prop="name">
						<el-input v-model="form.name"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="英文名称" prop="EnName">
						<el-input v-model="form.EnName"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="助记号" prop="pym">
						<el-input v-model="form.pym"></el-input>
					</el-form-item>
				</el-col>
				<!-- <el-col :span="12">
						<el-form-item label="用途"  prop="usage">
							<el-input v-model="form.usage"></el-input>
						</el-form-item>
					</el-col> -->
				<el-col :span="6">
					<el-form-item label="型号规格" prop="spec">
						<el-input v-model="form.spec"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="英文规格" prop="EnSpec">
						<el-input v-model="form.EnSpec"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="级别" prop="levels">
						<el-input type="number" v-model="form.levels"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="物资类别" prop="category">

						<el-select v-model="form.category" placeholder="请选择">
							<el-option v-for="(item, index) in category" :label="item.name" :value="item.code">
							</el-option>

						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="计价方式" prop="costing">

						<el-select v-model="form.costing" placeholder="请选择">
							<el-option label="先进先出" value="FIFO">
							</el-option>
							<el-option label="后进先出" value="LIFO">
							</el-option>
							<el-option label="个别计价" value="SI">
							</el-option>
							<el-option label="移动平均" value="WMA">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="提前期" prop="ahnum">
						<el-input type="number" v-model="form.ahnum"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="库存单位" prop="maxqty">
						<el-input v-model="form.unit"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="采购单位" prop="maxqty">
						<el-input v-model="form.purunit"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="最高存量" prop="maxqty">
						<el-input type="number" v-model="form.maxqty"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="最低存量" prop="minqty">
						<el-input type="number" v-model="form.minqty"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="再定购点" prop="reorder">
						<el-input v-model="form.reorder"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="短益科目" prop="Overacc">
						<el-input v-model="form.Overacc"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="库存商品科目" prop="accno">

						<el-cascader v-model="form.accno" :options="treeitem" :props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="辅助帐号项目" prop="accno">

						<el-cascader v-model="form.cust4" :options="treeitem" :props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="货架号" prop="GoodsNo">
						<el-input v-model="form.GoodsNo"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="semigoods">

						<el-checkbox v-model="form.semigoods">半成品</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="stat">

						<el-checkbox v-model="form.stat">有效</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="piece">

						<el-checkbox v-model="form.piece">计件</el-checkbox>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="转换因子" prop="cvrnum">
						<el-input v-model="form.cvrnum" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="收货浮动" prop="pvftrate">
						<el-input v-model="form.pvftrate" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="经济批量" prop="oqnum">
						<el-input v-model="form.oqnum" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="转换比率" prop="convrate">
						<el-input v-model="form.convrate" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="慢移天数" prop="movedays">
						<el-input v-model="form.movedays" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="采购属性" prop="wrhsstat">

						<el-select v-model="form.wrhsstat" placeholder="请选择">
							<el-option label="仓库" value="0">
							</el-option>
							<el-option label="部门" value="1">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="备注" prop="memo">
						<el-input v-model="form.memo"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="flag">
						<el-checkbox v-model="form.flag" style="margin-left: 30px;">明细</el-checkbox>
					</el-form-item>
				</el-col>

			</el-row>
		</el-form>
</template>
<script setup lang="ts">
import { ref, onMounted } from 'vue'


const props = defineProps({
  form: {
    type: Object,
    default: () => ({})
  }
})

import request from '@/axios'
const category = ref<any[]>([])
const treeitem = ref<any[]>([])
const initData = async () => {
	console.log('initData')
	let res = await request.post({ url: '/api/ivitem/getTClass', data: {} })
	category.value = res.data || []
	res = await request.post({ url: '/api/config/getAccTree', data: {} })
	treeitem.value = res.data || []
}

onMounted(() => {
	initData()
})

</script>